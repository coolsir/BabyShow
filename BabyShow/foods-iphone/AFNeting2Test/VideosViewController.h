//
//  TBViewController.h
//  baiduTieba
//
//  Created by Kevin Lee on 13-5-13.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTUITableViewZoomController.h"

@interface VideosViewController : UITableViewController


@property(strong,nonatomic)   NSMutableArray    *videos;

- (void)loadDataFromNet;
@end
