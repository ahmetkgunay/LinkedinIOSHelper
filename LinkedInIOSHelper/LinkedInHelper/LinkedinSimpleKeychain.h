//
//  LinkedinSimpleKeychain.h
//  Demo
//
//  Created by Ahmet Kazım Günay on 18/08/15.
//  Copyright (c) 2015 Ahmet Kazım Günay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkedinSimpleKeychain : NSObject

+ (void)saveWithService:(NSString *)service data:(id)data;
+ (id)loadWithService:(NSString *)service;
+ (void)deleteObjectWithService:(NSString *)service;

@end
