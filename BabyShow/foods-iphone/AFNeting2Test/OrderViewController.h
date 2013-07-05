//
//  OrderViewController.h
//  AFNeting2Test
//
//  Created by xb on 13-5-24.
//
//

#import <UIKit/UIKit.h>
@class TBViewController;
#import "BaseViewController.h"
@interface OrderViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong, nonatomic) TBViewController *tableviewVC;
@end
