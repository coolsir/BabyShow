//
//  SNBootstrapViewController.m
//  BabyShow
//
//  Created by 刘 麒麟 on 13-6-26.
//
//

#import "SNBootstrapViewController.h"
#import "SNAccountService.h"
#import "ApplyRoomViewController.h"
#import "UpdateManager.h"
#import "SNRootViewController.h"
#import "VideosViewController.h"
#import "HomeViewController.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
@interface SNBootstrapViewController ()

@end

@implementation SNBootstrapViewController
@synthesize progressView;
@synthesize labelTitle;
@synthesize startupImageView;
@synthesize animolLogoImageView;
@synthesize topBgImageView = _topBgImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
       self = [super initWithNibName:@"SNBootstrapViewController" bundle:nil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 更新検知を登録する
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkUpdates:)
                                                 name:kSNAccountServiceCheckUpdates
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkUpdatesFailed)
                                                 name:kSNAccountServiceCouldNotCheckUpdates
                                               object:nil];
    
    
    
    self.startupImageView.hidden = NO;
    self.startupImageView.alpha = 1.0f;
    self.animolLogoImageView.hidden = NO;
    self.animolLogoImageView.alpha = 1.0f;
    self.topBgImageView.hidden = NO;
    self.topBgImageView.alpha = 1.0f;
    
    [self performSelector:@selector(closeStartupImage) withObject:nil afterDelay:1.0f];
    [self performSelector:@selector(start) withObject:nil afterDelay:4.0f];
}


- (void)start
{
    // アカウント初期処理
    [[SNAccountService sharedService] bootstrap];
    
    /*//申请房间
    ApplyRoomViewController *applyRoomVC = [[ApplyRoomViewController alloc] init];
    [self presentViewController:applyRoomVC animated:YES completion:nil];*/
}


#pragma mark - アカウント初期処理
- (void)closeStartupImage
{
    // SammyNetwork
    [UIView animateWithDuration:1.0f animations:^{
        self.startupImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.startupImageView.hidden = YES;
        [self performSelector:@selector(closeLogoImage) withObject:nil afterDelay:2.0f];
    }];
}

- (void)closeLogoImage
{
    // animol logo
    [UIView animateWithDuration:1.0f animations:^{
        self.animolLogoImageView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.animolLogoImageView.hidden = YES;
    }];
}


//------------------------------------------------------------------------------
#pragma mark - Check updates
- (void)checkUpdates:(NSNotification *)notif
{
    NSDictionary *JSON = [notif userInfo];
    
    // 更新が必要な場合、リソースを取得し上書きする
    NSString *animolResourceId  = [JSON objectForKey:@"animolResourceId"];
    NSString *animolResourceURL = [JSON objectForKey:@"animolResourceURL"];
    [[UpdateManager defaultManager] addUpdateResourceWithName: @"Update Resource"
                                                          key:@"resource_animol"
                                                   identifier:animolResourceId
                                                          url:animolResourceURL];
    
    NSString *itemResourceId  = [JSON objectForKey:@"itemResourceId"];
    NSString *itemResourceURL = [JSON objectForKey:@"itemResourceURL"];
    [[UpdateManager defaultManager] addUpdateResourceWithName: @"Update Resource"
                                                          key:@"resource_item"
                                                   identifier:itemResourceId
                                                          url:itemResourceURL];
    
    NSString *areaResourceId  = [JSON objectForKey:@"areaResourceId"];
    NSString *areaResourceURL = [JSON objectForKey:@"areaResourceURL"];
    [[UpdateManager defaultManager] addUpdateResourceWithName:@"Update Resource"
                                                          key:@"resource_area"
                                                   identifier:areaResourceId
                                                          url:areaResourceURL];
    
    NSString *worldResourceId  = [JSON objectForKey:@"worldResourceId"];
    NSString *worldResourceURL = [JSON objectForKey:@"worldResourceURL"];
    [[UpdateManager defaultManager] addUpdateResourceWithName:@"Update Resource"
                                                          key:@"resource_world"
                                                   identifier:worldResourceId
                                                          url:worldResourceURL];
    
    if ([[UpdateManager defaultManager] needsUpdate])
    {
        // トップ画面に遷移する
        [[SNRootViewController currentViewController] showTop];
        
        // インストール中は自動ロック機能をオフにする
        [UIApplication sharedApplication].idleTimerDisabled = YES;
        
        //　アップデート処理実行
        [[UpdateManager defaultManager] startUpdatingOnProgress:^ (UpdateResource *resource)
         {
             LOG(@"Update progress : %@ %f", resource.name, resource.progress);
             NSString *msg = nil;
             if (resource.states == UpdateStatesDownloadProgress) {
                 msg = [NSString stringWithFormat:@"ResourceName:\n%@(%@/%d) %d%%",
                        resource.name, resource.number, [UpdateManager defaultManager].totalUpdatesCount,
                        (int)ceilf(resource.progress * 100.0f)];
             } else if (resource.states == UpdateStatesInstallProgress) {
                 msg = [NSString stringWithFormat:NSLocalizedString(@"%@を初期設定中... %d%%", @""),
                        resource.name, (int)ceilf(resource.progress * 100.0f)];
             }
             self.labelTitle.text = msg;
             self.progressView.progress = resource.progress;
         }
                                                     allUpdated:^
         {
             LOG(@"Update completed");
             self.labelTitle.text =  @"update complete!";
             self.progressView.progress = 1.0f;
             
             // インストール完了後は自動ロック機能をオンにする
             [UIApplication sharedApplication].idleTimerDisabled = NO;
             
             // 下载完毕后进入视频播放界面
            // [[SNAccountService sharedSecureService] login];
             //VideosViewController *videoVC =  [[VideosViewController alloc] init];
           
             HomeViewController  *homeVC = [[HomeViewController alloc] init];
             UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
             DDMenuController *DMune = [[DDMenuController alloc] initWithRootViewController:nav];
             [AppDelegate  appDelegate].menuController = DMune;
             LeftViewController *leftController = [[LeftViewController alloc] init];
             DMune.leftViewController = leftController;
             [self.navigationController presentViewController:DMune animated:YES completion:nil];
             
         }];
    }
    else
    {
        // アップデート不要、続けてログインする
       // [[SNAccountService sharedSecureService] login];
    }
}

- (void)checkUpdatesFailed
{
    self.labelTitle.text = NSLocalizedString(@"更新情報を取得できませんでした", @"");
}





@end
