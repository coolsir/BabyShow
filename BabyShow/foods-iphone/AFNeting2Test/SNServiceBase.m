//
//  SNServiceBase.m
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//

#import "SNServiceBase.h"
#import "Reachability.h"
#import "SNAlertManager.h"
#import "SVProgressHUD.h"
#import "SNDevice.h"



@implementation SNServiceBase

@synthesize testMode;
@synthesize isReLogin;


//----------------封装的很到位（如果任何一个网络请求请求失败都会跳到开始引导界面）
- (BOOL)call:(NSString *)path 
  parameters:(NSDictionary *)parameters
     success:(void (^)(id JSON))success 
     failure:(void (^)(NSDictionary *error))failure 
{
    LOG(@"API[%@]", path);
    
    // 判断网络是否可用
    if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        // 网络不可用
        LOG(@" -- Not Reachable");
        return NO;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    //--------------------------------------------------------------------------
    // Set common params
    //--------------------------------------------------------------------------
   
   
   
    
    NSMutableURLRequest *req = [super requestWithMethod:kAPIMethod 
                                                   path:path parameters:params];
    
    //--------------------------------------------------------------------------
    if(self.testMode)
    {
#ifdef AFHTTPClient_Testable
        // Testモード時は同期リクエストとする
        LOG(@"Executing requests in ** TEST MODE **");
        [AFHTTPClientTest testHTTPOperationWithRequest:req success:^(id JSON) 
        {
            if(JSON && [@"OK" isEqualToString:[JSON objectForKey:CONST_STATUS_RESPONSE]]) {
                // OK
                success(JSON);
            } else {
                // NG
                NSDictionary *error = (NSDictionary *)[JSON objectForKey:CONST_ERROR_LIST_RESPONSE];
                failure(error);
            }
        }
                                               failure:^(NSHTTPURLResponse *response, NSError *error)
        {
            LOG(@"HTTP Error[%d] : %@", [response statusCode], error);
            failure(nil);
        }];
#endif
    } 
    else
    {
        // 通常時は同期リクエストとする
        [self enqueueHTTPOperationWithRequest:req 
                                      success:^(id JSON)
        {
            LOG(@"Response [%@] : %@", path, JSON);
            NSString *status = [JSON objectForKey:CONST_STATUS_RESPONSE];
            
            // 我要检查是否有必要显示系统消息
          //  [self handleMessageResponse:JSON];
            
            if(JSON && [@"OK" isEqualToString:status]) 
            {
                // OK
                success(JSON);
                
                
            }
            else if (JSON && [@"TMPLOCKED" isEqualToString:status]) 
            {
                // TMPLOCKED : 一時停止アカウント
               // [[SNRootViewController currentViewController] showTop];
                [[SNAlertManager sharedInstance] showTitle:NSLocalizedString(@"このアカウントは\n一時的に利用できません", @"") 
                                                   message:nil];
            } 
            else if (JSON && [@"FORBIDDEN" isEqualToString:status])
            {
                // FORBIDDEN : 利用停止アカウント
               // [[SNRootViewController currentViewController] showTop];
                [[SNAlertManager sharedInstance] showTitle:NSLocalizedString(@"このアカウントは\n利用できません", @"") 
                                                   message:nil];
            } 
            else if (JSON && [@"MAINTENANCE" isEqualToString:status])
            {
               // [[SNRootViewController currentViewController] showTop];
                [SVProgressHUD dismiss];
            }
            else if (JSON && [@"SESSION_EXPIRED" isEqualToString:status])
            {
                /*
                if (self.isReLogin == NO) {
                    // 前回のログインキャッシュをクリアにする
                    self.isReLogin = YES;
                   // [[SNAccount currentAccount] logout];
                   // [[SNAccount currentAccount] clearLastLoginCache];
                    // SESSION_EXPIRED : セッション切れ
                    [[SNRootViewController currentViewController] showTop];
                    // 再度ログインする
                    [[SNAccountService sharedSecureService] login];
                    
                    [SVProgressHUD dismiss];
                    //[[SNAlertManager sharedInstance] showTitle:NSLocalizedString(@"セッションが無効です。操作をやり直して下さい。", @"") message:nil];
                    LOG(@" **** Session is invalid");
                }
                 */
            } else {
                // NG
                NSDictionary *error = (NSDictionary *)[JSON objectForKey:CONST_ERROR_LIST_RESPONSE];
                failure(error);
            }
        }failure:^(NSHTTPURLResponse *response, NSError *err)
        {
            LOG(@"HTTP Error[%d] : %@", [response statusCode], err);
            
            if ([err code] == NSURLErrorSecureConnectionFailed || 
                [err code] == NSURLErrorServerCertificateHasBadDate || 
                [err code] == NSURLErrorServerCertificateUntrusted ||
                [err code] == NSURLErrorServerCertificateHasUnknownRoot ||
                [err code] == NSURLErrorServerCertificateNotYetValid) 
            {
                [[SNAlertManager sharedInstance] showTitle:[err localizedDescription] message:nil];
                return;
            }
            
            NSDictionary *error = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:[err code]], @"code",
                                   [[err userInfo] description], @"description",
                                   nil];
            failure(error);
        }];
    }
    return YES;
}

- (void)handleMessageResponse:(NSDictionary *)JSON
{
    NSDictionary *message = [JSON objectForKey:@"message"];
    if (message == nil) return;
    
    NSString *readId = [message objectForKey:@"readId"];
    
    NSString *title = [message objectForKey:@"title"];
    NSString *desc = [message objectForKey:@"desc"];
    NSString *button1 = [message objectForKey:@"button1"];
    NSString *button2 = [message objectForKey:@"button2"];
    
    if ([readId length] == 0 || [title length] == 0 || [button1 length] == 0) {
        return;
    }
    
    NSString *urlString = [message objectForKey:@"url"];
    NSURL *url = nil;
    //kaiqing account transfer animol-app://
    if([urlString hasPrefix:@"http://"] || [urlString hasPrefix:@"https://"] || [urlString hasPrefix:@"animol-api://"]) {
        url = [NSURL URLWithString:urlString];
    }
    
    if ([button2 length] == 0)
    {
        [[SNAlertManager sharedInstance] showTitle:title 
                                           message:desc 
                                            button:button1 
                                               url:url];
    }
    else 
    {
        [[SNAlertManager sharedInstance] showTitle:title 
                                           message:desc 
                                            cancel:button1
                                            button:button2 
                                               url:url];
    }
    
    // 今回のIDで既読状態を記録する
    [[NSUserDefaults standardUserDefaults] setObject:readId forKey:@"LastMessageReadId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*- (void)checkReward:(SNReward *)reward
{
    // クエスト報酬通知 & 期間限定ボーナス報酬通知
    [SNRewardViewController showQuestRewardIfNeeded:reward];
}*/
@end
