# LinkedinIOSHelper

[![Version](https://img.shields.io/cocoapods/v/LinkedinIOSHelper.svg?style=flat)](http://cocoapods.org/pods/LinkedinIOSHelper)
[![License](https://img.shields.io/cocoapods/l/LinkedinIOSHelper.svg?style=flat)](http://cocoapods.org/pods/LinkedinIOSHelper)
[![Platform](https://img.shields.io/cocoapods/p/LinkedinIOSHelper.svg?style=flat)](http://cocoapods.org/pods/LinkedinIOSHelper)

## Usage

Usage is simple, just import "LinkedInHelper.h" to your controller where you want to use this library:

If you want to login user with LinkedIn Api, so you can easily fetch your informations like below:

```objective-c

#import "LinkedInHelper.h"

@implementation ViewController

- (void)fetchUserInformations {        
	
	LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];

    linkedIn.cancelButtonText = @"Close"; // Or any other language But Default is Close
	
    NSArray *permissions = @[@(BasicProfile),
                            @(EmailAddress),
                            @(Share),
                            @(CompanyAdmin)];
        
    linkedIn.showActivityIndicator = YES;
        
#warning - Your LinkedIn App ClientId - ClientSecret - RedirectUrl
        
    [linkedIn requestMeWithSenderViewController:self
                                       clientId:@""         // Your App Client Id
                                   clientSecret:@""         // Your App Client Secret
                                    redirectUrl:@""         // Your App Redirect Url
                                    permissions:permissions
                                          state:@""               // Your client state
                                successUserInfo:^(NSDictionary *userInfo) {
                                    // Whole User Info
                                    NSLog(@"user Info : %@", userInfo);
                                }
                                failUserInfoBlock:^(NSError *error) {
                                    NSLog(@"error : %@", error.userInfo.description);
                                }
    ];
}

@end
```

You can check if LinkedIn Access Token is still valid  like below:
```objective-c

- (BOOL)isLinkedInAccessTokenValid {
	return [LinkedInHelper sharedInstance].isValidToken;
}

```

You can fetch user Informations automatically without getting authorization code again via web view.
This will automatically fetch use informations thanks to valid access token
```objective-c
-  (void)getUserInfo {
	
	LinkedInHelper *linkedIn = [LinkedInHelper sharedInstance];
    
    // If user has already connected via linkedin in and access token is still valid then
    // No need to fetch authorizationCode and then accessToken again!
    
    #warning - To fetch user info  automatically without getting authorization code, accessToken must be still valid
    
    if (linkedIn.isValidToken) {
                
        // So Fetch member info by elderyly access token
        [linkedIn autoFetchUserInfoWithSuccess:^(NSDictionary *userInfo) {
            // Whole User Info
            NSLog(@"user Info : %@", userInfo);
        } failUserInfo:^(NSError *error) {
            NSLog(@"error : %@", error.userInfo.description);
        }];
    }
}
```
For more information please check the Demo App.
I tried to do my best in code by writing well documentation.

## Requirements

This library requires a deployment target of iOS 6.0 or greater.

## Installation

LinkedinIOSHelper is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LinkedinIOSHelper', '~> 1.0.5'
```

## TODO
* Share on LinkedIn
* Apply with LinkedIn
* Manage Company Pages

## Credits
* Special thanks to [IOSLinkedInAPI](https://github.com/jeyben/IOSLinkedInAPI), this library helped me much about how to connect Linkedin Rest API. 

## Author

Ahmet Kazım Günay, ahmetkgunay@gmail.com

## License

LinkedinIOSHelper is available under the MIT license. See the LICENSE file for more info.