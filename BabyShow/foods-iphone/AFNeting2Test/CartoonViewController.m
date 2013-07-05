//
//  CartoonViewController.m
//  BabyShow
//
//  Created by 刘 麒麟 on 13-7-4.
//
//

#import "CartoonViewController.h"

@interface CartoonViewController ()
{

    int _pageIndex;

}
@end

@implementation CartoonViewController

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
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


#pragma PSCollectionViewCell  Delegate&DataSource  -----------------------

- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index{
        
    return nil;
}




- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    
    
    return nil;
}



- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    
    return [self.storyItems count];
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index{
    NSLog(@"selected----------");
}


@end
