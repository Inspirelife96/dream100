//
//  ILDreamInspireDetailViewController.h
//  dream100
//
//  Created by Chen XueFeng on 16/10/21.
//  Copyright © 2016年 Chen XueFeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILDreamBasedViewController.h"

@interface ILDreamInspireDetailViewController : ILDreamBasedViewController

@property(strong, nonatomic) IBOutlet UIImageView *headerImageView;

@property(strong, nonatomic) NSDictionary *categoryDict;

@end
