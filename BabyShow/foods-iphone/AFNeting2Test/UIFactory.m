//
//  UIFactory.m
//  AFNeting2Test
//
//  Created by xb on 13-5-20.
//
//

#import "UIFactory.h"

@implementation UIFactory

+ (ThemaButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName {
    ThemaButton *button = [[ThemaButton alloc] initWithImage:imageName highlighted:highlightedName];
    return [button autorelease];
}

+ (ThemaButton *)createButtonWithBackground:(NSString *)backgroundImageName
                      backgroundHighlighted:(NSString *)highlightedName {
    ThemaButton *button = [[ThemaButton alloc] initWithBackground:backgroundImageName highlightedBackground:highlightedName];
    return [button autorelease];
}

+ (ThemaImageView *)createImageView:(NSString *)imageName {
    ThemaImageView *themeImage = [[ThemaImageView alloc] initWithImageName:imageName];
    return [themeImage autorelease];
}

+ (ThemaLabel *)createLabel:(NSString *)colorName {
    ThemaLabel *themeLabel = [[ThemaLabel alloc] initWithColorName:colorName];
    return [themeLabel autorelease];
}


@end
