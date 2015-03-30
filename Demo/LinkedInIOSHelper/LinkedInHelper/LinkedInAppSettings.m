//
//  LinkedInAppSettings.m
//  linkedinDemo
//
//  Created by Ahmet Kazım Günay on 26/03/15.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#import "LinkedInAppSettings.h"
#import "LinkedInIOSFields.h"

@interface LinkedInAppSettings ()

@end

@implementation LinkedInAppSettings

#pragma mark - Initialize -

+ (instancetype)settingsWithClientSecret:(NSString *)clientSecret
                                clientId:(NSString *)clientId
                             redirectUrl:(NSString *)redirectUrl
                             permissions:(NSArray *)permissions
                                   state:(NSString *)state {
    
    return [[self alloc] initWithClientSecret:clientSecret
                                     clientId:clientId
                                  redirectUrl:redirectUrl
                                  permissions:permissions
                                        state:state];
}

- (instancetype)initWithClientSecret:(NSString *)clientSecret
                            clientId:(NSString *)clientId
                         redirectUrl:(NSString *)redirectUrl
                         permissions:(NSArray *)permissions
                               state:(NSString *)state {
    
    self = [super init];
    if (self) {
        self.clientSecret = clientSecret;
        self.clientId = clientId;
        self.applicationWithRedirectURL = redirectUrl;
        self.state = state;
                
        NSAssert(_clientSecret.length, @"client secret can not be nil!");
        NSAssert(_clientId.length, @"client id can not be nil!");
        NSAssert(_applicationWithRedirectURL.length, @"_applicationWithRedirectURL can not be nil!");
        
        [self setAppPermissions:permissions];
    }
    return self;
}

#pragma mark - App Permission Setter -

- (void)setAppPermissions:(NSArray *)permissions {
    
    if (self.permissions) {
        self.permissions = nil;
        self.grantedAccess = nil;
    }
    self.grantedAccess = permissions;
    self.permissions = [NSMutableArray new];

    if ([permissions containsObject:@(ContactInfo)])    [self.permissions addObject:@"r_contactinfo"];
    if ([permissions containsObject:@(FullProfile)])    [self.permissions addObject:@"r_fullprofile"];
    if (![permissions containsObject:@(FullProfile)] &&
        [permissions containsObject:@(BasicProfile)])   [self.permissions addObject:@"r_basicprofile"];
    if ([permissions containsObject:@(Nus)])            [self.permissions addObject:@"rw_nus"];
    if ([permissions containsObject:@(Network)])        [self.permissions addObject:@"r_network"];
    if ([permissions containsObject:@(EmailAddress)])   [self.permissions addObject:@"r_emailaddress"];
    if ([permissions containsObject:@(Share)])          [self.permissions addObject:@"w_share"];
    if ([permissions containsObject:@(CompanyAdmin)])   [self.permissions addObject:@"rw_company_admin"];
    if ([permissions containsObject:@(Groups)])         [self.permissions addObject:@"rw_groups"];
    if ([permissions containsObject:@(Messages)])       [self.permissions addObject:@"w_messages"];
    
    NSAssert((self.permissions.count != 0) || (self.permissions != nil), @"permissions should have been set");
    
    self.grantedAccessString = [self.permissions componentsJoinedByString:@"%20"];
    [self prepareSubPermissions];
}

- (void)prepareSubPermissions {
    
    self.subPermissions = @"";
    
    // ====================== BasicProfileFields =====================
    
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",Id]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",first_name]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",last_name]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",maiden_name]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",formatted_name]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",phonetic_first_name]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",phonetic_last_name]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",formatted_phonetic_name]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",headline]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",location]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",industry]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",current_share]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",num_connections]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",num_connections_capped]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",summary]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",specialties]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",positions]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",picture_url]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",picture_urls_original]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",site_standard_profile_request]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",api_standard_profile_request]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",public_profile_url]];

    // ====================== ContactInformationFields ============

    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",phone_numbers]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",bound_account_types]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",im_accounts]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",main_address]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",twitter_accounts]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",primary_twitter_account]];

    // ====================== EmailFields =========================
    
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",email_address]];

    
    // ====================== FullProfileFields ===================
    
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",last_modified_timestamp]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",proposal_comments]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",associations]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",interests]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",publications]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",patents]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",languages]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",skills]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",certifications]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",educations]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",courses]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",volunteer]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",three_current_positions]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",three_past_positions]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",num_recommenders]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",recommendations_received]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",following]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",job_bookmarks]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",suggestions]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",date_of_birth]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",member_url_resources]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",related_profile_views]];
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",honors_awards]];
    
    // ====================== NetworkFields =======================
    
    self.subPermissions = [self.subPermissions stringByAppendingString:[NSString stringWithFormat:@"%@,",connections]];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.subPermissions forKey:KSUBPERMISSONS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    NSLog(@"%@", self.subPermissions);
}

@end
