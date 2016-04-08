# ZKUDIDManager
Use identifierForVendor and keychain to make sure UDID(Unique Device Identifier) consistency after App delete or reinstall.

## 1. Install
```
pod 'ZKUDIDManager', '~> 1.0.1'
```

## 2. Usage
It's so simple, just two lines of code:

```
#include "ZKUDIDManager.h"
NSString* UIDIString = [ZKUDIDManager value];
```

## 3. Source files
They are in the `ZKUDIDManager` folder:   

- `ZKUDIDManager.h`  
- `ZKUDIDManager.m`  

Now, enjoy yourself!

