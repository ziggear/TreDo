//
//  AccountManager.h
//  TreDo
//
//  Created by ziggear on 14-6-1.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject
+ (AccountManager *)shared;
- (BOOL) available;
- (void) authForToken;
- (void) logout;
- (NSString *)token;
@end
