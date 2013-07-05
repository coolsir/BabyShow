//
//  ThemaLabel.m
//  AFNeting2Test
//
//  Created by xb on 13-5-20.
//
//

#import "ThemaLabel.h"
#import "ThemaManager.h"
@implementation ThemaLabel

- (void)dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_colorName release];
}

- (id)init {
    self = [super init];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNofication object:nil];
    }
    return self;
}

- (id)initWithColorName:(NSString *)colorName {
    self = [self init];
    if (self != nil) {
        self.colorName = colorName;
    }
    return self;
}

- (void)setColorName:(NSString *)colorName {
    if (_colorName != colorName) {
        [_colorName release];
        _colorName = [colorName copy];
    }
    
    [self setColor];
}

- (void)setColor {
    UIColor *textColor = [[ThemaManager shareInstance] getColorWithName:_colorName];
    self.textColor = textColor;
}

#pragma mark - NSNotification actions
- (void)themeNotification:(NSNotification *)notification {
    [self setColor];
}

@end