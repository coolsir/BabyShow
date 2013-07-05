//
//  AppDelegate.m
//  AFNeting2Test
//
//  Created by xb on 13-5-17.
//
//

#import "AppDelegate.h"
#import "ThemaManager.h"
#import "SNRootViewController.h"
#import "MainViewController.h"
#import "AudioManager.h"
#import "SNBootstrapViewController.h"
#import "Flurry.h"
#import <CoreLocation/CoreLocation.h>
@implementation AppDelegate
@synthesize viewController = _viewController;
@synthesize menuController = _menuController;
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{        //setting sound
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:@"YES" forKey:kSoundSetting]];
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //设置主题
    [self setTheme];
    
    
//    _mainCtrl = [[MainViewController alloc] init];
//    UINavigationController *MainNav = [[UINavigationController alloc] initWithRootViewController:_mainCtrl];
//    self.window.rootViewController = MainNav;
//     [_mainCtrl release];
//    [MainNav release];
    
    SNBootstrapViewController *bootstrapVC = [[SNBootstrapViewController alloc] init];
     self.viewController = [[[SNRootViewController alloc] initWithBootstrap] autorelease];
    self.window.rootViewController =  self.viewController;
    RELEASE_SAFELY(bootstrapVC);
    
    
    
    
    //sound init
    AudioSessionInitialize(NULL, NULL, NULL, self);
    UInt32 category = kAudioSessionCategory_AmbientSound;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    AudioSessionSetActive(YES);
    dispatch_async(dispatch_queue_create("jp.animol.sounds", NULL), ^{
        // Audio Setup
        NSArray *sounds = [NSArray arrayWithObjects:kSEGetItem,kSELevelUp, kSEPositive, kSENegative, kSETap, kSEGururu, kSEQwoon, nil];
        [[AudioManager sharedInstance] initSoundWithKeys:sounds];
    });

    [[AudioManager sharedInstance] stopBGM];
    [[AudioManager sharedInstance] playBGMOpShop];
    
    //设置数据分析track   Flurry
    [Flurry startSession:@"J4SW82SVK5JSWFMST7WJ"];
    [Flurry setSessionReportsOnCloseEnabled:NO];
    [Flurry setSessionReportsOnPauseEnabled:NO];
    [Flurry setDebugLogEnabled:YES];
    [Flurry logEvent:@"Start Application"];
    CLLocationManager *locationManager = [[CLLocationManager alloc] init]; [locationManager startUpdatingLocation];
    CLLocation *location = locationManager.location;
    [Flurry setLatitude:location.coordinate.latitude
              longitude:location.coordinate.longitude
              horizontalAccuracy:location.horizontalAccuracy
              verticalAccuracy:location.verticalAccuracy];
    return YES;
}


- (void)setTheme {
   // NSString *themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
    
    [[ThemaManager shareInstance] setThemaName:@"blue"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
