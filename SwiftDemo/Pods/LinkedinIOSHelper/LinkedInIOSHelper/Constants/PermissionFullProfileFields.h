//
//  PermissionFullProfileFields.h
//  Demo
//
//  Created by Ahmet Kazım Günay on 02/04/15.
//  Copyright (c) 2015 Ahmet Kazım Günay. All rights reserved.
//

#import "PermissionBasicProfileFields.h"

//
// All of the descriptions copied from  Linkedin Developer Site
// You can have more comprehensive descriptions from https://developer.linkedin.com/docs/fields/full-profile
//

@interface PermissionFullProfileFields : PermissionBasicProfileFields

/*!
 * @brief The timestamp, in milliseconds, when the member's profile was last edited.
 */
extern NSString * const last_modified_timestamp;

/*!
 * @brief A short-form text area describing how the member approaches proposals.
 */
extern NSString * const proposal_comments;

/*!
 * @brief A short-form text area listing the various associations the member is a part of.
 */
extern NSString * const associations;

/*!
 * @brief A short-form text area describing the member's interests.
 */
extern NSString * const interests;

/*!
 * @brief An object representing the various publications associated with the member.
 */
extern NSString * const publications;

/*!
 * @brief An object representing the various patents associated with the member.
 */
extern NSString * const patents;

/*!
 * @brief An object representing the languages that the member knows.
 */
extern NSString * const languages;

/*!
 * @brief An object representing the skills that the member holds.
 */
extern NSString * const skills;

/*!
 * @brief An object representing the certifications that the member holds.
 */
extern NSString * const certifications;

/*!
 * @brief An object representing the user's educational background.
 */
extern NSString * const educations;

/*!
 * @brief An object representing courses the member has taken.
 */
extern NSString * const courses;

/*!
 * @brief An object representing the member's volunteer experience.
 */
extern NSString * const volunteer;

/*!
 * @brief A collection of current positions that the member holds, capped at three.
 */
extern NSString * const three_current_positions;

/*!
 * @brief A collection of the most recent past positions that the member held, capped at three.
 */
extern NSString * const three_past_positions;

/*!
 * @brief The number of recommendations that the member has.
 */
extern NSString * const num_recommenders;

/*!
 * @brief An object representing the recommendations that the member has received.
 */
extern NSString * const recommendations_received;

/*!
 * @brief An collection of people, company and industries that the member is following.
 */
extern NSString * const following;

/*!
 * @brief A collection of jobs that the member is following.
 */
extern NSString * const job_bookmarks;

/*!
 * @brief A collection of people, companies and industries suggested for the member to follow.
 */
extern NSString * const suggestions;

/*!
 * @brief The member's date of birth.  This field may not return the year as part of the date, if the member has not provided it.
 */
extern NSString * const date_of_birth;

/*!
 * @brief An object representing the URLs the member has shared on their LinkedIn profile.
 */
extern NSString * const member_url_resources;

/*!
 * @brief An object listing related member profiles that were viewed before or after the member's profile.
 */
extern NSString * const related_profile_views;

/*!
 * @brief An object representing the various honors and awards the member has received.
 */
extern NSString * const honors_awards;

/*!
 * @brief Members locations which is set to Linked profile
 */
extern NSString * const location_name;

@end
