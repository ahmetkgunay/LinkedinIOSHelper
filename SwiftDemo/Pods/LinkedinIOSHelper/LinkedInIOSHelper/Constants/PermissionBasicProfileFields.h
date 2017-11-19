//
//  PermissionBasicProfileFields.h
//  Demo
//
//  Created by Ahmet Kazım Günay on 02/04/15.
//  Copyright (c) 2015 Ahmet Kazım Günay. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// All of the descriptions copied from  Linkedin Developer Site
// You can have more comprehensive descriptions from https://developer.linkedin.com/docs/fields/basic-profile
//


@interface PermissionBasicProfileFields : NSObject

/*!
 * @brief A unique identifying value for the member.
 *
 * This value is linked to your specific application.  Any attempts to use it with a different application will result in a "404 - Invalid member id" error.
 */
extern NSString * const Id;

/*!
 * @brief The member's first name.
 */
extern NSString * const first_name;

/*!
 * @brief The member's last name.
 */
extern NSString * const last_name;

/*!
 * @brief The member's maiden name.
 */
extern NSString * const maiden_name;

/*!
 * @brief The member's name, formatted based on language.
 */
extern NSString * const formatted_name;

/*!
 * @brief The member's first name, spelled phonetically.
 */
extern NSString * const phonetic_first_name;

/*!
 * @brief The member's last name, spelled phonetically.
 */
extern NSString * const phonetic_last_name;

/*!
 * @brief The member's name, spelled phonetically and formatted based on language.
 */
extern NSString * const formatted_phonetic_name;

/*!
 * @brief The member's headline.
 */
extern NSString * const headline;

/*!
 * @brief An object representing the user's physical location.
 */
extern NSString * const location;

/*!
 * @brief The industry the member belongs to.
 */
extern NSString * const industry;

/*!
 * @brief The most recent item the member has shared on LinkedIn.  If the member has not shared anything, their 'status' is returned instead.
 */
extern NSString * const current_share;

/*!
 * @brief The number of LinkedIn connections the member has, capped at 500.  See 'num-connections-capped' to determine if the value returned has been capped.
 */
extern NSString * const num_connections;

/*!
 * @brief Returns 'true' if the member's 'num-connections' value has been capped at 500', or 'false' if 'num-connections' represents the user's true value.
 */
extern NSString * const num_connections_capped;

/*!
 * @brief A long-form text area describing the member's professional profile.
 */
extern NSString * const summary;

/*!
 * @brief A short-form text area describing the member's specialties.
 */
extern NSString * const specialties;

/*!
 * @brief An object representing the member's current position.
 */
extern NSString * const positions;

/*!
 * @brief A URL to the member's formatted profile picture, if one has been provided.
 */
extern NSString * const picture_url;

/*!
 * @brief A URL to the member's original unformatted profile picture.  This image is usually larger than the picture-url value above.
 */
extern NSString * const picture_urls_original;

/*!
 * @brief The URL to the member's authenticated profile on LinkedIn.  You must be logged into LinkedIn to view this URL.
 */
extern NSString * const site_standard_profile_request;

/*!
 * @brief A URL representing the resource you would request for programmatic access to the member's profile.
 */
extern NSString * const api_standard_profile_request;

/*!
 * @brief The URL to the member's public profile on LinkedIn.
 */
extern NSString * const public_profile_url;


@end
