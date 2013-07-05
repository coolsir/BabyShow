//
//  ShowViewController.m
//  BabyShow
//
//  Created by 刘 麒麟 on 13-7-4.
//
//

#import "ShowViewController.h"
#import "VideosViewController.h"
@interface ShowViewController ()

@end

@implementation ShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
	[self.view addSubview: [[VideosViewController alloc] init].view ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
