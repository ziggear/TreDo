//
//  TrelloAPI.h
//  TreDo
//
//  Created by ziggear on 14-5-30.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrelloAPI : NSObject
+ (NSString *)largeSizedAvatarWithHash:(NSString *)avatarHash;
+ (NSString *)smallSizedAvatarWithHash:(NSString *)avatarHash;
+ (NSDictionary *)requestMemberInfoWithToken:(NSString *)token;
+ (NSArray *)requestOrganizationsWithToken:(NSString *)token;
+ (NSArray *)requestBoardsWithToken:(NSString *)token;
@end
