//
//  LinkedinAuthorizationNavBar.h
//  Demo
//
//  Created by AHMET KAZIM GUNAY on 09/12/2017.
//  Copyright © 2017 Ahmet Kazım Günay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LinkedinAuthorizationNavBar : UINavigationBar
    
    
/** Customize font, color attributes using Apperance */

@property(nullable,nonatomic,copy) NSDictionary<NSAttributedStringKey, id> *authBarTitleTextAttributes NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
    
@property(nullable,nonatomic,copy) NSDictionary<NSAttributedStringKey, id> *authCancelButtonTitleTextAttributes NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;    
    
@property (nonatomic, assign) BOOL authBarIsTranslucent UI_APPEARANCE_SELECTOR; // defaults YES

@property (nonatomic, strong) UIColor * _Nullable authTintColor UI_APPEARANCE_SELECTOR; // defaults Blue
    
@property (nonatomic, strong) UIColor * _Nullable authBarTintColor UI_APPEARANCE_SELECTOR; // defaults White
    
@property (nonatomic, strong) NSString * _Nullable authTitle UI_APPEARANCE_SELECTOR; // defaults Linkedin


@end
