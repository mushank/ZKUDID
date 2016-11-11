# ZKUDIDManager

[![](https://img.shields.io/badge/Pod-1.0.7-blue.svg)](http://cocoapods.org/?q=ZKUDIDManager) [![](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)](http://www.apple.com/ios)  [![License MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://github.com/mushank/ZKUDIDManager/blob/master/LICENSE)


**Generate and save permanent UDID with IDFV and keychain in iOS device.**

*Use `IDFV(identifierForVendor)` + `keychain` to make sure UDID consistency, even if the App has been removed or reinstalled.*

*A replacement for the deprecated mean of `OpenUDID`.*

## Install

```
pod 'ZKUDIDManager', '~> 1.0.7'
```

*Noti: Requires iOS6.0 and later*

## Usage
It's so simple, just two lines of code:

```
#include "ZKUDIDManager.h"
NSString *UIDIString = [ZKUDIDManager value];
```

⚠️***Attention:*** *If you get the value `(null)`, please check your `KeyChain Entitlemen` setting: Go to project settings->Capabilities->Keychain Sharing->Add Keychain Groups+Turn On*. It usually happens in iOS 10.

## Source files

They are in the `ZKUDIDManager` folder:   

- `ZKUDIDManager.h`  
- `ZKUDIDManager.m`  

Now, enjoy yourself!

## License

ZKUDIDManager is released under [MIT License](https://github.com/mushank/ZKUDIDManager/blob/master/LICENSE).