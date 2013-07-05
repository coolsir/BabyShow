//
//  ThemaManager.h
//  AFNeting2Test
//
//  Created by xb on 13-5-20.
//
//

#import <Foundation/Foundation.h>

#define kThemeDidChangeNofication @"kThemeDidChangeNofication"

@interface ThemaManager : NSObject

//当前使用的主题
@property(nonatomic,retain)NSString *themaName;
//配置主题的plist文件
@property(nonatomic,retain)NSDictionary *themasPlist;
//Label字体颜色配置plist文件
@property(nonatomic,retain)NSDictionary *fontColorPlist;


+ (ThemaManager *)shareInstance;

//返回当前主题下的图片
- (UIImage *)getThemaImage:(NSString *)imageName;

//返回当前主题下字体的颜色
- (UIColor *)getColorWithName:(NSString *)name;



@end
