//
//  LinkedInHelper.h
//  linkedinDemo
//
//  Created by Ahmet MacPro on 22.3.2015.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinkedInIOSFields.h"

@interface LinkedInHelper : NSObject

/*!
 * @brief Initialize shared Instance
 */
+ (LinkedInHelper *)sharedInstance;

/*!
 * @brief Connects the user to Linkedin and fetchs user informations
 * @param sender is the UIViewcontroller which the web authentication will be fired from
 * @param clientId the clientId of application that you created on linkedin developer portal
 * @param clientSecret of application that you created on linkedin developer portal
 * @param applicationWithRedirectURL the applicationWithRedirectURL of application that you created on linkedin developer portal
 * @param permissions the grantedaccesses to fetch from Linkedin Rest api
 * @param successUserInfo Returns successful user info which are requested via grantedAccess
 * @param failure Returns the failure statement of connection
 * @param state defaults DCEEFWF45453sdffef424
 * @warning redirectUrl can not be nil!
 * @warning clientId can not be nil!
 * @warning clientSecret can not be nil!
 */
- (void)requestMeWithSenderViewController:(id)sender
                                 clientId:(NSString *)clientId
                             clientSecret:(NSString *)clientSecret
                              redirectUrl:(NSString *)redirectUrl
                              permissions:(NSArray *)permissions
                                    state:(NSString *)state
                          successUserInfo:( void (^) (NSDictionary *userInfo) )successUserInfo
                        failUserInfoBlock:( void (^) (NSError *error))failure;

/*!
 * @brief  Fetchs user information if access token is still valid. In this case user does not have to input their username and password informations to login again
 * @param successUserInfo Returns successful user info which are requested via grantedAccess
 * @param failure Returns the failure statement of connection
 */
- (void)autoFetchUserInfoWithSuccess:( void (^) (NSDictionary *userInfo) )successUserInfo
                        failUserInfo:( void (^) (NSError *error))failure;

/*!
 * @brief Refreshing the Access Token (Because accessToken comes from Linkedin has expiration date and for now 60 days)
 * @param success Returns accessToken
 * @param failure Returns the failure statement of connection
 */
- (void)refreshAccessTokenWithClientId:(NSString *)clientId
                          clientSecret:(NSString *)clientSecret
                           redirectUrl:(NSString *)redirectUrl
                           permissions:(NSArray *)permissions
                                 state:(NSString *)state
                               success:(void (^) (NSString *accessToken))success
                              failure:(void (^) (NSError *err) )failure;

/*!
 * @brief Cancel Button's text while getting AuthorizationCode via webview
 */
@property (nonatomic, copy) NSString *cancelButtonText;

/*!
 * @brief returns YES if accessToken is valid (Because accessToken comes from Linkedin has expiration date)
 */
- (BOOL)isValidToken;

/*!
 * @brief Yes if automaticly shows the activity indicator on the webview while getting authorization code
 */
@property (nonatomic, assign) BOOL showActivityIndicator;

/*!
 * @brief This library uses some default subpermissions (Look at LinkedInAppSettings.m Line:84)
 * And If you do not want to use this values so u can make your own with this property by using fields in LinkedInIOSFields.h or by visiting https://developer.linkedin.com/docs/fields
 * If THIS VALUE IS NIL SO LIBRARY FETCH'S ALMOST ALL INFORMATIONS OF MEMBER!! (BY PREPARING THIS VALUE IN LinkedInAppSettings.m Line:84)
 */
@property (nonatomic, copy) NSString *customSubPermissions;


// ================== Frequently Using Fields  =================

/*!
 * @brief User's job title
 */
@property (nonatomic, copy, readonly) NSString *title;

/*!
 * @brief User's company Name
 */
@property (nonatomic, copy, readonly) NSString *companyName;

/*!
 * @brief User's email Address
 */
@property (nonatomic, copy, readonly) NSString *emailAddress;

/*!
 * @brief User's Photo Url
 */
@property (nonatomic, copy, readonly) NSString *photo;

/*!
 * @brief User's Industry name
 */
@property (nonatomic, copy, readonly) NSString *industry;

/*!
 * @brief Access Token comes from Linkedin
 */
- (NSString *)accessToken;

/*!
 * @brief Removes All token and authorization data from keychain
 */
- (void)logout;

@end
