//
//  ZKUDIDManager.h
//  ZKUDIDManager
//
//  Created by Jack on 2/19/16.
//  Copyright © 2016 mushank. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZKUDIDManager : NSObject

/**
 *  @method             value, Requires iOS6.0 or above.
 *  @abstract           Obtain Unique Device Identity(UDID)
 *  @discussion         Use 'identifierForVendor + keychain' to make sure UDID consistency after App delete or reinstall.
 *  @param              NULL
 *  @param result       return UDID String
 */
+ (NSString *)value;


/**
 *  @method             selectKeychainItemWithIdentifier: serviceName:
 *  @abstract           To find out if the item already exists in the keychain
 *  @discussion
 *  @param              identifier
 *  @param              serviceName
 *  @param result       If exist, return the item, else return nil
 */
+ (NSData *)selectKeychainItemWithIdentifier:(NSString *)identifier serviceName:(NSString *)serviceName;

/**
 *  @method             insertKeychainItemWithValue: identifier: serviceName:
 *  @abstract           Insert an keychain item
 *  @discussion
 *  @param              value
 *  @param              identifier
 *  @param              serviceName
 *  @param result       If success, return YES, else return NO
 */
+ (BOOL)insertKeychainItemWithValue:(NSString *)value identifier:(NSString *)identifier serviceName:(NSString *)serviceName;

/**
 *  @method             updateKeychainItemWithValue: identifier: serviceName:
 *  @abstract           Update a keychain item
 *  @discussion
 *  @param              value
 *  @param              identifier
 *  @param              serviceName
 *  @param result       If exist, return UDID String, else return nil
 */
+ (BOOL)updateKeychainItemWithValue:(NSString *)value identifier:(NSString *)identifier  serviceName:(NSString *)serviceName;

/**
 *  @method             deleteKeychainItemWithIdentifier: serviceName:
 *  @abstract           Delete a keychain item
 *  @discussion
 *  @param              NULL
 *  @param              identifier
 *  @param              serviceName
 *  @param result       If success, return YES, else return NO
 */
+ (BOOL)deleteKeychainItemWithIdentifier:(NSString *)identifier serviceName:(NSString *)serviceName;

@end
