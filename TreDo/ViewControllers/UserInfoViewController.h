//
//  UserInfoViewController.h
//  TreDo
//
//  Created by ziggear on 14-6-1.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface UserInfoViewController : UIViewController
@property (nonatomic, strong) IBOutlet EGOImageView *avatarImage;
@property (nonatomic, strong) IBOutlet UILabel *userName;
@property (nonatomic, strong) IBOutlet UILabel *userTrelloAddress;
@property (nonatomic, strong) IBOutlet UILabel *boardsNumber;
@property (nonatomic, strong) IBOutlet UILabel *groupsNumber;
@end
