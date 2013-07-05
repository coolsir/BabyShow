//
//  TBViewController.m
//  baiduTieba
//
//  Created by Kevin Lee on 13-5-13.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "TBViewController.h"
#import "PullingRefreshTableView.h"
#import "TBModel.h"
#import "SVProgressHUD.h"
#import "TBService.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
@interface TBViewController ()<PullingRefreshTableViewDelegate>
{
    BOOL isLoading ;
    
}
@property (retain,nonatomic) PullingRefreshTableView *mytableView;
@property (nonatomic) BOOL refreshing;

@end

@implementation TBViewController

@synthesize videos;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
   
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"TBCell" bundle:nil]forCellReuseIdentifier:@"TBCell"];
    
    CGRect bounds = self.view.bounds;
//    bounds.size.height -= 44.f;
    self.mytableView = [[PullingRefreshTableView alloc] initWithFrame:bounds pullingDelegate:self];
    self.tableView = self.mytableView;
    self.videos = [[NSMutableArray alloc] init];
    [self loadDataFromNet];

}

- (void)loadDataFromNet{
    // Show loading
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    isLoading = YES;
    //取出从网上取出数据
    [[TBService sharedService] findTBByPageId:@"0" success:^(id JSON) {
        NSLog(@"%@",JSON);
        //json数据解析封装
        NSArray *results  =  [JSON valueForKey:@"tbModels"];
        NSInteger resultCount = 0;
        if ([results isKindOfClass:[NSNull class]]) {
            resultCount = 0;
        }
        else {
            resultCount = [results count];
        }
        NSMutableArray *responseList = [[NSMutableArray alloc] init];
        // Get own item list
        for (int i = 0; i < resultCount; i++) {
            id JSON = [results objectAtIndex:i];
            TBModel *tbModel = [[TBModel alloc] init];
            [tbModel initWithJSON:JSON];
            [responseList  addObject:tbModel];
            [tbModel release];
        }
        [self.videos addObjectsFromArray:responseList];
        [self.tableView reloadData];
        if (isLoading == YES) {
            [SVProgressHUD dismiss];
            isLoading = NO;
        }
    } failure:^(NSDictionary *error) {
        if (isLoading == YES) {
            [SVProgressHUD dismissWithError:@"数据加载失败" afterDelay:1.0f];
        }
    }];


};

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    [self loadDataFromNet];
    [self.mytableView tableViewDidFinishedLoading];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    
    
    self.refreshing = YES;
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [df dateFromString:@"2012-05-03 10:10"];
    return date;
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.mytableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.mytableView tableViewDidEndDragging:scrollView];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.videos count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TBCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"TBCell" owner:self options:nil];
        cell = (UITableViewCell *)[nibArray objectAtIndex:0];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:201];
    TBModel *tbModle =  (TBModel*)[self.videos objectAtIndex:indexPath.row ];
    label.text = tbModle.tb_title;
   
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:202];
   
    //设置圆角
    imgView.layer.cornerRadius = 7;
    imgView.layer.masksToBounds = YES;
    
    
    //自适应图片宽高比例
  //  imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *imageUrlString = tbModle.tb_brief;
    
    [imgView setImageWithURL:[NSURL URLWithString:imageUrlString]
                   placeholderImage:[UIImage imageNamed:@"treasure_secret.png"]];
  
    return cell;
}


@end
