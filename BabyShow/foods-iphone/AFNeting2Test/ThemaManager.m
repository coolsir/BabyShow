//
//  ThemaManager.m
//  AFNeting2Test
//
//  Created by xb on 13-5-20.
//
//

#import "ThemaManager.h"
static ThemaManager *sigleton = nil;
@implementation ThemaManager




- (id)init{

    self = [super init];
    if (self) {
        //读取主题配置文件
        NSString *themaPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.themasPlist =  [NSDictionary dictionaryWithContentsOfFile:themaPath];
        //默认为空
        self.themaName = nil;
    }

    return  self;

}




+ (ThemaManager *)shareInstance{

    if (sigleton == nil) {
        @synchronized(self){
        sigleton = [[ThemaManager alloc] init];
        }
    }
    return sigleton;
};

//返回当前主题下的图片
- (UIImage *)getThemaImage:(NSString *)imageName{

    if (imageName.length == 0) {
        return nil;
    }
    
    //获取主题目录
    NSString *themePath = [self getThemaPath];
    //imageName在当前主题的路径
    NSString *imagePath = [themePath stringByAppendingPathComponent:imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
    
};

//返回当前主题下字体的颜色
- (UIColor *)getColorWithName:(NSString *)name{

    if (name.length == 0) {
        return nil;
    }
    //返回三色值，如：24,35,60
    NSString *rgb = [_fontColorPlist objectForKey:name];
    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    if (rgbs.count == 3) {
        float r = [rgbs[0] floatValue];
        float g = [rgbs[1] floatValue];
        float b = [rgbs[2] floatValue];
        UIColor *color = Color(r, g, b, 1);
        return color;
    }
    
    return nil;
};

//切换主题时，调用此方法设置主题名称
- (void)setThemaName:(NSString *)themaName{

    if (_themaName != themaName) {
        [_themaName release];
        _themaName = [themaName copy];
    }
//切换主题，重新加载当前主题下的字体配置文件
    NSString *themaDir = [self getThemaPath];
    NSString *filePath = [themaDir stringByAppendingPathComponent:@"fontColor.plist"];
    self.fontColorPlist = [NSDictionary dictionaryWithContentsOfFile:filePath];
}



//获取主题目录
-  (NSString *)getThemaPath{

    if (self.themaName == nil) {
        //如果主题名为空，则使用项目包根目录下的默认主题图片
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        return resourcePath;
    }
    
    //获取主题目录，如Skins/blue
    NSString *themaPath = [self.themasPlist valueForKey:_themaName];
    //程序包的根目录
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    //包的完整目录
    NSString *path = [resourcePath stringByAppendingPathComponent:themaPath];

    return path;
}


@end
