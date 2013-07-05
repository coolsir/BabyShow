//
//  CommentViewController.h
//  AFNeting2Test
//
//  Created by xb on 13-5-24.
//
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "EGORefreshTableHeaderView.h"
@interface StoryViewController : UIViewController<PSCollectionViewDelegate, PSCollectionViewDataSource,EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL isLoading ;
    
}
@property(strong,nonatomic)PSCollectionView  *psCollectionV;
@property(strong,nonatomic)   NSMutableArray  *storyItems;


- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end
