//
//  LinkedInConnectionHandler.m
//  Demo
//
//  Created by Ahmet Kazım Günay on 27/03/15.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#import "LinkedInConnectionHandler.h"
#import <UIKit/UIKit.h>

@interface LinkedInConnectionHandler () <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

/*!
 * @brief Returns successful user info which are requested via grantedAccess
 */
@property (nonatomic, copy) void (^successCallback)(NSDictionary *response);

/*!
 * @brief Returns the cancel statement of connection because of user canceled the auth
 */
@property (nonatomic, copy) void (^cancelCallback)(void);

/*!
 * @brief Returns the failure statement of connection
 */
@property (nonatomic, copy) void (^failureCallback)(NSError *err);

@property (nonatomic, readwrite) BOOL isCancelled;
@property (nonatomic, readwrite) BOOL isExecuting;
@property (nonatomic, readwrite) BOOL isFinished;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSHTTPURLResponse *lastResponse;
@property (nonatomic, copy) NSString *postString;

@end

@implementation LinkedInConnectionHandler

@synthesize isCancelled = _isCancelled;
@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;

#pragma mark - Initialize -

- (instancetype)initWithURL:(NSURL *)url
                       type:(MethodType)type
                   postData:(NSString *)postData
                    success:(void (^)(NSDictionary *response))success
                     cancel:(void (^)(void))cancel
                    failure:(void (^)(NSError *))failure {
    
    NSParameterAssert(url);
    self = [super init];
    if (self) {
        _type = type;
        _url = url;
        _successCallback = success;
        _failureCallback = failure;
        _cancelCallback = cancel;
        _postString = postData;
    }
    return self;
}

#pragma mark - Start / Cancel -

- (void) start {
    
    if (self.connection) {
        [self.connection cancel];
    }
    // ensure the start method is executed on the main thread:
    if ([NSThread currentThread] != [NSThread mainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    // bail out if the receiver has already been started or cancelled:
    if (_isCancelled || _isExecuting || _isFinished) {
        return;
    }
    self.isExecuting = YES;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_url];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    if (self.connection == nil) {
        NSError *err = [NSError errorWithDomain:@"com.linkedinioshelper"
                                         code:-2
                                     userInfo:@{NSLocalizedDescriptionKey:@"Couldn't create NSURLConnection"}];
        if (self.failureCallback) {
            self.failureCallback(err);
        }
        [self killEmAll];
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    switch (self.type) {
        case GET: {
            [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            [self.connection start];
        }
            break;
        case POST: {
            
            NSData *postData = [NSData dataWithBytes:[_postString UTF8String] length:[_postString length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:_url];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Current-Type"];
            [request setHTTPBody:postData];
            
            self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
            [self.connection start];
        }
        default:
            break;
    }
}

- (void) cancel {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_isCancelled || _isFinished) {
            return;
        }
        [self.connection cancel];
        
        if (self.cancelCallback) {
            self.cancelCallback();
        }
        
        [self killEmAll];
    });
}

#pragma mark - NSURLConnection Delegate -

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    if (self.failureCallback) {
        self.failureCallback(error);
    }
    
    [self killEmAll];
}

#pragma mark - NSURLConnectionData Delegate -

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    assert([response isKindOfClass:[NSHTTPURLResponse class]]);
    
    switch (self.type) {
        case GET:  self.responseData = [[NSMutableData alloc] initWithCapacity:1024];
            break;
        case POST: self.responseData = [[NSMutableData alloc] init];
        default:
            break;
    }
    self.lastResponse = (NSHTTPURLResponse*)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    
    if (self.lastResponse.statusCode != 200) {
        NSString *desc = [[NSString alloc] initWithFormat:@"connection failed with response %ld (%@)",
                          (long)self.lastResponse.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:self.lastResponse.statusCode]];
        
        NSError *err = [[NSError alloc] initWithDomain:@"com.linkedinioshelper"
                                                code:-4
                                            userInfo:@{
                                                       NSLocalizedDescriptionKey: desc,
                                                       NSLocalizedFailureReasonErrorKey:[self.responseData description]
                                                       }];
        if (self.failureCallback) {
            self.failureCallback(err);
            err = nil;
            desc = nil;
        }
        
    } else {
        
        NSError *err = nil;
        NSDictionary  *returnObject = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&err];
        
        if (err) {
            NSAssert(self.failureCallback, @"SHOULD SET USER INFO FAIL BLOCK!");
            if (self.failureCallback) {
                self.failureCallback(err);
                err = nil;
            }
        } else {
            if (self.successCallback) {
                self.successCallback(returnObject);
            }
        }
    }
    [self killEmAll];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
//    NSLog(@"Authenticated");
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
//    NSLog(@"Challenged");
    if ([challenge.protectionSpace.authenticationMethod
         isEqualToString:NSURLAuthenticationMethodServerTrust])
    {
        //trust domain
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    }
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark - Memory Management -

- (void) dealloc {
    
}

- (void)killEmAll {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSAssert([NSThread currentThread] == [NSThread mainThread], @"not executing on main thread");
    
    if (_isFinished)
        return;
    
    self.successCallback = nil;
    self.failureCallback = nil;
    self.cancelCallback = nil;
    self.connection = nil;
    self.isExecuting = NO;
    self.isFinished = YES;
}

@end
