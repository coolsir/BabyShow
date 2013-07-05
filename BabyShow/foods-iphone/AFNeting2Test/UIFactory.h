//
//  UIFactory.h
//  AFNeting2Test
//
//  Created by xb on 13-5-20.
//
//

#import <Foundation/Foundation.h>
#import "ThemaButton.h"
#import "ThemaImageView.h"
#import "ThemaLabel.h"

@interface UIFactory : NSObject

//创建button
+ (ThemaButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName;
+ (ThemaButton *)createButtonWithBackground:(NSString *)backgroundImageName
                      backgroundHighlighted:(NSString *)highlightedName;

//创建ImageView
+ (ThemaImageView *)createImageView:(NSString *)imageName;

//创建Label
+ (ThemaLabel *)createLabel:(NSString *)colorName;


@end
