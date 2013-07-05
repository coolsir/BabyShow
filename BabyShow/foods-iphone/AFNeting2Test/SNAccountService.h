//
//  SNAccountService.h
//  BabyShow
//
//  Created by 刘 麒麟 on 13-6-27.
//
//

#import "SNServiceBase.h"

@interface SNAccountService : SNServiceBase<UIAlertViewDelegate>


+ (SNAccountService *)sharedService;
+ (SNAccountService *)sharedSecureService;



/**
 * 启动时处理
 */
- (void)bootstrap;

/**
 * 登录
 */
- (void)registerDevice;
- (void)showRetryRegisterDeviceAlert;

/**
 * 检查更新
 */
- (void)checkUpdates;
@end
