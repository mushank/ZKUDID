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
 *  @method             getUUIDFVString, Requires iOS6.0 or above.
 *  @abstract           Obtain UUIDString of identifierForVendor
 *  @discussion
 *  @param              NULL
 *  @param result       return UUIDString of identifierForVendor
 */
+ (NSString *)getUUIDFVString;

/**
 *  @method             readUDIDFromKeychain
 *  @abstract
 *  @discussion
 *  @param              NULL
 *  @param result       If exist, return UDID String, else return nil
 */
+ (NSString *)readUDIDFromKeychain;

/**
 *  @method             writeUDIDToKeychain:
 *  @abstract
 *  @discussion
 *  @param              UDIDString
 *  @param result       If success, return YES, else return NO
 */
+ (BOOL)writeUDIDToKeychain:(NSString *)UDIDString;

/**
 *  @method             updateUDIDInKeychain:
 *  @abstract
 *  @discussion
 *  @param              newUDIDString
 *  @param result       If success, return YES, else return NO
 */
+ (BOOL)updateUDIDInKeychain:(NSString *)newUDIDString;

/**
 *  @method             removeUDIDFromKeychain
 *  @abstract
 *  @discussion
 *  @param              NULL
 *  @param result       If success, return YES, else return NO
 */
+ (BOOL)removeUDIDFromKeychain;

@end
