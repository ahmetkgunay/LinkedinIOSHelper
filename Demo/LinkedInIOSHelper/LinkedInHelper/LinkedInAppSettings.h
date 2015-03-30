//
//  LinkedInAppSettings.h
//  linkedinDemo
//
//  Created by Ahmet Kazım Günay on 26/03/15.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkedInAppSettings : NSObject

- (instancetype)initWithClientSecret:(NSString *)clientSecret
                            clientId:(NSString *)clientId
                         redirectUrl:(NSString *)redirectUrl
                         permissions:(NSArray *)permissions
                               state:(NSString *)state;

+ (id)settingsWithClientSecret:(NSString *)clientSecret
                      clientId:(NSString *)clientId
                   redirectUrl:(NSString *)redirectUrl
                   permissions:(NSArray *)permissions
                         state:(NSString *)state;

/*!
 * @brief clientId of application that you created on linkedin developer portal
 * @warning clientId can not be nil!
 */
@property (nonatomic, copy) NSString *clientId;

/*!
 * @brief Client Secret of application that you created on linkedin developer portal
 * @warning clientSecret can not be nil!
 */
@property (nonatomic, copy) NSString *clientSecret;

/*!
 * @brief applicationWithRedirectURL of application that you created on linkedin developer portal
 * @warning applicationWithRedirectURL can not be nil!
 */
@property (nonatomic, copy) NSString *applicationWithRedirectURL;

/**
 * @brief Granted Accesses which is about to ask the user to fetch those informations
 * @warning Can not be nil!
 */
@property (nonatomic, strong) NSMutableArray *permissions;

/**
 * @brief subPermissions, all informations that will fetch By Granted Accesses
 * @warning Can not be nil!
 */
@property (nonatomic, copy) NSString *subPermissions;

/*!
 * @brief Setting Granted Accesses which is about to ask the user to fetch those informations (Contains NSNumbers because of typedef to make this code more understandable)
 */
- (void)setAppPermissions:(NSArray *)permissions;


@property (nonatomic, copy) NSString *grantedAccessString;

@property(nonatomic, copy) NSString *state;


@property (nonatomic, strong) NSArray *grantedAccess;

@end
