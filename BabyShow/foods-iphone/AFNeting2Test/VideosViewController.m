
#import "UIFactory.h"
#import "VideosViewController.h"
#import "PullingRefreshTableView.h"
#import "Video.h"
#import "SVProgressHUD.h"
#import "VideoService.h"
#import "UIImageView+AFNetworking.h"
#import "PlayerViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface VideosViewController ()<PullingRefreshTableViewDelegate>
{
    BOOL isLoading ;
    MPMoviePlayerViewController *playerViewController;
    NSString * _currentCategory;
    NSMutableDictionary *_videosDic;
     NSMutableDictionary *_pageNumDic;
}
@property (retain,nonatomic) PullingRefreshTableView *mytableView;
@property (nonatomic) BOOL refreshing;

@end

@implementation VideosViewController

@synthesize videos;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:imagePath(@"navigationbar_back", @"png") forState:UIControlStateNormal];
    [btn setBackgroundImage:imagePath(@"navigationbar_back_highlighted", @"png") forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 24, 24);
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
   // self.navigationItem.leftBarButtonItem = [backItem autorelease];
    
    
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(100.0f, 8.0f, 120.0f, 30.0f) ];
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"nav-button.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:[UIImage imageNamed:@"nav-button-press.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
     //带修改（修改为黑色的背景图片）
   [segmentedControl insertSegmentWithTitle:@"Free" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"Charge" atIndex:1 animated:YES];
    segmentedControl.momentary = YES;  
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.multipleTouchEnabled=NO;
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    //self.navigationItem.titleView = [segmentedControl autorelease];
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar-iPhone.png"] forBarMetrics:UIBarMetricsDefault];
    
    _videosDic = [[NSMutableDictionary alloc] init];
    _pageNumDic = [[NSMutableDictionary alloc] init];
#pragma  表格设置
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    CGRect bounds = self.view.bounds;
    self.mytableView = [[PullingRefreshTableView alloc] initWithFrame:bounds pullingDelegate:self];
    self.tableView = self.mytableView;
    self.videos = [[NSMutableArray alloc] init];
    //默认加载免费视频
    _currentCategory = @"0";
    [self loadDataFromNet:_currentCategory];
}


-(void)segmentAction:(UISegmentedControl *)Segment{
    NSInteger index = Segment.selectedSegmentIndex;
    NSLog(@"%d",index);
    if (index == 0) {
        if (![_currentCategory isEqualToString:@"0"]) {
           // [self.videos removeAllObjects];
        }
       _currentCategory = @"0";
    }else if (index == 1) {
        if (![_currentCategory isEqualToString:@"1"]) {
           // [self.videos removeAllObjects];
        }
        _currentCategory = @"1";
    }
    
    if (self.mytableView.footerView.state == kPRStateHitTheEnd ) {
        self.mytableView.footerView.state = kPRStateNormal;
        
    }
    
    [self loadDataFromNet:_currentCategory];
    //防止下方有部分下拉时的状态留下
    NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.mytableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


- (void)loadDataFromNet:(NSString*)categeroy{
    // Show loading
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    isLoading = YES;
    
    //当前页数
    if ( [_pageNumDic objectForKey:categeroy] != NULL) {
        NSNumber *pageNum = [_pageNumDic objectForKey:categeroy];
        int num = [pageNum intValue];
        num++;
        [_pageNumDic setObject:[NSNumber numberWithInt:num] forKey:categeroy];
    }else{
        [_pageNumDic setObject:[NSNumber numberWithInt:0] forKey:categeroy];
    }
    
    //取出从网上取出数据
    [[VideoService sharedService] findTBByPageId:categeroy pageNum:[NSString stringWithFormat:@"%d",[[_pageNumDic objectForKey:categeroy] intValue]] pageSize:@"4" success:^(id JSON) {
        
        NSArray *results  =  [JSON valueForKey:@"Videos"];
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
            Video *video = [[Video alloc] init];
            [video initWithJSON:JSON];
            [responseList  addObject:video];
            [video release];
        }
        if ([responseList count] <= 0) {
            //减回增加的页码数
            if ( [_pageNumDic objectForKey:categeroy] != NULL) {
                NSNumber *pageNum = [_pageNumDic objectForKey:categeroy];
                int num = [pageNum intValue];
                num--;
                [_pageNumDic setObject:[NSNumber numberWithInt:num] forKey:categeroy];
            }
            //数据为空仍然显示原有数据
            self.videos = [_videosDic objectForKey:categeroy];
            [self.tableView reloadData];
            if (isLoading == YES) {
                [SVProgressHUD dismiss];
                isLoading = NO;
            }
            self.mytableView.footerView.state = kPRStateHitTheEnd;
            return;
        }
        
        
        if ([_videosDic objectForKey:categeroy] != NULL) {
            NSMutableArray *arrays = [_videosDic objectForKey:categeroy];
            [arrays addObjectsFromArray:responseList];
            [_videosDic setObject:arrays forKey:categeroy];
            self.videos = [_videosDic objectForKey:categeroy];
        }else{
            [_videosDic setObject:responseList forKey:categeroy];
        }
        self.videos = [_videosDic objectForKey:categeroy];
        [self.tableView reloadData];
        if (isLoading == YES) {
            [SVProgressHUD dismiss];
            isLoading = NO;
        }

    } failure:^(NSDictionary *error) {
        if (isLoading == YES) {
            [SVProgressHUD dismissWithError:@"数据加载失败" afterDelay:1.0f];
            isLoading = NO;
        }

    }];
};

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    [self loadDataFromNet:_currentCategory];
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
    static NSString *CellIdentifier = @"VideoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil];
        cell = (UITableViewCell *)[nibArray objectAtIndex:0];
    }
   
    UIImageView *imgView = (UIImageView *)[cell.contentView viewWithTag:101];
    //设置圆角
   // imgView.layer.cornerRadius = 7;
    imgView.layer.masksToBounds = YES;
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:102];
    Video *video =  (Video*)[self.videos objectAtIndex:indexPath.row ];
    label.text = video.videoName;
   //自适应图片宽高比例
   // imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *imageUrlString = video.videoThumbUrl;
    
    [imgView setImageWithURL:[NSURL URLWithString:imageUrlString]
                   placeholderImage:[UIImage imageNamed:@"page_image_loading.png"]];
    UIButton *playBtn  = (UIButton *)[cell.contentView viewWithTag:103];
    [playBtn setTitle:@"Play" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
 

    return cell;
}


- (void)play:(UIButton*)sender{
   
     UITableViewCell *btCell = (UITableViewCell*)[[[sender superview] superview] superview];
    UITableView *table = (UITableView*)[btCell superview];
     NSUInteger row = [[table indexPathForCell:btCell] row];
     Video *video =  (Video*)[self.videos objectAtIndex:row ];
    NSString *urlstring = video.videoUrl;
    NSURL *url = [NSURL URLWithString:urlstring];
    
    playerViewController = [[PlayerViewController alloc] initWithContentURL:url];
    //我顶你个肺
    playerViewController.hidesBottomBarWhenPushed = YES;
    
    //注册通知
    NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
    [ notificationCenter addObserver:self selector:@selector(doneAction:) name:MPMoviePlayerPlaybackDidFinishNotification object:[playerViewController moviePlayer]];
    
    
    [self.navigationController presentMoviePlayerViewControllerAnimated: playerViewController ];
    
}

- (void)doneAction:(NSNotification*)notification{
    
    [[playerViewController moviePlayer] stop];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
