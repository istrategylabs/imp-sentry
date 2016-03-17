# :smiling_imp: Sentry Logger 1.0.0 :smiling_imp:

This Squirrel class implements logging to the Sentry platform. Simply call the `log` method to start logging your errors.

## Installation

1. Copy the class `SentryLogger` from `imp-sentry.nut` and place on the first line of your agent code.
2. Init the class with `sentryLogger <- SentryLogger(SENTRY_BASE_URI, SENTRY_KEY, SENTRY_SECRET)`

## Class Usage
```
sentryLogger.log("message", "logger", "errorMessage", "deviceID")
```

argument       | info                                        |
:------:       | :-----------------------------------------: |
`message`      | Message title shown under Unresolved Issues |
`logger`       | function that caused the error              |
`errorMessage` | further details into the error              |
`device`       | a deviceID to identify which device failed  |

## Expected Response

```
[Agent]	Status: 200
[Agent]	Res Body: {"id":"ugx38lujbkag4hgb9xhun4g6j7tenqhv"}
```

## Example Usage

```
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
```

## References

* https://docs.getsentry.com/hosted/clientdev/attributes/
* https://docs.getsentry.com/hosted/clientdev/#a-working-example

## License

The Sentry Logger class is licensed under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0)