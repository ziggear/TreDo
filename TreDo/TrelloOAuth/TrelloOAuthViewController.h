//
//  TrelloOAuthViewController.h
//  TreDo
//
//  Created by ziggear on 14-5-27.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kTrelloExpiresOneHour,
    kTrelloExpiresOneDay,
    kTrelloExpires30Days,
    kTrelloExpiresNever
}kTrelloExpires;

typedef enum {
    kTrelloScopeRead,
    kTrelloScopeReadWrite,
    kTrelloScopeReadWriteAccount,
    kTrelloScopeAccountOnly
}kTrelloScope;

typedef enum {
    kTrelloAuthFailedReasonWebError,
    kTrelloAuthFailedReasonAuthError,
    kTrelloAuthFailedReasonUserCanceled
}kTrelloAuthFailedReason;

@protocol TrelloOAuthDelegate <NSObject>
- (void)authFinishedWithKey:(NSString *)key;
- (void)authFailedWithReason:(kTrelloAuthFailedReason)reason;
@end

@interface TrelloOAuthViewController : UIViewController
@property (nonatomic, strong) UIWebView *oauthWebView;
@property (nonatomic, weak) id<TrelloOAuthDelegate> delegate;
- (id)initWithAppName:(NSString *)applicationName andAppKey:(NSString *)keyGeneratedByTrello andRedirectURI:(NSString *)yourRedirectURI;
@end
