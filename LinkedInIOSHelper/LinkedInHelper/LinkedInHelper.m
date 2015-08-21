//
//  LinkedInHelper.m
//  linkedinDemo
//
//  Created by Ahmet MacPro on 22.3.2015.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#import "LinkedInHelper.h"
#import "LinkedInServiceManager.h"
#import "LinkedInIOSFields.h"
#import "LinkedInConnectionHandler.h"
#import "LinkedinSimpleKeychain.h"

@interface LinkedInHelper ()

@property (nonatomic, strong) LinkedInServiceManager *service;

/**
 * @brief ReadWrite Properties
 */
@property (nonatomic, copy, readwrite) NSString *emailAddress;
@property (nonatomic, copy, readwrite) NSString *industry;
@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSString *photo;
@property (nonatomic, copy, readwrite) NSString *companyName;
@property (nonatomic, copy, readwrite) NSString *accessToken;

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
@property (nonatomic, strong) NSArray *permissions;

/*!
 * @brief Returns successful user info which are requested via grantedAccess
 */
@property (nonatomic, copy) void (^userInfoSuccessBlock)(NSDictionary *userInfo);

/*!
 * @brief Returns the failure statement of connection
 */
@property (nonatomic, copy) void (^dismissFailBlock)(NSError *error);

/*!
 * @brief sender is the UIViewcontroller which the web authentication will be fired from
 * @warning Can not be nil!
 */
@property (nonatomic, strong) id sender;

@end

@implementation LinkedInHelper

NSString * StringOrEmpty(NSString *string) {
    
    return string.length ? string : @"";
}

#pragma mark - Initialize -

+ ( LinkedInHelper * )sharedInstance {
    
    static dispatch_once_t predicate;
    static LinkedInHelper *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[LinkedInHelper alloc] init];
        sharedInstance.service = [LinkedInServiceManager new];
    });
    return sharedInstance;
}

#pragma mark - Token is Valid Or Not -

- (BOOL)isValidToken {
    return [self.service validToken];
}

- (NSString *)accessToken {
    return self.service.accessToken;
}

#pragma mark - Connect -

- (void)requestMeWithSenderViewController:(id)sender
                                 clientId:(NSString *)clientId
                             clientSecret:(NSString *)clientSecret
                              redirectUrl:(NSString *)redirectUrl
                              permissions:(NSArray *)permissions
                                    state:(NSString *)state
                          successUserInfo:( void (^) (NSDictionary *userInfo) )successUserInfo
                        failUserInfoBlock:( void (^) (NSError *error))failure {
    
    self.clientId = clientId;
    self.clientSecret = clientSecret;
    self.applicationWithRedirectURL = redirectUrl;
    self.permissions = permissions;
    
    NSString *lclState = state.length ? state : @"DCEEFWF45453sdffef424";
    self.service = [LinkedInServiceManager serviceForPresentingViewController:_sender
                                                             cancelButtonText:self.cancelButtonText
                                                                  appSettings:[LinkedInAppSettings settingsWithClientSecret:_clientSecret
                                                                                                                   clientId:_clientId
                                                                                                                redirectUrl:_applicationWithRedirectURL
                                                                                                                permissions:_permissions
                                                                                                                      state:lclState]];
    
    self.service.showActivityIndicator = self.showActivityIndicator;
    
    _sender = sender;
    _userInfoSuccessBlock = successUserInfo;
    _dismissFailBlock = failure;
    
    __weak typeof(self) weakSelf = self;
    
    [self.service getAuthorizationCode:^(NSString *code) {
        
        [self.service getAccessToken:code
                             success:^(NSDictionary *accessTokenData) {
                                 [weakSelf requestMeWithToken];
                             }
                             failure:^(NSError *error) {
                                 // Quering accessToken failed
                                 weakSelf.dismissFailBlock(error);
                             }
         ];
    }
                                cancel:^{
                                    // Authorization was cancelled by user
                                    weakSelf.dismissFailBlock([NSError errorWithDomain:@"com.linkedinioshelper"
                                                                              code:-5
                                                                          userInfo:@{NSLocalizedDescriptionKey:@"Authorization was cancelled by user" }]);
                                }
                               failure:^(NSError *error) {
                                   // Authorization failed
                                   weakSelf.dismissFailBlock(error);
                               }
     ];
}

#pragma mark - AutoLogin -

- (void)autoFetchUserInfoWithSuccess:( void (^) (NSDictionary *userInfo) )successUserInfo
                        failUserInfo:( void (^) (NSError *error))failure {
    
    _userInfoSuccessBlock = successUserInfo;
    _dismissFailBlock = failure;
    
    if (self.isValidToken) {
        _accessToken = self.service.accessToken;
        [self requestMeWithToken];
    } else {
        NSLog(@"!!!! Token must be valid to autologin !!!!");
    }
}

- (void)refreshAccessTokenWithClientId:(NSString *)clientId
                          clientSecret:(NSString *)clientSecret
                           redirectUrl:(NSString *)redirectUrl
                           permissions:(NSArray *)permissions
                                 state:(NSString *)state
                               success:(void (^) (NSString *accessToken))success
                              failure:(void (^) (NSError *err) )failure {
    
    
    self.clientId = clientId;
    self.clientSecret = clientSecret;
    self.applicationWithRedirectURL = redirectUrl;
    self.permissions = permissions;
    
    NSString *lclState = state.length ? state : @"DCEEFWF45453sdffef424";
    self.service = [LinkedInServiceManager serviceForPresentingViewController:_sender
                                                             cancelButtonText:self.cancelButtonText
                                                                  appSettings:[LinkedInAppSettings settingsWithClientSecret:_clientSecret
                                                                                                                   clientId:_clientId
                                                                                                                redirectUrl:_applicationWithRedirectURL
                                                                                                                permissions:_permissions
                                                                                                                      state:lclState]];
    
    self.service.showActivityIndicator = self.showActivityIndicator;
    
    __weak typeof(self) weakSelf = self;
    
    NSString *authCode = self.service.authorizationCode.length ? self.service.authorizationCode : [LinkedinSimpleKeychain loadWithService:LINKEDIN_AUTHORIZATION_CODE];

    [self.service getAccessToken:authCode
                         success:^(NSDictionary *accessTokenData) {
                             weakSelf.accessToken = accessTokenData[@"access_token"];
                             success(weakSelf.accessToken);
                         }
                         failure:^(NSError *error) {
                             // Quering accessToken failed
                             failure(error);
                         }
     ];
}

- (void)logout {
    
    [LinkedinSimpleKeychain deleteObjectWithService:LINKEDIN_TOKEN_KEY];
    [LinkedinSimpleKeychain deleteObjectWithService:LINKEDIN_AUTHORIZATION_CODE];
    [LinkedinSimpleKeychain deleteObjectWithService:LINKEDIN_EXPIRATION_KEY];
    [LinkedinSimpleKeychain deleteObjectWithService:LINKEDIN_CREATION_KEY];
}

#pragma mark - Request Me Via Access Token -

- (NSString *)prepareUrlForMe {
    
    if (!_customSubPermissions.length) {
        _customSubPermissions = self.service.settings.subPermissions.length ? self.service.settings.subPermissions : [[NSUserDefaults standardUserDefaults] objectForKey:KSUBPERMISSONS];
    }
    
    NSAssert(_customSubPermissions, @"Sub Permissions can not be null !!");
    
    return [[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(%@)?oauth2_access_token=%@&format=json", _customSubPermissions, [self accessToken]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- ( void )requestMeWithToken {
    
    NSString *clientUrl = [self prepareUrlForMe];
    
    __weak typeof(self) weakSelf = self;
    
    LinkedInConnectionHandler *connection = [[LinkedInConnectionHandler alloc] initWithURL:[NSURL URLWithString:clientUrl]
                                                                                      type:GET
                                                                                  postData:nil
                                                                                   success:^(NSDictionary *response) {
                                                                                       
                                                                                       NSString *title = @"";
                                                                                       NSString *companyName = @"";
                                                                                       NSString *emailAddress = StringOrEmpty(response[ @"emailAddress" ]);
                                                                                       NSString *photo        = StringOrEmpty(response[ @"pictureUrl" ]);
                                                                                       NSString *industry     = StringOrEmpty(response[ @"industry" ]);
                                                                                       
                                                                                       NSDictionary *dictionary = response[ @"positions" ];
                                                                                       if ( dictionary[@"values"] ) {
                                                                                           NSArray *values = dictionary[@"values"];
                                                                                           
                                                                                           if ( values.count ) {
                                                                                               NSDictionary *company = values[0];
                                                                                               title = company[ @"title" ];
                                                                                               if ( company[ @"company" ] ) {
                                                                                                   NSDictionary *companyDic = company[ @"company" ];
                                                                                                   companyName              = companyDic[ @"name" ];
                                                                                               }
                                                                                           }
                                                                                       }
                                                                                       
                                                                                       weakSelf.emailAddress  = emailAddress;
                                                                                       weakSelf.industry      = industry;
                                                                                       weakSelf.title         = StringOrEmpty(title);
                                                                                       weakSelf.photo         = photo;
                                                                                       weakSelf.companyName   = StringOrEmpty(companyName);
                                                                                       
                                                                                       NSAssert(weakSelf.userInfoSuccessBlock, @"SHOULD SET USER INFO SUCCESS BLOCK!");
                                                                                       if (weakSelf.userInfoSuccessBlock) {
                                                                                           weakSelf.userInfoSuccessBlock(response);
                                                                                       }
                                                                                       
                                                                                   }
                                                                                    cancel:^{
                                                                                        NSLog(@"Cancelled");
                                                                                    }
                                                                                   failure:^(NSError *err) {
                                                                                       
                                                                                       NSAssert(weakSelf.dismissFailBlock, @"SHOULD SET USER INFO FAIL BLOCK!");
                                                                                       if (weakSelf.dismissFailBlock) {
                                                                                           weakSelf.dismissFailBlock(err);
                                                                                       }
                                                                                   }
                                             ];
    [connection start];
}

@end
