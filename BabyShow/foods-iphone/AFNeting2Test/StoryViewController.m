//
//  CommentViewController.m
//  AFNeting2Test
//
//  Created by xb on 13-5-24.
//
//

#import "StoryViewController.h"
#import "storyCell.h"
#import "StoryService.h"
#import "Video.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
@interface StoryViewController ()

@end

@implementation StoryViewController
@synthesize storyItems;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Story";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:244.0/255.0f blue:249.0/255.0f alpha:1];
    [self getStoryItems];
    
    
    
}


- (void)initPsCollectionV{

    self.psCollectionV = [[[PSCollectionView alloc]initWithFrame:self.view.bounds] autorelease];
    self.psCollectionV.delegate = self;
    self.psCollectionV.collectionViewDelegate = self;
    self.psCollectionV.collectionViewDataSource = self;
    self.psCollectionV.autoresizingMask =  UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    //设置列数
    self.psCollectionV.numColsPortrait = 2;
    self.psCollectionV.numColsLandscape= 3;
}

#pragma PSCollectionViewCell  Delegate&DataSource  -----------------------

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index{
    Video *item = [self.storyItems objectAtIndex:index];
    storyCell *v = (storyCell *)[self.psCollectionV  dequeueReusableViewForClass:[storyCell class]];
    if (!v) {
        v  = [[storyCell alloc] initWithFrame:CGRectZero];
    }
    
    [v collectionView:self.psCollectionV
        fillCellWithObject:item atIndex:index];
    
    v.layer.cornerRadius = 1;//设置那个圆角的有多圆
    v.layer.borderWidth = 1;//设置边框的宽度，当然可以不要
    v.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
    v.layer.masksToBounds = YES;//设为NO去试试
    
    return v;
}




- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    NSDictionary *item = [self.storyItems objectAtIndex:index];
    
    return [storyCell rowHeightForObject:item inColumnWidth:self.psCollectionV.colWidth];
}



- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    
    return [self.storyItems count];
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index{
    NSLog(@"selected----------");
}



#pragma  request From net ----------------------------------------------

- (void)getStoryItems{

    [[StoryService sharedService] findStorysByPageId:@"0" pageNum:@"0"  pageSize:@"20" success:^(id JSON) {
        
        NSArray *results  =  [JSON valueForKey:@"Storys"];
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
            
            NSMutableDictionary *story = [[NSMutableDictionary alloc]init];
            
            [story setObject:[JSON objectForKey:@"syName"] forKey:@"syName"];
            [story setObject:[JSON objectForKey:@"syBrief"] forKey:@"syBrief"];
            [story setObject:[JSON objectForKey:@"syContent"] forKey:@"syContent"];
            [story setObject:[JSON objectForKey:@"syTime"] forKey:@"syTime"];
            [story setObject:[JSON objectForKey:@"syUp"] forKey:@"syUp"];
            [story setObject:[JSON objectForKey:@"syDown"] forKey:@"syDown"];
            [story setObject:[JSON objectForKey:@"syThumbUrl"] forKey:@"syThumbUrl"];
            [story setObject:[JSON objectForKey:@"syImgWidth"] forKey:@"syImgWidth"];
            [story setObject:[JSON objectForKey:@"syImgHeight"] forKey:@"syImgHeight"];
            [story setObject:[JSON objectForKey:@"syCategory"] forKey:@"syCategory"];
            [responseList  addObject:story];
            [story release];
        }
        self.storyItems = [[NSMutableArray alloc] init];
        [self.storyItems addObjectsFromArray:responseList];
        
        //当数据请求完成时加载视图
        [self initPsCollectionV];
        [self.view addSubview:_psCollectionV];
        if (_refreshHeaderView == nil) {
            
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.psCollectionV.bounds.size.height, self.view.frame.size.width, self.psCollectionV.bounds.size.height)];
            view.delegate = self;
            [self.psCollectionV addSubview:view];
            _refreshHeaderView = view;
            [view release];
            
        }
        
        
        
        
        
        
        
    } failure:^(NSDictionary *error) {
        if (isLoading == YES) {
            [SVProgressHUD dismissWithError:@"数据加载失败" afterDelay:1.0f];
            isLoading = NO;
        }
        
    }];


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma  EGORefresh.........
- (void)reloadTableViewDataSource{
    isLoading = YES;
    NSLog(@"reloadTableViewDataSource");
};
- (void)doneLoadingTableViewData{
    isLoading = NO;
    NSLog(@"doneLoadingTableViewData");
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.psCollectionV];
};


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	 NSLog(@"scrollViewDidScroll");
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	NSLog(@"scrollViewDidEndDragging");
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];//reload tableview数据
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];//完成数据reload
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    //从网络请求数据
    
    NSLog(@"egoRefreshTableHeaderDataSourceIsLoading");

	return isLoading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
	
}


#pragma mark -
#pragma mark Memory Management


- (void)viewDidUnload {
	_refreshHeaderView=nil;
}

- (void)dealloc {
	
	_refreshHeaderView = nil;
    [super dealloc];
}



@end
