//
//  SNAlertManager.h
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//


typedef void(^AlertHandlerBlock)(UIAlertView *alertView, NSUInteger buttonIndex);


@interface SNAlertManager : NSObject <UIAlertViewDelegate>

@property (nonatomic, copy) AlertHandlerBlock handler;

@property (nonatomic, assign) UIViewController *rootViewController;
@property (nonatomic, copy) NSURL *url;

+ (SNAlertManager *)sharedInstance;

+ (void)showTitle:(NSString *)title 
          message:(NSString *)message 
     cancelButton:(NSString *)cancelButton 
      otherButton:(NSString *)otherButton
          handler:(void(^)(UIAlertView *alertView, NSUInteger buttonIndex))handler;

+ (void)showTitle:(NSString *)title
          message:(NSString *)message
     cancelButton:(NSString *)cancelButton
      firstButton:(NSString *)firstButton
     secondButton:(NSString *)secondButton
         handler:(void(^)(UIAlertView *alertView, NSUInteger buttonIndex))handler;

- (void)showTitle:(NSString *)title message:(NSString *)message;
- (void)showTitle:(NSString *)title message:(NSString *)message button:(NSString *)button url:(NSURL *)url;
- (void)showTitle:(NSString *)title message:(NSString *)message cancel:(NSString *)cancel button:(NSString *)button url:(NSURL *)url;
- (BOOL)showAlertIfNoFreeDiskSpace;

- (void)showAnimoBankMediationForViewController:(UIViewController *)viewController;
- (void)showPtBankMediationForViewController:(UIViewController *)viewController;
- (void)showBabymolGrowAnimoBankMediationForViewController:(UIViewController *)viewController;

- (void)showShopMediationTitle:(NSString *)title 
                       message:(NSString *)message
            rootViewController:(UIViewController *)rootViewController
                   specialItem:(BOOL)specialItem;

- (void)showEventClearTreasureHelpIfNeeded;
- (void)showEventClearItemHelpIfNeeded;
- (void)showEventGachaItemHelpIfNeeded;

@end
