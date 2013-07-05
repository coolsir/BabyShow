//
//  LeftViewController.h
//  BabyShow
//
//  Created by 刘 麒麟 on 13-7-2.
//
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@end
