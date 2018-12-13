# Changelog

## Version: 0.1.1

* Decoupled the data-processing and data-transmission into seperate stages implemented by genservers. 
The module `Quack.Mama` handles the formatting and encoding of events, while `Quack.Duckling` is now only
respoinsible for hitting the webhook.

* The webhook url is no longer fetched during each request made by `Quack.Messenger`, instead it is fetched during
the startup of `Quack.Duckling` and is maintained as the state of the genserver.

## Version: 0.1.0

Initial release of Quack