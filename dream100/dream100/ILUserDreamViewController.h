//
//  ILUserDreamViewController.h
//  
//
//  Created by Chen XueFeng on 16/10/4.
//
//

#import <UIKit/UIKit.h>
#import "ILDreamBasedViewController.h"
#import "UserHeaderView.h"

@interface ILUserDreamViewController : ILDreamBasedViewController

@property(strong, nonatomic) IBOutlet UserHeaderView *userHeaderView;

@property(strong, nonatomic) AVUser *currentUser;

@end
