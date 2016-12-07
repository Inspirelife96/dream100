//
//  ILUserDreamViewController.m
//  
//
//  Created by Chen XueFeng on 16/10/4.
//
//

#import "ILUserDreamViewController.h"
#import "XWPublishController.h"
#import "DreamCell.h"
#import "UILabel+StringFrame.h"
#import "ILJourneyViewController.h"

@interface ILUserDreamViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSMutableArray *dreamObjectArray;

@end

@implementation ILUserDreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _myDreamTableView.delegate = self;
    _myDreamTableView.dataSource = self;
    _myDreamTableView.tableFooterView = [[UIView alloc] init];
    
    if (!_currentUser) {
        _currentUser = [AVUser currentUser];
        UIBarButtonItem *addDreamBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickAddDreamBarButton:)];
        self.navigationItem.rightBarButtonItem = addDreamBarButton;
    }
}

- (void)viewWillLayoutSubviews {
    _userHeaderView.userObject = _currentUser;
    _dreamObjectArray = [[NSMutableArray alloc] init];
    
    AVQuery *query = [AVQuery queryWithClassName:@"Dream"];
    [query whereKey:@"user" equalTo:_currentUser];
    [query orderByDescending:@"createdAt"];
    [query setLimit:10];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            //
        } else {
            [_dreamObjectArray removeAllObjects];
            [_dreamObjectArray addObjectsFromArray:objects];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [_myDreamTableView reloadData];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dreamObjectArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DreamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DreamCell" forIndexPath:indexPath];
    cell.dreamObject = _dreamObjectArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DreamCell HeightForDreamCell:_dreamObjectArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ILJourneyViewController *dreamDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILJourneyViewController"];
    dreamDetailVC.dreamObject = _dreamObjectArray[indexPath.row];
    //dreamDetailVC.user = [AVUser currentUser];
    [self.navigationController pushViewController:dreamDetailVC animated:YES];
}

- (void)clickAddDreamBarButton:(UIBarButtonItem *)send {
    XWPublishController *publishVC = [[XWPublishController alloc] init];
    publishVC.type = 0;
    publishVC.dreamObject = nil;
    [self.navigationController pushViewController:publishVC animated:YES];
}

@end
