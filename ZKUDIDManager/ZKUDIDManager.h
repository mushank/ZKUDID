//
//  ZKUDIDManager.h
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

#import <Foundation/Foundation.h>


@interface ZKUDIDManager : NSObject

///========================================================================
///=== Usually, the method `+ (NSString *)value` is enough for you to use.
///========================================================================
/**
 *  @method             value, Requires iOS6.0 or above.
 *  @abstract           Obtain Unique Device Identity(UDID). If it already exits, return the exit one, otherwise generate a new one and store it into the keychain then return.
 *  @discussion         Use 'identifierForVendor + keychain' to make sure UDID consistency after App delete or reinstall.
 *  @param              NULL
 *  @param result       return UDID String
 */
+ (NSString *)value;


#pragma mark - Extension Method: Insert, Delete, Update, Select
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
