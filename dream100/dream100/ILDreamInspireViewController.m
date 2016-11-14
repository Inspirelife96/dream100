//
//  ILDreamInspireViewController.m
//  dream100
//
//  Created by Chen XueFeng on 16/10/5.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import "ILDreamInspireViewController.h"
#import "ILDreamInspireDetailViewController.h"
#import "ILDreamInspireCell.h"
#import "MyDreamCache.h"    

@interface ILDreamInspireViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property(strong, nonatomic) NSArray *categoryArray;

@end

@implementation ILDreamInspireViewController

#pragma mark Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"启迪";
    _inspireCollectionView.dataSource = self;
    _inspireCollectionView.delegate = self;
    
    NSString *categoryDataPath = [[NSBundle mainBundle] pathForResource:@"category" ofType:@"plist"];
    _categoryArray = [NSArray arrayWithContentsOfFile:categoryDataPath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _categoryArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ILDreamInspireCell *cell = (ILDreamInspireCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ILDreamInspireCell" forIndexPath:indexPath];
    cell.inspireCellDict = _categoryArray[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.bounds.size.width - 30.0f)/2.0f;
    CGFloat height = width +  + 21.0f;
    return CGSizeMake(width, height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ILDreamInspireDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ILDreamInspireDetailViewController"];
    
    detailVC.categoryDict = _categoryArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
