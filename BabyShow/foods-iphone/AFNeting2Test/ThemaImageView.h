//
//  ThemaImageView.h
//  AFNeting2Test
//
//  Created by xb on 13-5-20.
//
//

#import <UIKit/UIKit.h>

@interface ThemaImageView : UIImageView

//图片名称
@property(nonatomic,copy)NSString *imageName;

@property(nonatomic,assign)int leftCapWidth;
@property(nonatomic,assign)int topCapHeight;

- (id)initWithImageName:(NSString *)imageName;


@end
