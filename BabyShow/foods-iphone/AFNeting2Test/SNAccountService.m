//
//  SNAccountService.m
//  BabyShow
//
//  Created by 刘 麒麟 on 13-6-27.
//
//


#import "SNAccountService.h"
#import "SNDevice.h"
#import "SNAlertManager.h"
#import "SNRootViewController.h"

static SNAccountService *_instance;
static SNAccountService *_secureInstance;

@implementation SNAccountService


+ (SNAccountService *)sharedService
{
    if(_instance == nil)
    {
        NSURL *url = [NSURL URLWithString:kAPIBaseURL];
        _instance = [[SNAccountService alloc] initWithBaseURL:url];
    }
    return _instance;
}

+ (SNAccountService *)sharedSecureService
{
    if(_secureInstance == nil)
    {
        NSURL *url = [NSURL URLWithString:kAPISecureURL];
        _secureInstance = [[SNAccountService alloc] initWithBaseURL:url];
    }
    return _secureInstance;
}

//------------------------------------------------------------------------------
- (void)bootstrap
{
    if([SNDevice uniqueIdentifier] == nil)
    {
        // 端末未登録
        [self registerDevice];
    }
    else
    {
        // 端末登録済み
        LOG(@"[OK] Device already registered");
        //7.1 从网络更新下载数据包
        [self checkUpdates];
        return;
    }
}

#pragma mark -checkUpdates;

- (void)checkUpdates{

    LOG(@"Checking updates .......");
    NSString *version = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleVersion"];
    NSDictionary *param = [NSDictionary dictionaryWithObject:version forKey:@"version"];
    BOOL connected = [self call:@"updates.json"
                     parameters:param
                        success:^(id JSON)
                      {
                          // 更新通知情報の取得成功
                          // AppDriver設定があるかどうか
                          /*liuqiling 此处使用flurry（设置同appdriver  故保持不变）
                          BOOL appDriverEnabled = [[JSON objectForKey:@"appDriver"] boolValue];
                          [SNAnimoBankViewController setAppDriverEnabled:appDriverEnabled];
                          if (appDriverEnabled) {
                              // リワード広告を初期化する
                              [[SNAppDelegate appDelegate] setupAdNetworks];
                          }
                          */
                          
                         //---------------------------------------------------------------------
                           // 強制アップデートがあるかどうか
                          NSString *forceUpdateURL = [JSON objectForKey:@"forceUpdateURL"];
                          if(forceUpdateURL && [forceUpdateURL hasPrefix:@"http"]) {
                              // トップ画面に遷移する
                              [[SNRootViewController currentViewController] showTop];
                              // アップデート通知ダイアログを表示する
                              [[SNAlertManager sharedInstance] showTitle:@"Update"
                                                                 message:@"Latest......."
                                                                  button: @"Upgrading"
                                                                     url:[NSURL URLWithString:forceUpdateURL]];
                              return;
                          }
                          
                          
                          
                          // 更新情報を取得したことを通知する
                          NSNotification *notif = [NSNotification notificationWithName:kSNAccountServiceCheckUpdates
                                                                                object:nil
                                                                              userInfo:JSON];
                          [[NSNotificationCenter defaultCenter] postNotification:notif];
                      }
                        failure:^(NSDictionary *error)
                      {
                          // 更新通知情報の取得失敗
                          NSInteger errorCode = [[error objectForKey:@"code"] intValue];
                          
                          // エラーメッセージを作成する
                          //kaiqing fix variable never read
                          //         NSString *errorMessage = [NSString stringWithFormat:@"ErrorCode:%d, desc:%@", errorCode, error];
                          
                          if(errorCode > 299
                             || errorCode == NSURLErrorCannotConnectToHost
                             || errorCode == NSURLErrorTimedOut
                             || errorCode == NSURLErrorCannotFindHost 
                             || errorCode == NSURLErrorNetworkConnectionLost
                             || errorCode == NSURLErrorNotConnectedToInternet) 
                          {
                              // トップ画面に遷移する
                              [[SNRootViewController currentViewController] showTop];
                              // エラーダイアログを表示する
                              [SNAlertManager showTitle:@"Error"
                                                message:nil
                                           cancelButton:@"cancel"
                                            otherButton:nil
                                                handler:nil];
                          }
                          else 
                          {
                              // エラーダイアログを表示する
                              [SNAlertManager showTitle:@"Error"
                                                message:@"server can't be connected!"
                                           cancelButton:@"cancel"
                                            otherButton:nil
                                                handler:nil];
                              
                          }
                          // 更新情報を取得できなかったことを通知する
                          NSNotification *notif = [NSNotification notificationWithName:kSNAccountServiceCouldNotCheckUpdates 
                                                                                object:nil 
                                                                              userInfo:nil];
                          [[NSNotificationCenter defaultCenter] postNotification:notif];
                      }];
    
    if(connected == NO) {
        // インターネット未接続の場合
        // トップ画面に遷移する
        [[SNRootViewController currentViewController] showTop];
        // エラーダイアログを表示する
        [[SNAlertManager sharedInstance] showTitle:@"plase connected server "                                           message:nil];
    }
    


};




//------------------------------------------------------------------------------
#pragma mark - RegisterDevice API

- (void)registerDevice
{
    LOG(@"Registering this device ...");
    BOOL connected = [self call:@"registerDevice.json" parameters:nil success:^(id JSON)
                      {
                          //
                          // デバイス登録成功
                          //
                          LOG(@"Device Registered : %@", JSON);
                          
                          NSDictionary *account = (NSDictionary *)[JSON objectForKey:@"account"];
                          
                          NSString *auid = (NSString *)[account objectForKey:@"auid"];
                          [SNDevice setUniqueIdentifier:auid];
                          LOG(@" AUID registration completed : %@", auid);
                          
                          NSString *adsecret = (NSString *)[account objectForKey:@"adsecret"];
                          [SNDevice setSecret:adsecret];
                          LOG(@" Animol device secret was saved : %@", adsecret);
                          
                          // 手机key设置成功后.... 此时手机端与客户端的key对应
                          [[SNAccountService sharedService] bootstrap];
                      }
                        failure:^(NSDictionary *error)
                      {
                          //
                          // デバイス登録失敗
                          //
                          LOG(@"Server error description : %@", error);
                          [[SNAccountService sharedService] showRetryRegisterDeviceAlert];
                      }];
    
            if(connected == NO) {
                    // インターネット未接続の場合
                [[SNAlertManager sharedInstance] showTitle:@"register failure"
                                                   message:nil];
            }
}

//------------------------------------------------------------------------------
#pragma mark - AlertView delegate
#define REGISTER_DEVICE_FAILED 1000

- (void)showRetryRegisterDeviceAlert
{
    UIAlertView *alert = [[UIAlertView alloc]
                                            initWithTitle:@"Device registration failed"
                                             message:@"please check your network,or try again later"
                                             delegate:self
                                          cancelButtonTitle:@"retry"
                                          otherButtonTitles:nil];
    alert.tag = REGISTER_DEVICE_FAILED;
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == REGISTER_DEVICE_FAILED)
    {
        [self registerDevice];
    }
}



@end
