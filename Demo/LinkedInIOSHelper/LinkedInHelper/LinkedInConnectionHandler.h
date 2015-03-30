//
//  LinkedInConnectionHandler.h
//  Demo
//
//  Created by Ahmet Kazım Günay on 27/03/15.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, MethodType) {
    POST,
    GET
};

@interface LinkedInConnectionHandler : NSObject

/*!
 * @brief Initializes the receiver
 *
 * @param url is the `url` for the resource which will be loaded. The url’s scheme must be `http` or `https`.
 * @param type HTTP Request method type which can be "POST"  or "GET" here
 * @param postData the postString this value has meaning if the operation is POST to set HTTPBody
 * @param success returns Success statement with user info that is requested
 * @param cancel fires Cancel statement is URLConnection was cancelled
 * @param failure returns the Error statement of URLConnection
*/
- (instancetype)initWithURL:(NSURL *)url
                       type:(MethodType)type
                   postData:(NSString *)postData
                    success:(void (^)(NSDictionary *response))success
                     cancel:(void (^)(void))cancel
                    failure:(void (^)(NSError *))failure;

/*!
 * @brief Start the asynchronous HTTP request.
 * This can be executed only once, that is if the receiver has already been started, it will have no effect.
 */
- (void) start;

/*!
 * @brief Cancels a running operation at the next cancelation point and returns
 * immediately.
 *
 * If the receiver is already cancelled or finished the message has no effect.
 */
- (void) cancel;

/*!
 * @brief HTTP Request method type which can be "POST"  or "GET" here
 */
@property (nonatomic, assign) MethodType type;


@property (nonatomic, readonly) BOOL isCancelled;
@property (nonatomic, readonly) BOOL isExecuting;
@property (nonatomic, readonly) BOOL isFinished;

@end
