//
//  ViewController.m
//  Demo
//
//  Created by Ahmet Kazım Günay on 26/03/15.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#import "ViewController.h"
#import "LinkedInHelper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)btnConnectTapped:(UIButton *)sender {
    
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    
    // If user has already connected via linkedin in and access token is still valid then
    // No need to fetch authorizationCode and then accessToken again!
    
    if (linkedIn.isValidToken) {
        
        linkedIn.customSubPermissions = [NSString stringWithFormat:@"%@,%@", first_name, last_name];
        
        // So Fetch member info by elderyly access token
        [linkedIn autoFetchUserInfoWithSuccess:^(NSDictionary *userInfo) {
            // Whole User Info
            NSLog(@"user Info : %@", userInfo);
        } failUserInfo:^(NSError *error) {
            NSLog(@"error : %@", error.userInfo.description);
        }];
    } else {
        
        linkedIn.cancelButtonText = @"Kapat";
        
        NSArray *permissions = @[@(ContactInfo),
                                 @(FullProfile),
                                 @(BasicProfile),
                                 @(Nus),
                                 @(Network),
                                 @(EmailAddress),
                                 @(Share),
                                 @(CompanyAdmin),
                                 @(Groups),
                                 @(Messages)];
        
        linkedIn.showActivityIndicator = YES;
        
        [linkedIn requestMeWithSenderViewController:self
                                           clientId:<#ClientId#>
                                       clientSecret:<#ClientSecret#>
                                        redirectUrl:<#RedirectUrl#>
                                        permissions:permissions
                                    successUserInfo:^(NSDictionary *userInfo) {
                                        
                                        // Whole User Info
                                        NSLog(@"user Info : %@", userInfo);
                                        
                                        // You can also fetch user's those informations like below
                                        NSLog(@"job title : %@",     [LinkedInHelper sharedInstance].title);
                                        NSLog(@"company Name : %@",  [LinkedInHelper sharedInstance].companyName);
                                        NSLog(@"email address : %@", [LinkedInHelper sharedInstance].emailAddress);
                                        NSLog(@"Photo Url : %@",     [LinkedInHelper sharedInstance].photo);
                                        NSLog(@"Industry : %@",      [LinkedInHelper sharedInstance].industry);
                                    }
                                  failUserInfoBlock:^(NSError *error) {
                                      NSLog(@"error : %@", error.userInfo.description);
                                  }
         ];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
