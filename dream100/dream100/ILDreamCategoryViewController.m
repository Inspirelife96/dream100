//
//  ILDreamCategoryViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/4.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILDreamCategoryViewController.h"

@interface ILDreamCategoryViewController ()

@property(strong, nonatomic) NSArray *categoryArray;

@end

@implementation ILDreamCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"梦想标签";
    self.navigationItem.leftBarButtonItem.title = @"";
    
    _categoryArray = @[
                       @"#一生所愿#",
                       @"#平凡人的英雄梦#",
                       @"#环游世界#",
                       @"#必须掌握的技能#",
                       @"#充实自我#",
                       @"#和家人#",
                       @"#坚持健身的同学最伟大#",
                       @"#养生之道#",
                       @"#必须改掉的坏毛病#",
                       @"#想读的书单#",
                       @"#必看的电影#",
                       @"#我爱游戏#",
                       @"#最想要的生日礼物#",
                       @"#买买买#",
                       @"#狗狗猫咪#",
                       @"#创意生活#"
                       ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DreamCategoryCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DreamCategoryCell"];
    }
    
    if ([_dreamModel.dreamCategoryString isEqualToString:_categoryArray[indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = FlatBlue;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = FlatGrayDark;
    }
    
    cell.textLabel.text = _categoryArray[indexPath.row];
    cell.textLabel.font = GetFontAvenirNext(14.0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _dreamModel.dreamCategoryString = [_categoryArray[indexPath.row] copy];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
