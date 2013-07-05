//
//  SNAlertManager.m
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//

#import "SNAlertManager.h"
#import "SNDevice.h"
static NSMutableSet *_instances;
static SNAlertManager *_instance;


#define kSNAlertManagerItemDialog       1000
#define kSNAlertManagerSpecialItemDialog    1001
#define kSNAlertManagerAnimoBankDialog  1500
#define kSNAlertManagerPtBankDialog     1600
#define kSNAlertManagerOpenURLDialog    2000
#define kSNAlertManagerBabymolGrowAnimoBankDialog   2400

#define kFreeDiskSpaceLimit 200.0f
#define kAlertFreeDiskSpace 500
#define kURLPrefsUsage  [NSURL URLWithString:@"prefs:root=General&path=USAGE"]

@implementation SNAlertManager

@synthesize rootViewController = _rootViewController;
@synthesize url = _url;
@synthesize handler = _handler;

+ (SNAlertManager *)sharedInstance
{
    if(_instance == nil) 
    {
        _instance = [[SNAlertManager alloc] init];
    }
    return _instance;
}

+ (void)showTitle:(NSString *)title 
          message:(NSString *)message 
     cancelButton:(NSString *)cancelButton 
      otherButton:(NSString *)otherButton
          handler:(void(^)(UIAlertView *alertView, NSUInteger buttonIndex))handler
{
    SNAlertManager *manager = [[[SNAlertManager alloc] init] autorelease];
    manager.handler = handler;
    
    if (_instances == nil) {
        _instances = [[NSMutableSet alloc] init];
    }
    [_instances addObject:manager];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
                                                    message:message 
                                                   delegate:manager 
                                          cancelButtonTitle:cancelButton 
                                          otherButtonTitles:otherButton, nil];
    [alert show];
    [alert release];
}

+ (void)showTitle:(NSString *)title
          message:(NSString *)message
     cancelButton:(NSString *)cancelButton
      firstButton:(NSString *)firstButton
     secondButton:(NSString *)secondButton
          handler:(void(^)(UIAlertView *alertView, NSUInteger buttonIndex))handler
{
    SNAlertManager *manager = [[[SNAlertManager alloc] init] autorelease];
    manager.handler = handler;
    
    if (_instances == nil) {
        _instances = [[NSMutableSet alloc] init];
    }
    [_instances addObject:manager];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:manager
                                          cancelButtonTitle:cancelButton
                                          otherButtonTitles:firstButton, secondButton, nil];
    [alert show];
    [alert release];
}

- (void)showTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message 
                                                   delegate:nil 
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)showTitle:(NSString *)title message:(NSString *)message button:(NSString *)button url:(NSURL *)url
{
    self.url = url;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message 
                                                   delegate:self 
                                          cancelButtonTitle:button
                                          otherButtonTitles:nil];
    if(url) {
        alert.tag = kSNAlertManagerOpenURLDialog;
    }
    [alert show];
    [alert release];
}

- (void)showTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel button:(NSString *)button url:(NSURL *)url
{
    self.url = url;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message 
                                                   delegate:self 
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:button, nil];
    if(url) {
        alert.tag = kSNAlertManagerOpenURLDialog;
    }
    [alert show];
    [alert release];
}

- (void)showAnimoBankMediationForViewController:(UIViewController *)viewController
{
    self.rootViewController = viewController;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"animoが足りません", @"Shortage of animo. ShopDetail")
                                                    message:NSLocalizedString(@"animoを購入しますか？", @"Get animo : message") 
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"いいえ", @"No")
                                          otherButtonTitles:NSLocalizedString(@"はい", @"Yes"), nil];
    alert.tag = kSNAlertManagerAnimoBankDialog;
    [alert show];
    [alert release];
}

- (void)showBabymolGrowAnimoBankMediationForViewController:(UIViewController *)viewController
{
    self.rootViewController = viewController;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"animoが不足しております", @"Not enough animo")
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"購入", @"Buy")
                                          otherButtonTitles:nil];
    alert.tag = kSNAlertManagerBabymolGrowAnimoBankDialog;
    [alert show];
    [alert release];
}

- (void)showPtBankMediationForViewController:(UIViewController *)viewController
{
    self.rootViewController = viewController;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ptが足りません", @"Shortage of pt. ShopDetail")
                                                    message:NSLocalizedString(@"ptを購入しますか？", @"Get pt : message") 
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"いいえ", @"No")
                                          otherButtonTitles:NSLocalizedString(@"はい", @"Yes"), nil];
    alert.tag = kSNAlertManagerPtBankDialog;
    [alert show];
    [alert release];
}
- (void)showShopMediationTitle:(NSString *)title 
                       message:(NSString *)message
            rootViewController:(UIViewController *)rootViewController
                   specialItem:(BOOL)specialItem
{
    self.rootViewController = rootViewController;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message 
                                                   delegate:self 
                                          cancelButtonTitle:NSLocalizedString(@"閉じる", @"")
                                          otherButtonTitles:NSLocalizedString(@"増やす", @""), nil];
    if (specialItem) {
        alert.tag = kSNAlertManagerSpecialItemDialog;
    }
    else {
        alert.tag = kSNAlertManagerItemDialog;
    }
    [alert show];
    [alert release];
}

//------------------------------------------------------------------------------
- (BOOL)showAlertIfNoFreeDiskSpace
{
    float freespace = (([SNDevice getFreeDiskspace]/1024.0f)/1024.0f);
    if(freespace < kFreeDiskSpaceLimit) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"データを保存できません", @"")
                                                        message:NSLocalizedString(@"データを保存するのに十分な空き容量がありません。ストレージは 設定 で管理できます。", @"") 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"完了", @"")
                                              otherButtonTitles:NSLocalizedString(@"設定", @""), nil];
        alert.tag = kAlertFreeDiskSpace;
        [alert show];
        [alert release];
        return YES;
    } else {
        return NO;
    }
}

//------------------------------------------------------------------------------
#pragma mark - イベントクリアヘルプ
- (void)showEventClearTreasureHelpIfNeeded
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ShownEventClearTreasureHelp"] == NO) 
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShownEventClearTreasureHelp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showTitle:NSLocalizedString(@"お宝アイテムを探そう", @"Event help title for Treasure Item")
                message:NSLocalizedString(@"クリアに必要なお宝アイテムの\nエリアを調べてお宝アイテムを\nゲットしよう", @"Event help desc for Treasure Item")];
    }
}

- (void)showEventClearItemHelpIfNeeded
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ShownEventClearItemHelp"] == NO) 
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShownEventClearItemHelp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showTitle:NSLocalizedString(@"アイテムを買おう", @"Event help title for Shop Item")
                message:NSLocalizedString(@"クリアに必要なアイテムを\nショップで購入しよう", @"Event help desc for Shop Item")];
    }
}

- (void)showEventGachaItemHelpIfNeeded
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ShownEventGachaItemHelp"] == NO) 
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShownEventGachaItemHelp"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self showTitle:NSLocalizedString(@"アイテムを入手しよう", @"Event help title for Gacha Item")
                message:NSLocalizedString(@"クリアに必要なアイテムを\nガチャで入手しよう", @"Event help desc for Gacha Item")];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertFreeDiskSpace && alertView.cancelButtonIndex != buttonIndex)
    {
        [[UIApplication sharedApplication] openURL:kURLPrefsUsage];
    }
    else if(alertView.tag == kSNAlertManagerOpenURLDialog) 
    {
        [[UIApplication sharedApplication] openURL:self.url];
        self.url = nil;
    }
    else
    {
        if(self.handler) self.handler(alertView, buttonIndex);
        alertView.delegate = nil;
        [_instances removeObject:self];
    }
}

@end
