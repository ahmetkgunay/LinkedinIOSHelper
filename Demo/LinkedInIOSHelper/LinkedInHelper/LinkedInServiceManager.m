//
//  LinkedInServiceManager.m
//  linkedinDemo
//
//  Created by Ahmet Kazım Günay on 26/03/15.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkedInServiceManager.h"
#import "LinkedInAuthorizationViewController.h"
#import "LinkedInConnectionHandler.h"
#import "LinkedinSimpleKeychain.h"

@interface LinkedInServiceManager ()

@property (nonatomic, copy) void (^successBlock)(NSDictionary *dict);

@property (nonatomic, copy) void (^failureBlock)(NSError *err);

@property(nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, copy) NSString *cancelButtonText;

@end

@implementation LinkedInServiceManager

#pragma mark - Initialize -

+ (LinkedInServiceManager *)serviceForPresentingViewController:viewController
                                              cancelButtonText:(NSString*)cancelButtonText
                                                   appSettings:(LinkedInAppSettings*)settings {

    LinkedInServiceManager *service = [[self alloc] init];
    service.cancelButtonText = cancelButtonText;
    service.presentingViewController = viewController;
    service.settings = settings;
    
    return service;
}

#pragma mark - Authorization Code -

- (void)getAuthorizationCode:(void (^)(NSString *))success
                      cancel:(void (^)(void))cancel
                     failure:(void (^)(NSError *))failure {
    
    __weak typeof (self) weakSelf = self;
    
    LinkedInAuthorizationViewController *vc = [[LinkedInAuthorizationViewController alloc] initWithServiceManager:self];
    vc.showActivityIndicator = _showActivityIndicator;
    
    [vc setAuthorizationCodeCancelCallback:^{
        [weakSelf hideAuthenticateView];
        if (cancel) {
            cancel();
        }
    }];
    
    [vc setAuthorizationCodeFailureCallback:^(NSError *err) {
        [weakSelf hideAuthenticateView];
        if (failure) {
            failure(err);
        }
    }];
    
    [vc setAuthorizationCodeSuccessCallback:^(NSString *code) {
        [weakSelf hideAuthenticateView];
        if (success) {
            success(code);
        }
    }];
    vc.cancelButtonText = self.cancelButtonText;
    
    if (self.presentingViewController == nil)
        self.presentingViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        nc.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self.presentingViewController presentViewController:nc animated:YES completion:nil];
}

- (NSString *)authorizationCode {
    return [LinkedinSimpleKeychain loadWithService:LINKEDIN_AUTHORIZATION_CODE];
}

- (void)hideAuthenticateView {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Access Token -

- (NSString *)accessToken {
    return [LinkedinSimpleKeychain loadWithService:LINKEDIN_TOKEN_KEY];
}

- (BOOL)validToken {
    
    return !([[NSDate date] timeIntervalSince1970] >= ([[LinkedinSimpleKeychain loadWithService:LINKEDIN_CREATION_KEY] doubleValue] +
                                                       [[LinkedinSimpleKeychain loadWithService:LINKEDIN_EXPIRATION_KEY] doubleValue]));
}

- (void)getAccessToken:(NSString *)authorizationCode
               success:(void (^)(NSDictionary *))success
               failure:(void (^)(NSError *))failure {
    
    _settings.applicationWithRedirectURL = (NSString *)CFBridgingRelease( CFURLCreateStringByAddingPercentEscapes( NULL,
                                                                                                               (__bridge CFStringRef) _settings.applicationWithRedirectURL,
                                                                                                               NULL,
                                                                                                               CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                               kCFStringEncodingUTF8
                                                                                                               )
                                                                );
    
    [self setSuccessBlock:^(NSDictionary *dict) {
        
        NSString *accessToken = [dict objectForKey:@"access_token"];
        NSTimeInterval expiration = [[dict objectForKey:@"expires_in"] doubleValue];
        
        // store credentials
        [LinkedinSimpleKeychain saveWithService:LINKEDIN_TOKEN_KEY data:accessToken];
        [LinkedinSimpleKeychain saveWithService:LINKEDIN_AUTHORIZATION_CODE data:authorizationCode];
        [LinkedinSimpleKeychain saveWithService:LINKEDIN_EXPIRATION_KEY data:@(expiration)];
        [LinkedinSimpleKeychain saveWithService:LINKEDIN_CREATION_KEY data:@([[NSDate date] timeIntervalSince1970])];
        
        success(dict);
    }];
    
    [self setFailureBlock:^(NSError *err) {
        failure(err);
    }];

    NSString *postDataStr = [NSString stringWithFormat:@"grant_type=authorization_code""&code=%@""&redirect_uri=%@""&client_id=%@""&client_secret=%@", authorizationCode, _settings.applicationWithRedirectURL, _settings.clientId, _settings.clientSecret];
    
    __weak typeof (self) weakSelf = self;
    
    LinkedInConnectionHandler *handler = [[LinkedInConnectionHandler alloc] initWithURL:[NSURL URLWithString:@"https://www.linkedin.com/uas/oauth2/accessToken"]
                                                                                   type:POST
                                                                               postData:postDataStr
                                                                                success:^(NSDictionary *response) {
                                                                                    if (weakSelf.successBlock) {
                                                                                        weakSelf.successBlock(response);
                                                                                    }
                                                                                }
                                                                                 cancel:^{
                                                                                     if (weakSelf.failureBlock) {
                                                                                         NSError *error = [NSError errorWithDomain:@"com.linkedinioshelper"
                                                                                                                            code:-2
                                                                                                                        userInfo:@{NSLocalizedDescriptionKey:@"Url connection canceled"}];
                                                                                         weakSelf.failureBlock(error);
                                                                                     }
                                                                                 }
                                                                                failure:^(NSError *err) {
                                                                                    if (weakSelf.failureBlock) {
                                                                                        weakSelf.failureBlock(err);
                                                                                    }
                                                                                }
                                          ];
    [handler start];
}

#pragma mark - Memory Management -

- (void)dealloc
{
    
}
@end
