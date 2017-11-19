//
//  PermissionContactInfoFields.h
//  Demo
//
//  Created by Ahmet Kazım Günay on 02/04/15.
//  Copyright (c) 2015 Ahmet Kazım Günay. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// All of the descriptions copied from  Linkedin Developer Site
// For More Informations https://developer.linkedin.com/docs/fields/contact
//

@interface PermissionContactInfoFields : NSObject

/*!
 * @brief A collection of phone number objects.
 */
extern NSString * const phone_numbers;

/*!
 * @brief A collection of accounts bound by the member.
 */
extern NSString * const bound_account_types;

/*!
 * @brief A collection of instant messenger accounts associated with the member.
 */
extern NSString * const im_accounts;

/*!
 * @brief The member's primary address.  We do not specify whether this is a work, home or other address.
 */
extern NSString * const main_address;

/*!
 * @brief A collection of Twitter accounts associated with the member.
 */
extern NSString * const twitter_accounts;

/*!
 * @brief The primary Twitter account associated with the member.
 */
extern NSString * const primary_twitter_account;

@end
