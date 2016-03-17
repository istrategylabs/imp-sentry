class SentryLogger {
	static _thirteenthDigit = 13
	static _seventeenthDigit = 17
	static _seventeenthDigitValues = ["8", "9", "a", "b"]
	sentryBaseURI = null
	sentryKey = null
	sentrySecret = null
	XSentryAuth = null
	headers = null

	constructor(baseURI, key, secret) {
		sentryBaseURI = baseURI
		sentryKey = key
		sentrySecret = secret
		XSentryAuth = format("Sentry sentry_version=7, sentry_timestamp=%i, sentry_key=%s, sentry_secret=%s, sentry_client=http-post/1.0", time(), key, secret)
		headers = { "User-Agent": "http-post/1.0", 
					"Content-Type": "application/json", 
					"X-Sentry-Auth":  XSentryAuth
		}
	}

	function _irand(max) {
		// Generate a pseudo-random integer between 0 and max
		// referenced from: https://electricimp.com/docs/squirrel/math/rand/
		local roll = (1.0 * math.rand() / RAND_MAX) * (max + 1)
		return roll.tointeger()
	}

	function _generateUUID() {
		local uuid = ""

		for (local i = 1; i <= 32 ; i++) {
			// Based on UUID specs the 13th digit must be a 4
			if (i == _thirteenthDigit) {
				// place in a 4
				uuid = uuid + "4"
			} else if (i == _seventeenthDigit) {
				uuid = uuid + _seventeenthDigitValues[_irand(3)]
			} else {
				local random = _irand(35)

				if (random < 10) {
					uuid = uuid + random.tostring()
				} else { // 10 <= random <= 35
					random = random + 87
					// 97 is ASCII 'a'
					// 122 is ASCII 'z'
					uuid = uuid + random.tochar()
				}
			}
		}

		return uuid
	}

	function _getTimestamp() {
		local now = date()
		//"2011-05-02T17:41:36"
		return format("%04d-%02d-%02dT%02d:%02d:%02d", now.year, now.month + 1, now.day, now.hour, now.min, now.sec)		
	}

	function sendErrorToSentry(message, logger, errorMessage, deviceID) {
		local uuid = _generateUUID()
		local timestamp = _getTimestamp()

		local data = {
				"event_id": uuid,
				"message": message,
				"timestamp": timestamp,
				"level": "error",
				"logger": logger,
				"platform": "other",
				"extra": {
					"errorMessage": errorMessage,
					"deviceID": deviceID
				}
		}
		local body = http.jsonencode(data)

		http.post(sentryBaseURI, headers, body).sendasync(function(res) {
			if (res.statuscode != 200) {
				server.log("Sentry error: " + res.statuscode + " => " + res.body)
			} else {
				try {
					server.log("Status: " + res.statuscode)
					server.log("Res Body: " + res.body)
				} catch(ex) {
					server.log(ex)
				}
			}
		})
	}
}

// Usage:
//
// logger <- SentryLogger("{{ SENTRY_BASE_URI }}", "{{ SENTRY_KEY }}", "{{ SENTRY_SECRET }}")
// logger.sendErrorToSentry("message", "logger", "errorMessage", "deviceID")
