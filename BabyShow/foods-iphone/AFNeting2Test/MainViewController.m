//
//  MainViewController.m
//  AFNeting2Test
//
//  Created by xb on 13-5-20.
//


#import "MainViewController.h"
#import "StoryViewController.h"
#import "VideosViewController.h"
#import "UIFactory.h"
@interface MainViewController ()
{
    VideosViewController *_videosVC;
    StoryViewController *_stroyVC;

}
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    //初始化背景
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:imagePath(@"Default",@"png")]];
    [self initActionModels];
     _videosVC =[[VideosViewController alloc] init];
     _stroyVC = [[StoryViewController alloc]  init];
}



- (void)initActionModels{
    NSMutableArray *btns = [[NSMutableArray alloc] init];
    NSArray *imgsNormol = @[@"contact",@"position",@"scenicmap",@"table"];
    NSArray *imgsSelected = @[@"contact",@"position",@"scenicmap",@"table"];
    for (int i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:imagePath([imgsNormol objectAtIndex:i], @"png") forState:UIControlStateNormal];
        [btn setBackgroundImage:imagePath([imgsSelected objectAtIndex:i], @"png") forState:UIControlStateHighlighted];
        btn.tag = 100+i;
       [btn addTarget:self action:@selector(ModleAction:) forControlEvents:UIControlEventTouchUpInside];
         [btns addObject:btn];
        //布局
        //设有n个 则
        //w
        //左右margin
        //间隔space = (width-2*margin-n*w)/(n-1)
        int n_x = 2;
        int n_y = 2;
        int w_box = 80;
        int h_box = 80;
        int margin_x = 60;
        int margin_y = 120;
        int  width = [UIScreen mainScreen].bounds.size.width;
        int  height = [UIScreen mainScreen].bounds.size.height;

        int w_space = (width- 2*margin_x-n_x*w_box)/(n_x-1);
        int h_space = (height- 2*margin_y-n_y*h_box)/(n_y-1);
        
        btn.frame = CGRectMake(margin_x+(i%2)*w_space+(i%2)*w_box,
                               margin_y+(i/2)*h_space+(i/2)*h_box, 80, 80);
        [self.view addSubview:btn];
    }
    
    

}


- (void) ModleAction:(UIButton*)sender{
    NSLog(@"pppp%d",sender.tag);
    switch (sender.tag) {
        case 100:
        
            [self.navigationController pushViewController:_videosVC animated:YES];
            
            
            break;
        case 101:
            [self.navigationController pushViewController:_stroyVC animated:YES];
            break;
        case 102:
            
            break;
        case 103:
            
            break;
        default:
            break;
    }

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ( viewController ==  self) {
        [navigationController setNavigationBarHidden:YES animated:animated];
    } else if ( [navigationController isNavigationBarHidden] ) {
        [navigationController setNavigationBarHidden:NO animated:animated];
    } 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
