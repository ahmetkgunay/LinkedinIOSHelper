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

@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

@end

@implementation ViewController

#pragma mark - View Lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    self.btnLogout.hidden = !linkedIn.isValidToken;
}

#pragma mark - Button Actions -

- (IBAction)logoutTapped:(UIButton *)sender {
    
    LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    [linkedIn logout];
    self.btnLogout.hidden = !linkedIn.isValidToken;
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
            
            NSString * desc = [NSString stringWithFormat:@"first name : %@\n last name : %@", userInfo[@"firstName"], userInfo[@"lastName"] ];
            [self showAlert:desc];
            
            NSLog(@"user Info : %@", userInfo);
        } failUserInfo:^(NSError *error) {
            NSLog(@"error : %@", error.userInfo.description);
        }];
    } else {
    
        linkedIn.cancelButtonText = @"Close"; // Or any other language But Default is Close
        
        NSArray *permissions = @[@(BasicProfile),
                                 @(EmailAddress),
                                 @(Share),
                                 @(CompanyAdmin)];
        
        linkedIn.showActivityIndicator = YES;
        
#warning - Your LinkedIn App ClientId - ClientSecret - RedirectUrl - And state
        
        [linkedIn requestMeWithSenderViewController:self
                                           clientId:@"78kwym3bwepl09"
                                       clientSecret:@"zK5dzNWLZXc4J6Ih"
                                        redirectUrl:@"http://www.hurriyet.com.tr/anasayfa/"
                                        permissions:permissions
                                              state:@""
                                    successUserInfo:^(NSDictionary *userInfo) {
                                        
                                        self.btnLogout.hidden = !linkedIn.isValidToken;
                                        
                                        NSString * desc = [NSString stringWithFormat:@"first name : %@\n last name : %@",
                                                           userInfo[@"firstName"], userInfo[@"lastName"] ];
                                        [self showAlert:desc];

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
                                      self.btnLogout.hidden = !linkedIn.isValidToken; 
                                  }
         ];
    }
}

#pragma mark - Helpers -

- (void)showAlert:(NSString *)desc {
    
    [[[UIAlertView alloc] initWithTitle:@"Simple User info" message:desc delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

#pragma mark - Memory Management -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
