//
//  OrderViewController.m
//  AFNeting2Test
//
//  Created by xb on 13-5-24.
//
//

#import "OrderViewController.h"
#import "TBViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SDSegmentedControl.h"

#import "TBModel.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"Order";
        
    }
    return self;
}

- (void) segChangeValue:(SDSegmentedControl *)sender{
    
    NSLog(@"%d",[sender selectedSegmentIndex]);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pic_background"]];
    /*segment 切换*/
	NSArray *arr = [[NSArray alloc]initWithObjects:@"热门推荐",@"销量排行",@"所有", nil];
    SDSegmentedControl *sdSegment  =   [[SDSegmentedControl alloc] initWithItems:arr];
    sdSegment.frame = CGRectMake(0, 0, 320, 44);
    [self.view addSubview:sdSegment];
    [sdSegment addTarget:self action:@selector(segChangeValue:) forControlEvents:UIControlEventValueChanged];
    //----------------------------------------------
    self.tableviewVC = [[TBViewController alloc] initWithNibName:@"TBViewController" bundle:nil];
    self.tableviewVC.tableView.delegate = self.tableviewVC;
    self.tableviewVC.tableView.dataSource = self.tableviewVC;
    self.tableviewVC.view.frame = CGRectMake(0, 44, 320, 480-44);
    [self.view addSubview:self.tableviewVC.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
