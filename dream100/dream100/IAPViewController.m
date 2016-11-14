//
//  IAPViewController.m
//  learnpaint
//
//  Created by Chen XueFeng on 15/12/23.
//  Copyright © 2015年 Chen XueFeng. All rights reserved.
//

#import "IAPViewController.h"
#import <StoreKit/StoreKit.h>
#import "StoreManager.h"
#import "StoreObserver.h"

#import <MBProgressHUD/MBProgressHUD.h>
#import "UILabel+StringFrame.h"
#import "UIViewController+Alert.h"

@interface IAPViewController ()


@property(copy, nonatomic) NSArray *productIdentifierArray;
@property(strong, nonatomic) UIBarButtonItem *restoreBarButton;

@end

@implementation IAPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleProductRequestNotification:)
                                                 name:IAPProductRequestNotification
                                               object:[StoreManager sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePurchasesNotification:)
                                                 name:IAPPurchaseNotification
                                               object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePurchasesCancelNotification:)
                                                 name:IAPPurchaseCancelNotification
                                               object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRestoreCancelNotification:)
                                                 name:IAPRestoreCancelNotification
                                               object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRestoreCompleteNotification:)
                                                 name:IAPRestoreCompleteNotification
                                               object:[StoreObserver sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePaymentRemovedNotification:)
                                                 name:IAPPaymentRemovedNotification
                                               object:[StoreObserver sharedInstance]];
    
    if ([StoreManager sharedInstance].availableProducts.count <= 0) {
        self.productIdentifierArray = [NSArray arrayWithObjects:
                              kIAPVip,
                              kIAPAdRemoved,
                              nil];
        [[StoreManager sharedInstance] fetchProductInformationForIds:self.productIdentifierArray];
    }
    
    self.navigationItem.title = @"购买";
    self.restoreBarButton = [[UIBarButtonItem alloc] initWithTitle:@"恢复购买" style:UIBarButtonItemStylePlain target:self action:@selector(clickRestoreBarButton:)];
    self.navigationItem.rightBarButtonItem = self.restoreBarButton;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kIAPVip] && [[NSUserDefaults standardUserDefaults] boolForKey:kIAPAdRemoved]) {
        [self.restoreBarButton setEnabled:NO];
    }else {
        [self.restoreBarButton setEnabled:YES];
    }
    
    [self.tableView reloadData];
}

- (void) clickRestoreBarButton:(UIBarButtonItem*) sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[StoreObserver sharedInstance] restore];
}

- (void) dealloc
{
    // Unregister for StoreManager's notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPProductRequestNotification
                                                  object:[StoreManager sharedInstance]];
    
    // Unregister for StoreObserver's notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPPurchaseNotification
                                                  object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPPurchaseCancelNotification
                                                  object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPRestoreCancelNotification
                                                  object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPRestoreCompleteNotification
                                                  object:[StoreObserver sharedInstance]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [StoreManager sharedInstance].availableProducts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKProduct *product = (SKProduct *)[StoreManager sharedInstance].availableProducts[indexPath.section];
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *productIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 7.0f, 29.0f, 29.0f)];
    if ([product.productIdentifier isEqualToString:kIAPAdRemoved]) {
        productIconImageView.image = [UIImage imageNamed:@"buy_ad.png"];
    } else {
        productIconImageView.image = [UIImage imageNamed:@"buy_vip.png"];
    }
    
    UILabel *productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 10.0f, self.view.frame.size.width - 170.0f, 21.0f)];
    productNameLabel.text = [[StoreManager sharedInstance] titleMatchingProductIdentifier:product.productIdentifier];
    productNameLabel.font = GetFontAvenirNext(14.0f);
    productNameLabel.textColor = FlatGrayDark;
    
    UILabel *productPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60.0f - 100.0f, 10.0f, 90.0f, 21.0f)];
    productPriceLabel.textAlignment = NSTextAlignmentLeft;
    productPriceLabel.text = [[StoreManager sharedInstance] priceMatchingProductIdentifier:product.productIdentifier];
    productPriceLabel.font = GetFontAvenirNext(14.0f);
    productPriceLabel.textColor = FlatGrayDark;
    
    BOOL hasPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier];
    
    UIButton *buyButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 10.0f - 60.0f, 7.0f, 60.0f, 30.0f)];
    buyButton.titleLabel.font = [UIFont fontWithName:@"Avenir Next" size:14.0];
    [buyButton setTag:indexPath.section];
    if (hasPurchased) {
        [buyButton setTitle:@"已购买" forState:UIControlStateNormal];
        [buyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [buyButton setBackgroundImage:[UIImage imageNamed:@"buy_disable_button"] forState:UIControlStateNormal];
        [buyButton setTag:indexPath.section];
        [buyButton setEnabled:NO];
    } else {
        [buyButton setTitle:@"购买" forState:UIControlStateNormal];
        [buyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buyButton setBackgroundImage:[UIImage imageNamed:@"buy_disable_button"] forState:UIControlStateNormal];
        [buyButton addTarget:self action:@selector(clickBuyButton:) forControlEvents:UIControlEventTouchUpInside];
        [buyButton setEnabled:YES];
    }
    
    UILabel *productDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0f, 38.0f, self.view.frame.size.width - 50.0f - 10.0f, 21.0f)];
    productDetailLabel.numberOfLines = 0;
    productDetailLabel.font = GetFontAvenirNext(12.0f);
    productDetailLabel.textColor = FlatGray;
    productDetailLabel.text = product.localizedDescription;
    CGSize size = [productDetailLabel boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 50.0f - 10.0f, 0.0f) attributes:nil];
    [productDetailLabel setFrame:CGRectMake(50.0f, 38.0f, size.width, size.height)];
    
    [cell.contentView addSubview:productIconImageView];
    [cell.contentView addSubview:productNameLabel];
    [cell.contentView addSubview:productPriceLabel];
    [cell.contentView addSubview:buyButton];
    [cell.contentView addSubview:productDetailLabel];
    
    return cell;
}

- (void) clickBuyButton:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIButton *buyButton = (UIButton *)sender;
    [buyButton removeTarget:self action:@selector(clickBuyButton:) forControlEvents:UIControlEventTouchUpInside];

    NSUInteger productIndex = ((UIButton*)sender).tag;
    SKProduct *product = (SKProduct *)[StoreManager sharedInstance].availableProducts[productIndex];
    [[StoreObserver sharedInstance] buy:product];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKProduct *product = (SKProduct *)[StoreManager sharedInstance].availableProducts[indexPath.section];
    UILabel *productDetailLabel = [[UILabel alloc] init];
    productDetailLabel.numberOfLines = 0;
    productDetailLabel.font = [UIFont fontWithName:@"Avenir Next" size:12.0];
    productDetailLabel.textColor = [UIColor lightGrayColor];
    productDetailLabel.text = product.localizedDescription;
    CGSize size = [productDetailLabel boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 50.0f - 10.0f, 0.0f) attributes:nil];
    return 44.0f + size.height;
}

// Update the UI according to the product request notification result
-(void)handleProductRequestNotification:(NSNotification *)notification {
    StoreManager *productRequestNotification = (StoreManager*)notification.object;
    IAPProductRequestStatus result = (IAPProductRequestStatus)productRequestNotification.status;
    
    if (result == IAPProductRequestResponse) {
        [self.tableView reloadData];
    }
}

- (void)handlePurchasesNotification:(NSNotification *)notification {
    StoreObserver *purchasesNotification = (StoreObserver *)notification.object;
    IAPPurchaseNotificationStatus status = (IAPPurchaseNotificationStatus)purchasesNotification.status;
    
    switch (status) {
        case IAPPurchaseFailed:
            [self presentAlertTitle:@"Purchase Status" message:purchasesNotification.message];
            break;
        case IAPRestoredSucceeded:
            break;
        case IAPRestoredFailed:
            [self presentAlertTitle:@"Purchase Status" message:purchasesNotification.message];
            break;
        case IAPDownloadStarted:
            break;
        case IAPDownloadInProgress:
            break;
        case IAPDownloadSucceeded:
            break;
        default:
            break;
    }

    if ([[StoreObserver sharedInstance] isPurchasedProduct:kIAPAdRemoved]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultIsAdRemoved];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[StoreObserver sharedInstance] isPurchasedProduct:kIAPVip]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultIsVip];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVIPChanged object:nil];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self updateUI];
}

- (void)handlePurchasesCancelNotification:(NSNotification *)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self updateUI];
}

- (void)handleRestoreCompleteNotification:(NSNotification *)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([[StoreObserver sharedInstance] isPurchasedProduct:kIAPAdRemoved]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIAPAdRemoved];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[StoreObserver sharedInstance] isPurchasedProduct:kIAPVip]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIAPVip];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVIPChanged object:nil];
    }
    
    [self updateUI];
}

-(void)handleRestoreCancelNotification:(NSNotification *)notification
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)handlePaymentRemovedNotification:(NSNotification *)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
