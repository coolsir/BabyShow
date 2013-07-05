//
//  SNRootViewController.m
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//

#import "SNRootViewController.h"
#import "SNBootstrapViewController.h"
#import "AppDelegate.h"
#import "SNAccountService.h"
#import "SNConstants.h"

@implementation SNRootViewController

@synthesize alreadyAccessedMyRoom = _alreadyAccessedMyRoom;

- (id)initWithBootstrap
{
    SNBootstrapViewController *vc = [[SNBootstrapViewController alloc] init];
    self = [super  initWithRootViewController:vc];
    [vc release];
    if (self) {
        // Custom initialization
        self.navigationBarHidden = YES;
        self.navigationBar.tintColor = kNavibarTintColor;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//------------------------------------------------------------------------------
#pragma - Static Method
#
+ (SNRootViewController *)currentViewController
{
    return (SNRootViewController *)[AppDelegate appDelegate].viewController;
}

//------------------------------------------------------------------------------
#pragma - Global navigation methods
#
//- (void)showRegistration
//{
//    // 既に登録画面の場合は遷移しない
//    if ([self.topViewController isMemberOfClass:[SNAnimolTypePickerViewController class]]) return;
//
//    // ViewControllerスタックをクリアにする
//    [self popToRootViewControllerAnimated:NO];
//    
//    // 登録画面へ遷移する
//    SNAnimolTypePickerViewController *vc = [[SNAnimolTypePickerViewController alloc] init];
//    [self pushViewController:vc animated:YES];
//    [vc release];
//}

//- (void)showMyRoom
//{
//    // 既にマイルームの場合は遷移しない
//    if ([self.topViewController isMemberOfClass:[SNMyRoomViewController class]]) return;
//    
//    // 既にマイルームに遷移したことがある（バックグラウンドからの復帰の）場合、
//    // マイルームへの遷移は無視する
//    if(self.alreadyAccessedMyRoom == YES) {
//        LOG(@"Not going to my room, because of coming back from multi tasking background.");
//        return;
//    }
//    
//    self.alreadyAccessedMyRoom = YES;
//    
//    // ViewControllerスタックをクリアにする
//    [self popToRootViewControllerAnimated:NO];
//    
//    // マイルームへ遷移する
//    SNMyRoomViewController *vc = [[SNMyRoomViewController alloc] init];
//    vc.animol = [SNAnimol currentAnimol];
//    [self pushViewController:vc animated:YES];
//    [vc release];
//}

- (void)showTop
{
    self.alreadyAccessedMyRoom = NO;
    
    // 既にTop画面の場合は遷移しない
    if ([self.topViewController isMemberOfClass:[SNBootstrapViewController class]]) return;
    
    // ViewControllerスタックをクリアにする
    [self dismissModalViewControllerAnimated:NO];
    [self popToRootViewControllerAnimated:NO];
}

//- (void)showLogin
//{
//    SNLoginViewController *vc = [[SNLoginViewController alloc] init];
//    [self pushViewController:vc animated:YES];
//    [vc release];
//}

@end
