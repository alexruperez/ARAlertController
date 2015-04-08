# ARAlertController

[![Twitter](http://img.shields.io/badge/contact-@alexruperez-blue.svg?style=flat)](http://twitter.com/alexruperez)
[![GitHub Issues](http://img.shields.io/github/issues/alexruperez/ARAlertController.svg?style=flat)](http://github.com/alexruperez/ARAlertController/issues)
[![CI Status](http://img.shields.io/travis/alexruperez/ARAlertController.svg?style=flat)](https://travis-ci.org/alexruperez/ARAlertController)
[![Version](https://img.shields.io/cocoapods/v/ARAlertController.svg?style=flat)](http://cocoadocs.org/docsets/ARAlertController)
[![License](https://img.shields.io/cocoapods/l/ARAlertController.svg?style=flat)](http://cocoadocs.org/docsets/ARAlertController)
[![Platform](https://img.shields.io/cocoapods/p/ARAlertController.svg?style=flat)](http://cocoadocs.org/docsets/ARAlertController)
[![Analytics](https://ga-beacon.appspot.com/UA-55329295-1/ARAlertController/readme?pixel)](https://github.com/igrigorik/ga-beacon)

## Overview

UIAlertController compatible iOS >= 5.0

#### iOS >= 8
![ARAlertController iOS8 Alert](https://raw.githubusercontent.com/alexruperez/ARAlertController/master/alert8.png) ![ARAlertController iOS8 ActionSheet](https://raw.githubusercontent.com/alexruperez/ARAlertController/master/sheet8.png)

#### iOS <= 7
![ARAlertController iOS7 Alert](https://raw.githubusercontent.com/alexruperez/ARAlertController/master/alert7.png) ![ARAlertController iOS7 ActionSheet](https://raw.githubusercontent.com/alexruperez/ARAlertController/master/sheet7.png)

## Usage

### Installation

ARAlertController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod 'ARAlertController'

#### Or you can add the following files to your project:
* `ARAlertController.m`
* `ARAlertController.h`

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Example

```objectivec
ARAlertController *alert = [ARAlertController alertControllerWithTitle:@"My Alert" message:@"This is an alert." preferredStyle:ARAlertControllerStyleAlert];

ARAlertAction* defaultAction = [ARAlertAction actionWithTitle:@"OK" style:ARAlertActionStyleDefault handler:^(ARAlertAction * action) {}];

[alert addAction:defaultAction];

[alert presentInViewController:self animated:YES completion:nil];
```

# Etc.

* Contributions are very welcome.
* Attribution is appreciated (let's spread the word!), but not mandatory.

## Use it? Love/hate it?

Tweet the author [@alexruperez](http://twitter.com/alexruperez), and check out alexruperez's blog: http://alexruperez.com

## License

ARAlertController is available under the MIT license. See the LICENSE file for more info.