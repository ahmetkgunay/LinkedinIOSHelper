//
//  LinkedinAuthorizationNavBar.m
//  Demo
//
//  Created by AHMET KAZIM GUNAY on 09/12/2017.
//  Copyright © 2017 Ahmet Kazım Günay. All rights reserved.
//

#import "LinkedinAuthorizationNavBar.h"

@implementation LinkedinAuthorizationNavBar
    
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
    
#pragma mark - Appearence Setters
    
- (void)setAuthBarTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)authBarTitleTextAttributes {
    
    _authBarTitleTextAttributes = authBarTitleTextAttributes;
    [self setTitleTextAttributes:authBarTitleTextAttributes];
}
    
- (void)setAuthCancelButtonTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)authCancelButtonTitleTextAttributes {
    
    _authCancelButtonTitleTextAttributes = authCancelButtonTitleTextAttributes;
    [self.topItem.leftBarButtonItem setTitleTextAttributes:authCancelButtonTitleTextAttributes forState:UIControlStateNormal];
}

- (void)setAuthBarTintColor:(UIColor *)authBarTintColor {
    
    _authBarTintColor = authBarTintColor;
    [self setBarTintColor:authBarTintColor];
}
    
- (void)setAuthBarIsTranslucent:(BOOL)authBarIsTranslucent {
    
    _authBarIsTranslucent = authBarIsTranslucent;
    [self setTranslucent:authBarIsTranslucent];
}
    
- (void)setAuthTintColor:(UIColor *)authTintColor {
    
    _authTintColor = authTintColor;
    [self setTintColor:authTintColor];
}
    
- (void)setAuthTitle:(NSString *)authTitle {
    
    _authTitle = authTitle;
    [self.topItem setTitle:authTitle];
}

@end
