//
//  SNConstants.h
//  AFNeting2Test
//
//  Created by xb on 13-5-17.
//
//
#pragma 常用函数

#define LOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define imagePath(path,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:type]]


#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define RELEASE_SAFELY(__POINTER) { if(__POINTER){[__POINTER release]; __POINTER = nil; }}


#pragma 常用变量

#define kAPIMethod      @"GET"
#define CONST_STATUS_RESPONSE                   @"status"
#define CONST_ERROR_LIST_RESPONSE               @"error"
#define CONST_ERROR_CODE_RESPONSE               @"code"
#define CONST_ERROR_MESSAGE_RESPONSE            @"detail"
#define kAPIBaseURL                     @"http://192.168.14.8:9000"
#define kAPISecureURL                    @"http://192.168.14.8:9000"

//-----------------------------------


#define kNavigationBarTitleLabel @"kNavigationBarTitleLabel"
#define kThemeListLabel          @"kThemeListLabel"
#define kThemeName               @"kThemeName"
#define kSoundSetting            @"soundSwitchValue"
#define kSEGetItem      @"se_getitem"
#define kSELevelUp      @"se_levelup"
#define kSEPositive     @"se_positive"
#define kSENegative     @"se_negative"
#define kSETap          @"se_tap"
#define kSEGururu       @"se_gururu"
#define kSEQwoon        @"se_qwoon"


#define SNImageCacheDirectoryName       @"sn_animol_images"



//notification name
#define kSNAccountServiceCheckUpdates       @"kSNAccountServiceCheckUpdates"
#define kSNAccountServiceCouldNotCheckUpdates @"kSNAccountServiceCouldNotCheckUpdates"
#pragma 常用Ui变量


//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define kNavibarTintColor [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:1.0f]







