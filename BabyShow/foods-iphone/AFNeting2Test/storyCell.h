//
//  storyCell.h
//  Foods
//
//  Created by 刘 麒麟 on 13-6-19.
//
//

#import "PSCollectionViewCell.h"

@interface storyCell : PSCollectionViewCell
{
    UILabel *_sytitle;
    UIImageView *_syimg;
    UILabel *_sybrief;
    UILabel *_sytime;
}
@property (nonatomic, copy) NSString *sysimgurl;
- (void)initSubViews;
@end
