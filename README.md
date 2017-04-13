# ZKUDID

[![Travis-CI](https://travis-ci.org/mushank/ZKUDID.svg?branch=master)](https://travis-ci.org/mushank/ZKUDID) [![Carthage](https://img.shields.io/badge/carthage-compatible-green.svg)](https://github.com/Carthage/Carthage) [![CocoaPods](https://img.shields.io/badge/pod-2.0-green.svg)](http://cocoapods.org/?q=ZKUDID) [![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](http://www.apple.com/ios) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/mushank/ZKUDID/blob/master/LICENSE)


**Generate and save permanent UDID with IDFV and keychain in iOS device.**

*Use `IDFV(identifierForVendor)` + `keychain` to make sure UDID consistency, even if the App has been removed or reinstalled.*

*A replacement for the deprecated mean of `OpenUDID`.*

## Install

#### CocoaPods

Available through [CocoaPods](http://cocoapods.org/), simply add the following line to your Podfile:

```
pod 'ZKUDID', '~> 2.0'
```

#### Carthage

Available through [Carthage](https://github.com/Carthage/Carthage), simply add the following line to your Cartfile:

```
github "mushank/ZKUDID" ~> 2.0
```

*Noti: Requires iOS 6.0 or later*

## Usage
It's so simple, just two lines of code:

```
#include "ZKUDID.h"
NSString *UDIDString = [ZKUDID value];
```

⚠️***Attention:*** *If you get the value `(null)`, please check your `KeyChain Entitlemen` setting: Go to project settings->Capabilities->Keychain Sharing->Add Keychain Groups+Turn On*. It usually happens in iOS 10.

## Source files

They are in the `ZKUDID` folder:   

- `ZKUDID.h`  
- `ZKUDID.m`  

Now, enjoy yourself!

## License

ZKUDID is released under [MIT License](https://github.com/mushank/ZKUDID/blob/master/LICENSE).