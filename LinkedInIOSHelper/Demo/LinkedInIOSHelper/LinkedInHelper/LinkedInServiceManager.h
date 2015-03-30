//
//  LinkedInServiceManager.h
//  linkedinDemo
//
//  Created by Ahmet Kazım Günay on 26/03/15.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#import "LinkedInAppSettings.h"
#import <Foundation/Foundation.h>
#import "LinkedInIOSFields.h"

@interface LinkedInServiceManager : NSObject

/*!
 * @brief Class method that creates instance of this class 
 * @param viewController the UIViewcontroller which the web authentication will be fired from
 * @param cancelButtonText Cancel Button's text while getting AuthorizationCode via webview
 * @param settings the linkedin library settings which has client id, clients secret and etc. informations
 */
+ (LinkedInServiceManager *)serviceForPresentingViewController:viewController
                                              cancelButtonText:(NSString *)cancelButtonText
                                                   appSettings:(LinkedInAppSettings *)settings;
/*!
 * @brief returns YES if accessToken is valid (Because accessToken comes from Linkedin has expiration date)
 */
- (BOOL)validToken;

/*!
 * @brief Linkedin access token for rest api
 */
- (NSString *)accessToken;

/*!
 * @brief authorizationCode the authorizationCode to authorize and then get access token
 */
- (NSString *)authorizationCode;

/*!
 * @brief Fetching access token for given authorization Code 
 * @param authorizationCode the authorizationCode to be able to authorize
 * @param success returns dictionary which has access token and expired date informations init
 * @param failure returns error
 */
- (void)getAccessToken:(NSString *)authorizationCode
               success:(void (^)(NSDictionary *))success
               failure:(void (^)(NSError *))failure;

/*!
 * @brief Presenting UIWebview to fetch authorizationCode by users input (username and password)
 * @param success returns authorizationCode
 * @param cancel returns cancel statement if user clicked the cancel button of UIWebview
 * @param failure returns error
 */
- (void)getAuthorizationCode:(void (^)(NSString *))success
                      cancel:(void (^)(void))cancel
                     failure:(void (^)(NSError *))failure;

/*!
 * @brief settings the linkedin library settings which has client id, clients secret and etc. informations
 */
@property (nonatomic, strong) LinkedInAppSettings *settings;

/*!
 * @brief Yes if automaticly shows the activity indicator on the webview while getting authorization code
 */
@property (nonatomic, assign) BOOL showActivityIndicator;

@end
