//
//  MainViewController.m
//  TreDo
//
//  Created by ziggear on 14-5-26.
//  Copyright (c) 2014年 ziggear. All rights reserved.
//

#import "MainViewController.h"
#import "TrelloOAuthViewController.h"
#import "TrelloAPI.h"
#import "UserInfoViewController.h"
#import "AccountManager.h"

@interface MainViewController () <TrelloOAuthDelegate, UITableViewDataSource, UITableViewDelegate> {
    NSUserDefaults *userDefaults;
    NSArray *boardsInfo;
    NSArray *orgsInfo;
    BOOL isFirstVisit;
}
@end

@implementation MainViewController
@synthesize mainTableView;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        isFirstVisit = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Boards";
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    
    UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithTitle:@"user" style:UIBarButtonItemStylePlain target:self action:@selector(userButtonClicked:)];
    self.navigationItem.rightBarButtonItem = userButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"add" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonClicked:)];
    self.navigationItem.leftBarButtonItem = addButton;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(isFirstVisit) {
        isFirstVisit = NO;
    }
    
    if([[AccountManager shared] available] == NO) {
        [[AccountManager shared] authForToken];
    } else {
        [self getUserBoardsInNewThread];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userButtonClicked:(id)sender{
    UserInfoViewController *vc = [[UserInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addButtonClicked:(id)sender{

}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(!boardsInfo) {
        return 0;
    } else {
        return [boardsInfo count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_reuse"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell_reuse"];
    }
    
    if(boardsInfo && [boardsInfo count] > 0) {
        NSDictionary *board = [boardsInfo objectAtIndex:indexPath.row];
        NSString *boardName = [board objectForKey:@"name"] == nil ? @"" : [[boardsInfo objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.textLabel.text = boardName;
        
        if(board && [board objectForKey:@"idOrganization"]) {
            NSString *boardOrgId = [board objectForKey:@"idOrganization"];
            NSString *orgName;
            for(NSDictionary *org in orgsInfo) {
                if([org objectForKey:@"id"] && [[org objectForKey:@"id"] isEqualToString:boardOrgId]) {
                    orgName = [org objectForKey:@"displayName"];
                    break;
                }
            }
            cell.detailTextLabel.text = orgName;
        }
        
    }
    
    return cell;
}

#pragma mark - Data 

- (void)getUserBoardsInNewThread {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSString *t = [userDefaults objectForKey:@"user_auth_key"];
        boardsInfo = [TrelloAPI requestBoardsWithToken:t];
        orgsInfo = [TrelloAPI requestOrganizationsWithToken:t];
        dispatch_async(dispatch_get_main_queue(), ^{
            [mainTableView reloadData];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
}

@end
