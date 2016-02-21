//
//  ZKUDIDManager.m
//  ZKUDIDManager
//
//  Created by Jack on 2/19/16.
//  Copyright © 2016 mushank. All rights reserved.
//

#import "ZKUDIDManager.h"
#import <UIKit/UIKit.h>

static const char kKeychainUDIDItemIdentifier[] = "UDID";                /* Replace with your own UDID key  string */
static const char kKeychainUDIDAccessGroup[]    = "mushank.com.appName"; /* Replace with your own App Bundle identifier */

@implementation ZKUDIDManager

+ (NSString *)value
{
    NSString *value = [ZKUDIDManager readUDIDFromKeychain];
    if (!value) {
        value = [ZKUDIDManager getUUIDFVString];
        BOOL isSuccess = [ZKUDIDManager writeUDIDToKeychain:value];
        if (!isSuccess) {
            value = nil;
        }
    }
    
    return value;
}


#pragma mark - get identifierForVendor String
+ (NSString *)getUUIDFVString
{
    NSString *UUIDFVString = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    return UUIDFVString;
}


#pragma mark - make IDFVString consistency with keyChain
+ (NSString *)readUDIDFromKeychain
{
    NSMutableDictionary *dicForQuery = [[NSMutableDictionary alloc]init];
    [dicForQuery setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    // set Attr Description for query
    [dicForQuery setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier] forKey:(__bridge NSString *)kSecAttrDescription];
    // set Attr Identifier for query
    NSData *keychainItemData = [NSData dataWithBytes:kKeychainUDIDItemIdentifier length:strlen(kKeychainUDIDItemIdentifier)];
    [dicForQuery setObject:keychainItemData forKey:(id)kSecAttrGeneric];
    
    // the keychain access group attribute determines if this item can be shared amongst multiple apps whose code signing entitlements contain the same keychain access group
    NSString *accessGroup = [NSString stringWithUTF8String:kKeychainUDIDAccessGroup];
    if (!accessGroup) {
#if TARGET_OS_SIMULATOR
        // Ignore the access group if running on the simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
#else
        [dicForQuery setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
    }
    
    // case-Insensitive
    [dicForQuery setValue:(id)kCFBooleanTrue forKey:(id)kSecMatchCaseInsensitive];
    // Only want one match
    [dicForQuery setValue:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    // Only one value being searched only need a bool to tell us if it was successful
    [dicForQuery setValue:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    [dicForQuery setValue:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
    
    [dicForQuery setObject:@"MY_APP_CREDENTIALS" forKey:(id)kSecAttrService];

    OSStatus    queryErr = noErr;
    NSData      *UDIDData = nil;
    NSString    *UDIDString = nil;
    
    queryErr = SecItemCopyMatching(((__bridge CFDictionaryRef)dicForQuery), (void *)&UDIDData);
    
    if (queryErr == errSecSuccess) {
        NSLog(@"Keychain Item: %@", UDIDData);
        if (UDIDData) {
            UDIDString = [NSString stringWithUTF8String:UDIDData.bytes];
        }
    } else if (queryErr == errSecItemNotFound) {
        NSLog(@"Keychain Item: %@ not found!", [NSString stringWithUTF8String:kKeychainUDIDItemIdentifier]);
    } else {
        NSLog(@"Keychain Item query Error! Error code: %d", (int)queryErr);
    }
    
    return UDIDString;
}

+ (BOOL)writeUDIDToKeychain:(NSString *)UDIDString
{
    NSMutableDictionary *dicForWrite = [[NSMutableDictionary alloc]init];
    
    [dicForWrite setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [dicForWrite setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier] forKey:(__bridge NSString *)kSecAttrDescription];
    
    [dicForWrite setValue:@"UUID" forKey:(id)kSecAttrGeneric];
    [dicForWrite setObject:@"" forKey:(id)kSecAttrAccount];
    [dicForWrite setObject:@"" forKey:(id)kSecAttrLabel];
    
    NSString *accessGroup = [NSString stringWithUTF8String:kKeychainUDIDAccessGroup];
    if (!accessGroup) {
#if TARGET_IPHONE_SIMULATOR
        // Ignore the access group if running on the simulator.
        //
        // Apps that are built for the simulator aren't signed, so there's no keychain access group
        // for the simulator to check. This means that all apps can see all keychain items when run
        // on the simulator.
        //
        // If a SecItem contains an access group attribute, SecItemAdd and SecItemUpdate on the
        // simulator will return -25243 (errSecNoAccessForItem).
#else
        [dicForWrite setObject:accessGroup forKey:(id)kSecAttrAccessGroup];
#endif
    }
    
    const char *UDIDValue = [UDIDString UTF8String];
    NSData *keychainItemData = [NSData dataWithBytes:UDIDValue length:strlen(UDIDValue)];
    [dicForWrite setValue:keychainItemData forKey:(id)kSecValueData];
    
    [dicForWrite setObject:@"MY_APP_CREDENTIALS" forKey:(id)kSecAttrService];
    
    OSStatus writeErr = noErr;
    if ([ZKUDIDManager readUDIDFromKeychain]) { // if there is already item in keychain, then update it
        BOOL isUpdateSuccess = [ZKUDIDManager updateUDIDInKeychain:UDIDString];
        if (!isUpdateSuccess) {
            return NO;
        }
    } else {    // if there is no item in keychain, then add it
        writeErr = SecItemAdd((__bridge CFDictionaryRef)dicForWrite, NULL);
        
        if (writeErr == errSecSuccess) {
            NSLog(@"Add KeyChain Item Success!");
        } else {
            NSLog(@"Add KeyChain Item Error! Error Code: %d", (int)writeErr);
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)updateUDIDInKeychain:(NSString *)newUDIDString
{
    NSMutableDictionary *dicForQuery = [[NSMutableDictionary alloc] init];
    
    [dicForQuery setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    NSData *keychainItemData = [NSData dataWithBytes:kKeychainUDIDItemIdentifier
                                              length:strlen(kKeychainUDIDItemIdentifier)];
    [dicForQuery setValue:keychainItemData         forKey:(id)kSecAttrGeneric];
    [dicForQuery setValue:(id)kCFBooleanTrue       forKey:(id)kSecMatchCaseInsensitive];
    [dicForQuery setValue:(id)kSecMatchLimitOne    forKey:(id)kSecMatchLimit];
    [dicForQuery setValue:(id)kCFBooleanTrue       forKey:(id)kSecReturnAttributes];
    [dicForQuery setObject:@"MY_APP_CREDENTIALS"   forKey:(id)kSecAttrService];
    
    NSDictionary *queryResultDic = nil;
    SecItemCopyMatching((__bridge CFDictionaryRef)dicForQuery, (void *)&queryResultDic);
    if (queryResultDic) {
        
        NSMutableDictionary *dicForUpdate = [[NSMutableDictionary alloc] init];
        [dicForUpdate setValue:[NSString stringWithUTF8String:kKeychainUDIDItemIdentifier] forKey:(__bridge NSString *)kSecAttrDescription];
        [dicForUpdate setValue:keychainItemData forKey:(id)kSecAttrGeneric];
        [dicForUpdate setObject:@"MY_APP_CREDENTIALS"   forKey:(id)kSecAttrService];

        const char *UDIDValue = [newUDIDString UTF8String];
        NSData *keychainItemData = [NSData dataWithBytes:UDIDValue length:strlen(UDIDValue)];
        [dicForUpdate setValue:keychainItemData forKey:(id)kSecValueData];
        
        // First we need the attributes from the keychain.
        NSMutableDictionary *updateItemDic = [NSMutableDictionary dictionaryWithDictionary:queryResultDic];
        // Second we need to add the appropriate search key/values, set kSecClass is very important.
        [updateItemDic setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
        
        OSStatus updateErr = noErr;
        updateErr = SecItemUpdate((__bridge CFDictionaryRef)updateItemDic, (CFDictionaryRef)dicForUpdate);
        if (updateErr == errSecSuccess) {
            NSLog(@"Update KeyChain Item Success!");
        } else {
            NSLog(@"Update KeyChain Item Error! Error Code : %d", (int)updateErr);
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)removeUDIDFromKeychain
{
    NSMutableDictionary *dicForRemove = [[NSMutableDictionary alloc]init];
    
    [dicForRemove setValue:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    NSData *keychainItemData = [NSData dataWithBytes:kKeychainUDIDItemIdentifier
                                              length:strlen(kKeychainUDIDItemIdentifier)];
    [dicForRemove setValue:keychainItemData forKey:(id)kSecAttrGeneric];
    [dicForRemove setObject:@"MY_APP_CREDENTIALS" forKey:(id)kSecAttrService];

    OSStatus removeErr = noErr;
    removeErr = SecItemDelete((__bridge CFDictionaryRef)dicForRemove);
    if (removeErr == errSecSuccess) {
        NSLog(@"Remove Item from Keychain Success!");
    } else {
        NSLog(@"Remove Item from Keychain Error! Error code : %d", (int)removeErr);
        return NO;
    }
    
    return YES;
}

@end
