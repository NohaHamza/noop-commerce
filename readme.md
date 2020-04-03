# E-Commerce Mobile App for iOS and Android, built with Flutter that connects with Mezzanine

A complete e-commerce starter app with customisable [Material Design](https://material.io/) theme built with [Flutter](https://flutter.dev/) that connects to a [Mezzanine CMS](http://mezzanine.jupo.org/) installation, and integrates with [Stripe](https://stripe.com/), or with any of the [configurable payment handlers](http://cartridge.jupo.org/integration.html#payment).

[See the accompanying blog post.](https://www.indecorous.online/blog/so-you-want-an-e-commerce-website-with-phone-apps-to-go-with-it/)

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/sTZBGpQ)

## Features

The Flutter app includes all of the original e-commerce features of a Mezzanine Cartridge website as viewed on a phone, but is built with the user journey on a phone specifically in mind. Here is a [side-by-side comparison of the mobile web version (with the default theme) and this app](http://jackvz.github.io/flutter-app-with-mezzanine/index.html). In addition to the updated layout of the app's views, the app also only connects to the backend during startup to load settings, products, categories etc., and when placing orders, so that data is not loaded repeatedly for every view. And of course, it would be native phone apps and be available on the [App Store](https://flutter.dev/docs/deployment/ios) and [Play Store](https://play.google.com/).

## Demos

[iOS Demo](https://appetize.io/app/151kkwtrt6wh2rf2z48hcj581w)

[Android Demo](https://appetize.io/app/39413n14h7nb40ae7802v2k7rc)

### Photo credits

- [Squared.one](https://www.squared.one/)
- [Mel Poole](https://unsplash.com/@melipoole)
- [Joanna Kosinska](https://joannak.co.uk)
- [@Bram.](https://unsplash.com/@br_am)
- [Leio McLaren](https://www.instagram.com/leiomclaren/)
- [Roland Denes](https://denesroland.com/)
- [Tyler Nix](https://www.tylernixcreative.com/)

## Getting Started

### Sign up for [Heroku](https://www.heroku.com/), [Amazon Web Services](https://aws.amazon.com/) and [Stripe](https://stripe.com/)

## Set up the CMS

### Set up a Mezzanine e-commerce CMS project with an accessible API

Set up a Mezzanine e-commerce installation on Heroku, with API endpoints for mobile apps with [this project](https://github.com/jackvz/mezzanine-cms-on-heroku). You can just use the _Deploy to Heroku_ button.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/jackvz/mezzanine-cms-on-heroku)

#### Add products

#### Add an API key

## Theme

### Install [Flutter](https://flutter.dev/docs/get-started/install)

### Configure the app
Update [lib/config.dart](./lib/config.dart) with your settings

### Run the app

Run:
```sh
flutter packages get
flutter packages pub run build_runner build
flutter run
```

### Customise the theme

See the [Flutter docs for creating a custom Material Design theme](https://flutter.dev/docs/cookbook/design/themes). The MaterialApp constructor is in [lib/main.dart](./lib/main.dart).

## Deploy

See the Flutter docs for building and releasing for [iOS](https://flutter.dev/docs/deployment/ios) and [Android](https://flutter.dev/docs/deployment/android).
