//
//  SettingViewController.m
//  
//
//  Created by Chen XueFeng on 16/5/27.
//
//

#import "SettingViewController.h"

#import "IAPViewController.h"
#import "UIViewController+Share.h"
#import "UIViewController+SendEmailInApp.h"

#import "UserProfileCell.h"

#import <AVOSCloud/AVOSCloud.h>
#import <LeanCloudSocial/AVOSCloudSNS.h>
#import "CDLoginVC.h"
#import "CDBaseNavC.h"
#import "CDUserManager.h"
#import "MCPhotographyHelper.h"
#import "MyDreamCache.h"
#import "MyLikeCache.h"
#import "ILUserProfileDefaultView.h"

#import <JMActionSheet.h>
#import "UIView+TYAlertView.h"
#import "ILMottoViewController.h"

#import "ILFollowMessageViewController.h"
#import "ILPrivateMessageListViewController.h"
#import "ILCommentMessageViewController.h"
#import "ILLikeMessageViewController.h"
#import "ILFriendListViewController.h"
#import "ILDreamDBManager.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource, ILUserProfileDefaultViewDelegate>

@property(copy, nonatomic) NSArray *sectionTitleArray;
@property(copy, nonatomic) NSArray *sectionContentArray;
@property (nonatomic, strong) MCPhotographyHelper *photographyHelper;
@property(strong, nonatomic) NSArray *badgeArray;

@end

@implementation SettingViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    _settingTableView.dataSource = self;
    _settingTableView.delegate = self;
    _settingTableView.tableFooterView = [[UIView alloc] init];

    _sectionContentArray = @[@[@""],
                             @[@"评论", @"喜欢", @"信件", @"关注"],
                             @[@"关注", @"粉丝"/*, @"黑名单"*/],
                             @[@"分享", @"评价", @"反馈", @"隐私政策"]];
    
    _sectionTitleArray = @[@"", @"消息", @"好友管理", @"其它"];
    
    _badgeArray = @[@0,
                    @0,
                    @0,
                    @0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTabBadge:) name:@"ILBadgeUpdateNotification" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:@"ILBadgeUpdateNotification"];
}

- (void)refreshTabBadge:(id)sender {
    if([AVUser currentUser]) {
        NSNumber *commentBadge = [[NSUserDefaults standardUserDefaults] objectForKey:@"commentBadge"];
        NSNumber *likeBadge = [[NSUserDefaults standardUserDefaults] objectForKey:@"likeBadge"];
        NSNumber *messageBadge = [[NSUserDefaults standardUserDefaults] objectForKey:@"messageBadge"];
        NSNumber *followerBadge = [[NSUserDefaults standardUserDefaults] objectForKey:@"followerBadge"];
        
        _badgeArray = @[commentBadge, likeBadge, messageBadge, followerBadge];
        
        __block NSInteger badgeNumber = 0;
        [_badgeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            badgeNumber = badgeNumber + [obj integerValue];
        }];
        
        if (badgeNumber > 0) {
            NSString *badgeString = [NSString stringWithFormat:@"%ld", (long)badgeNumber];
            [[[[self.tabBarController tabBar] items] objectAtIndex:4] setBadgeValue:badgeString];
             [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
        } else {
            [[[[self.tabBarController tabBar] items] objectAtIndex:4] setBadgeValue:nil];
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    }
    
    [_settingTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = NO;
    }
    
    if ([AVUser currentUser]) {
        [ILDreamDBManager fetchBadge];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionContentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArray = (NSArray *)_sectionContentArray[section];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        UserProfileCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileCell" forIndexPath:indexPath];
        profileCell.userObject = [AVUser currentUser];
        profileCell.delegate = self;

        return profileCell;
    } else {
        UITableViewCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"SettingDefaultCell" forIndexPath:indexPath];
        defaultCell.textLabel.font = GetFontAvenirNext(14.0f);
        defaultCell.textLabel.textColor = FlatGray;
        defaultCell.textLabel.text = _sectionContentArray[indexPath.section][indexPath.row];
        
        if (indexPath.section == 1) {
            if ([_badgeArray[indexPath.row] integerValue] > 0) {
                defaultCell.detailTextLabel.font = GetFontAvenirNext(12.0f);
                defaultCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld条新消息", (long)[_badgeArray[indexPath.row] integerValue]];
                defaultCell.detailTextLabel.textColor = FlatRed;
            } else {
                defaultCell.detailTextLabel.text = @"";
            }
        } else {
            defaultCell.detailTextLabel.text = @"";
        }
        
        return defaultCell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];

    if (![AVUser currentUser]) {
        if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {
            CDLoginVC *loginVC = [[CDLoginVC alloc] init];
            CDBaseNavC *loginNav = [[CDBaseNavC alloc] initWithRootViewController:loginVC];
            [self presentViewController:loginNav animated:YES completion:nil];
            
            return;
        }
    }
    
    if (indexPath.section == 0) {
        if ([AVUser currentUser]) {
            [self showActionSheet];
        }
    } else if (indexPath.section == 1) {
        [ILDreamDBManager resetBadge:indexPath.row];
        if (indexPath.row == 0) {
            ILCommentMessageViewController *commentMessageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILCommentMessageViewController"];
            [self.navigationController pushViewController:commentMessageVC animated:YES];
        } else if (indexPath.row == 1 ){
            ILLikeMessageViewController *likeMessageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILLikeMessageViewController"];
            [self.navigationController pushViewController:likeMessageVC animated:YES];
        } else if (indexPath.row == 2) {
            ILPrivateMessageListViewController *privateMessageListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILPrivateMessageListViewController"];
            [self.navigationController pushViewController:privateMessageListVC animated:YES];
        } else {
            ILFollowMessageViewController *followMessageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILFollowMessageViewController"];
            [self.navigationController pushViewController:followMessageVC animated:YES];
        }
    } else if (indexPath.section == 2) {
        ILFriendListViewController *friendListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILFriendListViewController"];
        friendListVC.friendType = indexPath.row;
        [self.navigationController pushViewController:friendListVC animated:YES];
    } else {
        if (indexPath.row == 0) {
            [self shareMessage:@"一个梦想，就是一种力量! 我在[彩虹梦想]，期待和你一起努力实现梦想！下载地址：http://itunes.apple.com/app/id1158543123" onView:currentCell];
        } else if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppReviewURL]];
        } else if (indexPath.row == 2) {
            NSString *subject = @"彩虹梦想 用户反馈";
            NSArray *recipientArray = [NSArray arrayWithObject: @"inspirelife@hotmail.com"];
            NSString *body = @"";
            
            NSDictionary *emaidContentDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                              subject, @"subject",
                                              recipientArray, @"recipients",
                                              body, @"body",
                                              nil];
            
            [self sendMailInApp:emaidContentDict];
        }else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kPrivacyURL]];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_sectionTitleArray objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 64.0f;
    } else {
        return 44.0f;
    }
}

#pragma mark ILUserProfileDefaultViewDelegate
- (void)clickProfile:(AVUser *)userObject {
    // do nothing
}

#pragma mark others
- (void)showActionSheet {
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"更新用户信息" message:nil];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"更新头像" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        [self pickImage];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"更改座右铭" style:TYAlertActionStyleDefault handler:^(TYAlertAction *action) {
        ILMottoViewController *mottoVC = [[ILMottoViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:mottoVC animated:YES];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"退出登陆" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        [AVUser logOut];
        AVInstallation *installation = [AVInstallation currentInstallation];
        [installation setObject:nil forKey:@"owner"];
        [installation saveInBackground];
        [[MyDreamCache sharedInstance] clearCache];
        [[MyLikeCache sharedInstance] clearCache];
        
        [[NSUserDefaults standardUserDefaults] setObject:@0  forKey:@"commentBadge"];
        [[NSUserDefaults standardUserDefaults] setObject:@0  forKey:@"likeBadge"];
        [[NSUserDefaults standardUserDefaults] setObject:@0  forKey:@"messageBadge"];
        [[NSUserDefaults standardUserDefaults] setObject:@0  forKey:@"followerBadge"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[[[self.tabBarController tabBar] items] objectAtIndex:4] setBadgeValue:nil];

        [_settingTableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ILUserLogoutNotification" object:nil];
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        NSLog(@"%@",action.title);
    }]];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:alertView preferredStyle:TYAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (MCPhotographyHelper *)photographyHelper {
    if (_photographyHelper == nil) {
        _photographyHelper = [[MCPhotographyHelper alloc] init];
    }
    return _photographyHelper;
}

-(void)pickImage {
    [self.photographyHelper showOnPickerViewControllerOnViewController:self completion:^(UIImage *image) {
        if (image) {
            UIImage *rounded = [CDUtils roundImage:image toSize:CGSizeMake(44, 44) radius:10];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[CDUserManager manager] updateAvatarWithImage:rounded callback:^(BOOL succeeded, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [_settingTableView reloadData];
                if ([self filterError:error]) {
                }
            }];
        }
    }];
}

@end
