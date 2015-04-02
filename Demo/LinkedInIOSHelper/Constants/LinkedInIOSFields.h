//
//  LinkedInIOSFields.h
//  linkedinDemo
//
//  Created by Ahmet Kazım Günay on 25/03/15.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#ifndef linkedinDemo_LinkedInIOSFields_h
#define linkedinDemo_LinkedInIOSFields_h

#import "PermissionBasicProfileFields.h"
#import "PermissionFullProfileFields.h"
#import "PermissionEmailFields.h"
#import "PermissionContactInfoFields.h"
#import "PermissionNetworkFields.h"

/*!
 * @brief To access any of the following full profile fields, your app must request the FullProfile member permission.  Note that BasicProfile provides access to a sub-set of the fields made available by FullProfile, so if you are requesting FullProfile, there is no need to also request the BasicProfile permission.
 */
typedef NS_ENUM (NSInteger, Permissions) {
    ContactInfo = 1,
    FullProfile,
    BasicProfile,
    Nus,
    Network,
    EmailAddress,
    Share,
    CompanyAdmin,
    Groups,
    Messages
};

#define KSUBPERMISSONS                  @"kSubPermissionsKey"
#define LINKEDIN_TOKEN_KEY              @"linkedin_token"
#define LINKEDIN_AUTHORIZATION_CODE     @"linkedin_authorization_code"
#define LINKEDIN_EXPIRATION_KEY         @"linkedin_expiration"
#define LINKEDIN_CREATION_KEY           @"linkedin_token_created_at"

#endif
