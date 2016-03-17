# :smiling_imp: Sentry Logger 1.0.0 :smiling_imp:
Electric Imp class to send errors to the Sentry platform

## usage
```
logger <- SentryLogger(SENTRY_BASE_URI, SENTRY_KEY, SENTRY_SECRET)
logger.sendErrorToSentry("message", "logger", "errorMessage", "deviceID")
```

* message is the message title you will see in Sentry
* logger refers to the `function` that caused the crash
* errorMessage can be anything you like, I tend to use the `(ex)` from a `try-catch` statement
* deviceID should be set to the special imp device you are using

## references

* https://docs.getsentry.com/hosted/clientdev/attributes/
* https://docs.getsentry.com/hosted/clientdev/#a-working-example