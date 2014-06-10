//
//  TrelloOAuthViewController.m
//  TreDo
//
//  Created by ziggear on 14-5-27.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import "TrelloOAuthViewController.h"
#import "NSString+LHURLEncoding.h"

@interface TrelloOAuthViewController () <UIWebViewDelegate> {
    NSString *app_name;
    NSString *app_key;
    NSString *app_URI;
    kTrelloExpires expires;
    kTrelloScope scope;
    
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation TrelloOAuthViewController
@synthesize oauthWebView, delegate;

- (id)initWithAppName:(NSString *)applicationName andAppKey:(NSString *)keyGeneratedByTrello andRedirectURI:(NSString *)yourRedirectURI
{
    self = [super init];
    if (self) {
        // Custom initialization
        app_name = applicationName;
        app_key = keyGeneratedByTrello;
        app_URI = yourRedirectURI;
        
        scope = kTrelloScopeReadWriteAccount;
        expires = kTrelloExpires30Days;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"账号授权";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelLogin:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    NSURLRequest *request = [self generateOAuthRequest];
    
    oauthWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    oauthWebView.delegate = self;
    [oauthWebView loadRequest:request];
    [self.view addSubview:oauthWebView];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.5);
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelLogin:(id)sender {
    [oauthWebView stopLoading];
    [self failedWithReason:kTrelloAuthFailedReasonUserCanceled];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Preparing Data

- (NSURLRequest *)generateOAuthRequest {
    NSString *urlForAuth = [NSString stringWithFormat:@"https://trello.com/1/authorize?key=%@&name=%@&expiration=%@&response_type=token&redirect_uri=%@&scope=%@", app_key, app_name, [self generateExpiresParam], [app_URI urlEncodeUsingEncoding:NSUTF8StringEncoding] , [self generateScopeParam]];
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlForAuth]];
}

- (NSString *)generateScopeParam {
    switch (scope) {
        case kTrelloScopeRead:
            return @"read";
            break;
        case kTrelloScopeReadWrite:
            return @"read,write";
            break;
        case kTrelloScopeReadWriteAccount:
            return @"read,write,account";
            break;
        case kTrelloScopeAccountOnly:
            return @"account";
            break;
        default:
            return @"read";
            break;
    }
}

- (NSString *)generateExpiresParam {
    switch (expires) {
        case kTrelloExpiresOneHour:
            return @"1hour";
            break;
        case kTrelloExpiresOneDay:
            return @"1day";
            break;
        case kTrelloExpires30Days:
            return @"30days";
            break;
        case kTrelloExpiresNever:
            return @"never";
            break;
        default:
            break;
    }
}

#pragma mark - WebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [activityIndicator stopAnimating];
    //[self failedWithReason:kTrelloAuthFailedReasonWebError];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[[request URL] absoluteString] rangeOfString:app_URI].location != NSNotFound
        && [[[request URL] host] isEqualToString:[[NSURL URLWithString:app_URI] host]]) {
        
        NSLog(@"loading url: %@", [[request URL] absoluteString]);
        
        //seperate params from url
        NSString    *token;
        NSScanner *scanner;
        NSString *tempKey;
        NSString *tempValue;
        
        scanner = [NSScanner scannerWithString:[[request URL] absoluteString]];
        [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"&?#"]];
        [scanner scanUpToString:@"#" intoString:nil];
        
        while ([scanner scanUpToString:@"=" intoString:&tempKey]) {
            [scanner scanUpToString:@"&" intoString:&tempValue];
            if ([tempKey isEqualToString:@"token"]) {
                token = [tempValue substringFromIndex:1];
            }
        }
        
        if(token && [token length] > 0) {
            [self finishWithKey:token];
        } else {
            [self failedWithReason:kTrelloAuthFailedReasonAuthError];
        }
    }

    return YES;
}

#pragma mark - Callbacks

- (void)finishWithKey:(NSString *)key {
    if(delegate && [delegate respondsToSelector:@selector(authFinishedWithKey:)]) {
        [delegate authFinishedWithKey:key];
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)failedWithReason:(kTrelloAuthFailedReason)reason {
    if(delegate && [delegate respondsToSelector:@selector(authFailedWithReason:)]) {
        [delegate authFailedWithReason:reason];
    }
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
