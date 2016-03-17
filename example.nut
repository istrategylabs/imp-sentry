class SentryLogger {}
sentryLogger <- SentryLogger(SENTRY_BASE_URI, SENTRY_KEY, SENTRY_SECRET)

function postData() {
	local url = "https://www.yourwebservice.com"
	local headers
	local body

	http.post(url, headers, body).sendasync(function(res) {
		if (res.statuscode != 200) {
				sentryLogger.log("Error posting to API", "postData", res.body, DEVICE_ID)
		} else {
			// success
		}
	})
}