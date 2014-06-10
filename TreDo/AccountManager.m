//
//  AccountManager.m
//  TreDo
//
//  Created by ziggear on 14-6-1.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import "AccountManager.h"
#import "TrelloOAuthViewController.h"

@interface AccountManager() <TrelloOAuthDelegate> {
    NSUserDefaults *userDefaults;
}
@end

@implementation AccountManager

AccountManager *instance;
+ (AccountManager *)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AccountManager alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if(self){
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (BOOL) available {
    if([userDefaults objectForKey:@"user_auth_key"] == nil || [[userDefaults objectForKey:@"user_auth_key"] isEqualToString:@"logout"]) {
        return NO;
    } else {
        return YES;
    }
}

- (void) authForToken {
    UIViewController *currentViewController = [AccountManager getCurrentRootViewController];
    TrelloOAuthViewController *vc = [[TrelloOAuthViewController alloc] initWithAppName:@"TreDo"
                                                                             andAppKey:TKEY
                                                                        andRedirectURI:@"tredo://oauth2"];
    vc.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [currentViewController presentViewController:navController animated:YES completion:^() {}];
}

- (NSString *)token {
    return [userDefaults objectForKey:@"user_auth_key"];
}

- (void) logout {
    if([self available]) {
        return;
    } else {
        [userDefaults setObject:@"logout" forKey:@"user_auth_key"];
    }
}

#pragma mark - Trello OAuth

- (void)authFailedWithReason:(kTrelloAuthFailedReason)reason {
    [self logout];
}

- (void)authFinishedWithKey:(NSString *)key {
    [userDefaults setObject:key forKey:@"user_auth_key"];
}

#pragma mark - Private Methods 

+ (UIViewController *)getCurrentRootViewController {
    UIViewController *result;
    
    // Try to find the root view controller programmically
    
    // Find the top window (that is not an alert view or other window)
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    
    return result;    
}

@end
