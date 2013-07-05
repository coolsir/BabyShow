//
//  LeftViewController.m
//  BabyShow
//
//  Created by 刘 麒麟 on 13-7-2.
//
//

#import "LeftViewController.h"
#import "DDMenuController.h"
#import "VideosViewController.h"
#import "StoryViewController.h"
#import "ShowViewController.h"
#import "OrderViewController.h"
@interface LeftViewController ()
{
    NSMutableArray *imgNormalList;
    NSMutableArray *titleList;

}
@end

@implementation LeftViewController
@synthesize tableView = _tableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	    
    imgNormalList = [[NSMutableArray alloc] initWithObjects:@"navigation_news_top_ico.png",
                     @"navigation_my_collect_ico.png",@"navigation_classify_ico_newssite.png",
            @"navigation_classify_ico_carefully_chosen.png",@"navigation_app_recommend_ico.png",
            @"navigation_classify__ico_international.png",@"navigation_classify_ico_car.png",
                     @"navigation_classify_ico_creative.png",nil];
    titleList = [[NSMutableArray alloc] initWithObjects:@"新闻",@"小视频",
                 @"漫画王子",@"小故事精选",@"My Order",@"Baby Show",@"汽车",@"创意",@"", nil];
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = self.view.frame;
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_background.png"]]];

    [self.view addSubview:self.tableView];
    //去掉多余的分割线
    [self setExtraCellLineHidden:self.tableView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  UITableView 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [imgNormalList count];
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
};
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    [cell setBackgroundColor:[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:0.1]];

    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [titleList objectAtIndex:row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"sans-serif" size:14.0f];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[imgNormalList objectAtIndex:row]]];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"collect_list_arrow@2x.png"] forState:UIControlStateNormal];
    
    [btn setFrame:CGRectMake(250, cell.height/2-10, 15,20)];
    
    [cell.contentView addSubview:btn];
    
    
    UIView *selectionColor = [[UIView alloc]init];
    selectionColor.backgroundColor =[UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:0.1];
    cell.selectedBackgroundView = selectionColor;
    
    return cell;
    
};

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    DDMenuController *menuController = [AppDelegate  appDelegate].menuController;
    UINavigationController *navController  = nil;
    switch (indexPath.row) {
        case 0:
            
            break;
        //我的视频
        case 1:{
            VideosViewController *videoVC = [[VideosViewController alloc] init];
            videoVC.title = [NSString stringWithFormat:@"Video"];
            navController = [[UINavigationController alloc] initWithRootViewController:videoVC];
            
            }
            break;
        //漫画桌
        case 2:
            
            
            break;
        //小故事
        case 3:{
            StoryViewController *storyVC = [[StoryViewController alloc] init];
            storyVC.title = [NSString stringWithFormat:@"Story"];
            navController = [[UINavigationController alloc] initWithRootViewController:storyVC];
          }
            break;
        //My Order
        case 4:{
            OrderViewController *orderVC = [[OrderViewController alloc] init];
            orderVC.title = [NSString stringWithFormat:@"Order"];
            navController = [[UINavigationController alloc] initWithRootViewController:orderVC];
        }
            break;
        default:
            break;
       
    }
     [menuController setRootController:navController animated:YES];
    
    
         
   
};

- (void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}

@end
