//
//  CartoonViewController.h
//  BabyShow
//
//  Created by 刘 麒麟 on 13-7-4.
//
//

#import <UIKit/UIKit.h>
#import "PSCollectionView.h"
#import "EGORefreshTableHeaderView.h"

@interface CartoonViewController : UIViewController<PSCollectionViewDelegate, PSCollectionViewDataSource,EGORefreshTableHeaderDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL isLoading ;
    
}
@property(strong,nonatomic)PSCollectionView  *psCollectionV;
@property(strong,nonatomic)   NSMutableArray  *storyItems;


@end
