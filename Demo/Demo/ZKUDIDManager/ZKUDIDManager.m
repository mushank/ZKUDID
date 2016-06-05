//
//  ZKUDIDManager.m
//  ZKUDIDManager
//
//  https://github.com/mushank/ZKUDIDManager
//
//  Created by Jack on 2/19/16.
//  Copyright © 2016 mushank. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "ZKUDIDManager.h"
#import <UIKit/UIKit.h>


static NSString *kKeychainUDIDItemIdentifier    = @"UDID";   /* Replace with your own UDID identifier */
static NSString *kKeychainUDIDItemServiceName   = @"com.mushank.ZKUDIDManager"; /* Replace with your own service name, usually you can use your App Bundle ID */

@implementation ZKUDIDManager

+ (NSString *)value
{
    static NSString* value;
    if (!value) {
        @synchronized ([self class]) {
            if (!value) {
                NSData *itemData = [ZKUDIDManager selectKeychainItemWithIdentifier:kKeychainUDIDItemIdentifier serviceName:kKeychainUDIDItemServiceName];
                if (itemData) {
                    value = [[NSString alloc]initWithData:itemData encoding:NSUTF8StringEncoding];
                } else {
                    NSString *IDFVString = [ZKUDIDManager getIDFVString];
                    BOOL isInsertSuccess = [ZKUDIDManager insertKeychainItemWithValue:IDFVString identifier:kKeychainUDIDItemIdentifier serviceName:kKeychainUDIDItemServiceName];
                    if (isInsertSuccess) {
                        value = IDFVString;
                    }
                }            
            }
        }
    }
    
    return value;
}

#pragma mark - Extension Method: Insert / Delete / Update / Select
/**
 *  To find out if our UDID string already exists in the keychain (and what the value of the UDID string is), we use the `SecItemCopyMatching` function.
 */
+ (NSData *)selectKeychainItemWithIdentifier:(NSString *)identifier serviceName:(NSString *)serviceName
{
    NSMutableDictionary *dicForSelect = [self baseAttributeDictionary:identifier serviceName:serviceName];
    
    /**
     *  key `kSecMatchLimit` is to limit the number of search results that returned. We are looking for a single entry so we set the attribute to `kSecMatchLimitOne`.
     */
    [dicForSelect setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    
    /**
     *  key `kSecReturnData` determines how the result is returned. Since we are expecting only a single attribute to be returned (the UDID string) we can set it to `kCFBooleanTrue`. This means we will get an NSData reference back that we can access directly.
     */
    [dicForSelect setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    /** !!!
     *  If we were storing and searching for a keychain item with multiple attributes (for example if we were storing an account name and password in the same keychain item) we would need to add the attribute `kSecReturnAttributes` and the result would be a dictionary of attributes.
     */
    
    NSData *result = nil;
    OSStatus status = SecItemCopyMatching((CFDictionaryRef)dicForSelect, (void *)&result);
    if (status == errSecSuccess) {
        NSLog(@"Select KeyChain Item Success with result: %@", [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding]);
    } else {
        NSLog(@"Select KeyChain Item Failure with errCode: %d", (int)status);
    }
    
    return result;
}

/**
 *  Inserting an keychain item is almost the same as the select function except that we need to set the value of the UDID string which we want to store. We use the `SecItemAdd` function.
 */
+ (BOOL)insertKeychainItemWithValue:(NSString *)value identifier:(NSString *)identifier serviceName:(NSString *)serviceName
{
    NSMutableDictionary *dicForInsert = [self baseAttributeDictionary:identifier serviceName:serviceName];
    
    /**
     *  Add the key `kSecValueData` to the attribute dictionary to set the value of the keychain item(here means the UDID string), besides making sure encode the value string
     */
    NSData *dataForInsert = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dicForInsert setObject:dataForInsert forKey:(id)kSecValueData];
    
    OSStatus status = SecItemAdd((CFDictionaryRef)dicForInsert, NULL);
    if (status == errSecSuccess) {
        NSLog(@"Insert KeyChain Item Success with value: %@", value);
        return YES;
    } else {
        NSLog(@"Insert KeyChain Item Failure with errCode: %d", (int)status);
    }
    
    return NO;
}

/**
 *  Updating a keychain item is similar to inserting an item except that a separate dictionary is used to contain the attributes to be updated. We use the `SecItemUpdate` function.
 */
+ (BOOL)updateKeychainItemWithValue:(NSString *)value identifier:(NSString *)identifier serviceName:(NSString *)serviceName
{
    NSMutableDictionary *dicForSelect = [self baseAttributeDictionary:identifier serviceName:serviceName];
    
    NSMutableDictionary *dicForUpdate = [[NSMutableDictionary alloc]init];
    NSData *dataForUpdate = [value dataUsingEncoding:NSUTF8StringEncoding];
    [dicForUpdate setObject:dataForUpdate forKey:(id)kSecValueData];
    
    OSStatus status = SecItemUpdate((CFDictionaryRef)dicForSelect, (CFDictionaryRef)dicForUpdate);
    if (status == errSecSuccess) {
        NSLog(@"Update KeyChain Item Success with value: %@", value);
        return YES;
    } else {
        NSLog(@"Update KeyChain Item Failure with errCode: %d", (int)status);
    }
    
    return NO;
}

/**
 *  To delete an item from the keychain, we use the `SecItemDelete` function.
 */
+ (BOOL)deleteKeychainItemWithIdentifier:(NSString *)identifier serviceName:(NSString *)serviceName
{
    NSMutableDictionary *dicForDelete = [self baseAttributeDictionary:identifier serviceName:serviceName];
    
    OSStatus status = SecItemDelete((CFDictionaryRef)dicForDelete);
    if (status == errSecSuccess) {
        NSLog(@"Delete KeyChain Item Success with Identifier: %@ serviceName: %@", identifier, serviceName);
        return YES;
    } else {
        NSLog(@"Delete KeyChain Item Failure with errCode: %i", (int)status);
    }
    
    return NO;
}

#pragma mark - Private Method
/**
 *  get identifierForVendor String
 */
+ (NSString *)getIDFVString
{
    NSString *IDFVString = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    return IDFVString;
}

/**
 *  This function allocates and constructs a dictionary which defines the attributes of the keychain item you want to insert, delete, update or select.
 */
+ (NSMutableDictionary *)baseAttributeDictionary:(NSString *)identifier serviceName:(NSString *)serviceName
{
    NSMutableDictionary *baseAttributeDictionary = [[NSMutableDictionary alloc] init];
    
    /**
     *  key `kSecClass` defines the class of the keychain item we will be dealing with. I want to store a UDID string(more like a password) into the keychain so I use `kSecClassGenericPassword` for the key's value.
     */
    [baseAttributeDictionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    
    /**
     *  key `kSecAttrGeneric` is what we will use to identify the keychain item. It can be any value we choose such as “Password” or “License”, etc. To be clear this is not the actual value of the keychain item just a label we will attach to this keychain item so we can find it later. In theory our application could store a number of items in the keychain so we need to have a way to identify this particular one from the others. The value for the key `kSecAttrGeneric` has to be encoded before being added to the dictionary.
     */
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [baseAttributeDictionary setObject:encodedIdentifier forKey:(id)kSecAttrGeneric];
    
    /**
     *  key `kSecAttrAccount` and `kSecAttrService` should be set to something unique for this keychain.
     */
    [baseAttributeDictionary setObject:encodedIdentifier forKey:(id)kSecAttrAccount];
    [baseAttributeDictionary setObject:serviceName forKey:(id)kSecAttrService];
    
    return baseAttributeDictionary;
}


@end
