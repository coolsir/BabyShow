//
//  AppDelegate.h
//  AFNeting2Test
//
//  Created by xb on 13-5-17.
//
//

#import <UIKit/UIKit.h>
@class SNRootViewController;
@class MainViewController;
#import "DDMenuController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)MainViewController *mainCtrl;
@property (strong, nonatomic) SNRootViewController *viewController;
@property (strong, nonatomic) DDMenuController *menuController;

+ (AppDelegate *)appDelegate;
@end
