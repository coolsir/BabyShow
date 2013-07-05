//
//  SNRootViewController.h
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//

@interface SNRootViewController : UINavigationController

- (id)initWithBootstrap;

+ (SNRootViewController *)currentViewController;

@property (nonatomic, assign) BOOL alreadyAccessedMyRoom;

/**
 * アカウント登録画面を表示する
 */
- (void)showRegistration;

/**
 * マイルームを表示する
 */
- (void)showMyRoom;

/**
 * トップ画面を表示する
 */
- (void)showTop;

/**
 * アカウント移行ログイン画面を表示する
 */
- (void)showLogin;

@end
