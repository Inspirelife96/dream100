//
//  ILMottoViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/11/11.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILMottoViewController.h"

@interface ILMottoViewController ()

@property(strong, nonatomic) NSArray *mottoArray;

@end

@implementation ILMottoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mottoArray = @[@"世上最快乐的事，莫过于为理想而奋斗。",
                    @"先相信你自己，然后别人才会相信你。",
                    @"冬天已经到来，春天还会远吗?",
                    @"沉沉的黑夜都是白天的前奏。",
                    @"梦想一旦被付诸行动，就会变得神圣。",
                    @"抱负是高尚行为成长的萌牙",
                    @"一种理想，就是一种力量!",
                    @"生活中没有理想的人，是可怜的人。",
                    @"希望的火花在黑暗的天空闪耀。",
                    @"生活的理想，就是为了理想的生活。",
                    @"贫不足羞，可羞是贫而无志。",
                    @"壮心未与年俱老，死去犹能作鬼雄。",
                    @"大鹏一日同风起，扶摇直上九万里。",
                    @"穷且益坚，不坠青云之志。",
                    @"燕雀戏藩柴，安识鸿鹄游。",
                    @"老骥伏枥，志在千里;烈士暮年，壮心不已。",
                    @"志当存高远。",
                    @"燕雀安知鸿鹄之志哉!",
                    ];
    
    self.navigationItem.title = @"座右铭";
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
    return _mottoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ILMottoCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ILMottoCell"];
    }
    
    cell.textLabel.font = GetFontAvenirNext(14.0f);
    cell.textLabel.text = _mottoArray[indexPath.row];
    
    NSString *userMotto = [AVUser currentUser][@"motto"];
    NSString *currentMotto = _mottoArray[indexPath.row];
    if ([userMotto isEqualToString:currentMotto]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = FlatBlue;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = FlatGray;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[AVUser currentUser] setObject:_mottoArray[indexPath.row] forKey:@"motto"];
    [[AVUser currentUser] saveEventually];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
