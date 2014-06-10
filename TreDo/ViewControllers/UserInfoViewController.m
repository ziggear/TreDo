//
//  UserInfoViewController.m
//  TreDo
//
//  Created by ziggear on 14-6-1.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import "UserInfoViewController.h"
#import "TrelloAPI.h"
#import "AccountManager.h"

@interface UserInfoViewController () {
    NSDictionary *userInfoDetails;
}
@end

@implementation UserInfoViewController
@synthesize avatarImage, userName, userTrelloAddress, boardsNumber, groupsNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    avatarImage.placeholderImage = [UIImage imageNamed:@""];
    userName.text = @"";
    userTrelloAddress.text = @"";
    boardsNumber.text = @"";
    groupsNumber.text = @"";
    
    [self getUserInfoInNewThread];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfoInNewThread{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        userInfoDetails = [TrelloAPI requestMemberInfoWithToken:[[AccountManager shared] token]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(userInfoDetails) {
                [self reloadPageData];
            }
        });
    });
}

- (void)reloadPageData {
    if([userInfoDetails objectForKey:@"avatarHash"]){
        NSString *imgPath = [TrelloAPI largeSizedAvatarWithHash:[userInfoDetails objectForKey:@"avatarHash"]];
        avatarImage.imageURL = [NSURL URLWithString:imgPath];
    }
    
    if([userInfoDetails objectForKey:@"username"]) {
        userName.text = [userInfoDetails objectForKey:@"username"];
    }
    
    if([userInfoDetails objectForKey:@"url"]){
        userTrelloAddress.text = [userInfoDetails objectForKey:@"url"];
    }
}

@end
