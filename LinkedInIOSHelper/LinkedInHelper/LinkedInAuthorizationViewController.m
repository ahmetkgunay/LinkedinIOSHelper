//
//  LinkedInAuthorizationViewController.m
//  linkedinDemo
//
//  Created by Ahmet Kazım Günay on 26/03/15.
//  Copyright (c) 2015 ahmetkgunay. All rights reserved.
//

#import <LinkedinIOSHelper/LinkedInAuthorizationViewController.h>
#import <LinkedinIOSHelper/LinkedInIOSFields.h>
#import <LinkedinIOSHelper/LinkedInServiceManager.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define kActivityIndicatiorTag       999999

NSString * const linkedinIosHelperDomain = @"com.linkedinioshelper";

@interface LinkedInAuthorizationViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign, getter=isHandling) BOOL handling;
@property (nonatomic, strong) LinkedInServiceManager *serviceManager;

@end

@implementation LinkedInAuthorizationViewController

#pragma mark - Initialize -

- (instancetype)initWithServiceManager:(LinkedInServiceManager *)manager {
    self = [super init];
    if (self) {
        self.serviceManager = manager;
    }
    
    return self;
}

#pragma mark - View Lifecycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.cancelButtonText = self.cancelButtonText.length ? self.cancelButtonText : @"Close";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:self.cancelButtonText
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(btnCancelTapped:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.webView = [[WKWebView alloc] init];
    //self.webView.delegate = self;
    self.webView.navigationDelegate = self;
    //self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    if (self.showActivityIndicator) {
        [self showIndicatorWithStyle:UIActivityIndicatorViewStyleGray];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *linkedIn = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=%@&state=%@&redirect_uri=%@", self.serviceManager.settings.clientId, self.serviceManager.settings.grantedAccessString, self.serviceManager.settings.state, self.serviceManager.settings.applicationWithRedirectURL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkedIn]]];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

#pragma mark - Button Actions -

- (void)btnCancelTapped:(UIBarButtonItem*)sender {
    
    if (self.authorizationCodeCancelCallback) {
        self.authorizationCodeCancelCallback();
    }
}

#pragma mark - WebView Delegate -

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  NSString *url = navigationAction.request.URL.absoluteString;
  
  //prevent loading URL if it is the redirectURL
  self.handling = [url hasPrefix:self.serviceManager.settings.applicationWithRedirectURL];
  
  if (self.isHandling) {
      if ([url rangeOfString:@"error"].location != NSNotFound) {
          BOOL accessDenied = [url rangeOfString:@"the+user+denied+your+request"].location != NSNotFound;
          if (accessDenied) {
              if (self.authorizationCodeCancelCallback) {
                  self.authorizationCodeCancelCallback();
              }
          } else {
              NSError *error = [[NSError alloc] initWithDomain:linkedinIosHelperDomain
                                                          code:1
                                                      userInfo:[[NSMutableDictionary alloc] init]];
              if (self.authorizationCodeFailureCallback) {
                  self.authorizationCodeFailureCallback(error);
              }
          }
      } else {
          NSString *receivedState = [self extractGetParameter:@"state" fromURLString: url];
          
          //assert that the state is as we expected it to be
          if ([self.serviceManager.settings.state isEqualToString:receivedState]) {
              
              //extract the code from the url
              NSString *authorizationCode = [self extractGetParameter:@"code" fromURLString: url];
              if (self.authorizationCodeSuccessCallback) {
                  self.authorizationCodeSuccessCallback(authorizationCode);
              }
          } else {
              NSError *error = [[NSError alloc] initWithDomain:linkedinIosHelperDomain
                                                          code:2
                                                      userInfo:[[NSMutableDictionary alloc] init]];
              if (self.authorizationCodeFailureCallback) {
                  self.authorizationCodeFailureCallback(error);
              }
          }
      }
  }
  if (!self.isHandling) {
    decisionHandler(WKNavigationActionPolicyAllow);
  } else {
    decisionHandler(WKNavigationActionPolicyCancel);
  }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
  if (!self.isHandling && self.authorizationCodeFailureCallback) {
      self.authorizationCodeFailureCallback(error);
  }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
  [self stopIndicatorIfExist];
  
  /*fix for the LinkedIn Auth window - it doesn't scale right when placed into
   a webview inside of a form sheet modal. If we transform the HTML of the page
   a bit, and fix the viewport to 540px (the width of the form sheet), the problem
   is solved.
   */
  if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
      NSString* js =
      @"var meta = document.createElement('meta'); "
      @"meta.setAttribute( 'name', 'viewport' ); "
      @"meta.setAttribute( 'content', 'width = 540px, initial-scale = 1.0, user-scalable = yes' ); "
      @"document.getElementsByTagName('head')[0].appendChild(meta)";
      
      [webView evaluateJavaScript:js completionHandler:nil];
  }
}

#pragma mark - Helpers -

- (NSString *)extractGetParameter: (NSString *) parameterName fromURLString:(NSString *)urlString {
    
    NSMutableDictionary *mdQueryStrings = [[NSMutableDictionary alloc] init];
    urlString = [[urlString componentsSeparatedByString:@"?"] objectAtIndex:1];
    urlString = [[urlString componentsSeparatedByString:@"#"] objectAtIndex:0];
    for (NSString *qs in [urlString componentsSeparatedByString:@"&"]) {
        [mdQueryStrings setValue:[[[[qs componentsSeparatedByString:@"="] objectAtIndex:1]
                                   stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          forKey:[[qs componentsSeparatedByString:@"="] objectAtIndex:0]];
    }
    return [mdQueryStrings objectForKey:parameterName];
}


#pragma mark - Activity Indicator -

- (void)showIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    CGRect selfFrame = self.view.frame;
    indicator.center = CGPointMake(selfFrame.size.width/2, selfFrame.size.height/2);
    indicator.tag = kActivityIndicatiorTag;
    [indicator startAnimating];
    [self.webView addSubview:indicator];
}

- (void)stopIndicatorIfExist {
    
    if ([self.webView viewWithTag:kActivityIndicatiorTag] &&
        [[self.webView viewWithTag:kActivityIndicatiorTag] isKindOfClass:[UIActivityIndicatorView class]]) {
        
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView*)[self.webView viewWithTag:kActivityIndicatiorTag];
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        indicator = nil;
    }
}

#pragma mark - Memory Management -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    self.webView.navigationDelegate = nil;
}

@end
