//
//  TrelloAPI.m
//  TreDo
//
//  Created by ziggear on 14-5-30.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import "TrelloAPI.h"

@implementation TrelloAPI

+ (NSString *)largeSizedAvatarWithHash:(NSString *)avatarHash {
    return [NSString stringWithFormat:@"https://trello-avatars.s3.amazonaws.com/%@/170.png", avatarHash];
}

+ (NSString *)smallSizedAvatarWithHash:(NSString *)avatarHash {
    return [NSString stringWithFormat:@"https://trello-avatars.s3.amazonaws.com/%@/30.png", avatarHash];
}

+ (NSDictionary *)requestMemberInfoWithToken:(NSString *)token {
    NSString *urlString = [NSString stringWithFormat:@"https://trello.com/1/members/me?key=%@&token=%@", TKEY, token];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSError *jsonError;
    if(!error) {
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
        if(!jsonError) {
            return info;
        }
    }
    return nil;
}

+(NSArray *)requestOrganizationsWithToken:(NSString *)token {
    NSString *urlString = [NSString stringWithFormat:@"https://trello.com/1/members/my/organizations?key=%@&token=%@", TKEY, token];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSError *jsonError;
    if(!error) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
        if(!jsonError) {
            return arr;
        }
    }
    return nil;
}

+ (NSArray *)requestBoardsWithToken:(NSString *)token {
    NSString *urlString = [NSString stringWithFormat:@"https://trello.com/1/members/my/boards?key=%@&token=%@", TKEY, token];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSError *jsonError;
    if(!error) {
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
        if(!jsonError) {
            return arr;
        }
    }
    return nil;
}

@end
