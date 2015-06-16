//
//  LinkedInAuthorizationViewController.h
//  linkedinDemo
//
//  Created by Ahmet Kazım Günay on 26/03/15.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

@class LinkedInServiceManager;

#import <UIKit/UIKit.h>

@interface LinkedInAuthorizationViewController : UIViewController

/*!
 * @brief Initialize AuthorizationVC with service Manager
 * @param manager the service manager that can handle url connections
 */
- (instancetype)initWithServiceManager:(LinkedInServiceManager *)manager;

/*!
 * @brief Cancel Button's text while getting AuthorizationCode via webview (default is Close)
 */
@property (nonatomic, copy) NSString *cancelButtonText;

/*!
 * @brief Returns successful user info which are requested via grantedAccess
 */
@property (nonatomic, copy) void (^authorizationCodeSuccessCallback)(NSString *code);

/*!
 * @brief Returns the cancel statement of connection because of user canceled the auth
 */
@property (nonatomic, copy) void (^authorizationCodeCancelCallback)(void);

/*!
 * @brief Returns the failure statement of connection
 */
@property (nonatomic, copy) void (^authorizationCodeFailureCallback)(NSError *err);

/*!
 * @brief Yes if automaticly shows the activity indicator on the webview while getting authorization code
 */
@property (nonatomic, assign) BOOL showActivityIndicator;

@end
