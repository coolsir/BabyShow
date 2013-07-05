//
//  storyCell.m
//  Foods
//
//  Created by 刘 麒麟 on 13-6-19.
//
//

#import "storyCell.h"
#import "Video.h"
#import "UIImageView+AFNetworking.h"
#define MARGIN 4.0

@implementation storyCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //titleLabel
        _sytitle = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        _sytitle.font = [UIFont boldSystemFontOfSize:14.0];
        _sytitle.numberOfLines = 0;
        [self addSubview:_sytitle];
        //image
        _syimg = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_syimg];
        //brief
        _sybrief = [[UILabel alloc] initWithFrame:CGRectZero];
         _sybrief.textColor = [UIColor darkGrayColor];
        _sybrief.font = [UIFont systemFontOfSize:12.0];
        _sybrief.numberOfLines = 0;
        [self addSubview:_sybrief];
        //
        _sytime = [[UILabel alloc] initWithFrame:CGRectZero] ;
        _sytime.font = [UIFont systemFontOfSize:13.0];
        _sytime.textColor = [UIColor grayColor];
        _sytime.numberOfLines = 0;
        [self addSubview:_sytime];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    CGFloat width = self.frame.size.width - MARGIN * 2;
    CGFloat top = MARGIN;
    CGFloat left = MARGIN;
    
    // Image
    CGFloat objectWidth = [[self.object objectForKey:@"syImgWidth"] floatValue];
    CGFloat objectHeight = [[self.object objectForKey:@"syImgHeight"] floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    
    // Label
    CGSize labelSize = CGSizeZero;
    labelSize = [_sytitle.text sizeWithFont:_sytitle.font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:_sytitle.lineBreakMode];
    _sytitle.frame = CGRectMake(left, top, labelSize.width, labelSize.height);
    //img
    top = _sytitle.frame.origin.y + _sytitle.frame.size.height + MARGIN;
    _syimg.frame = CGRectMake(left, top, width, scaledHeight);
    [_syimg setImageWithURL:[NSURL URLWithString:self.sysimgurl]
            placeholderImage:[UIImage imageNamed:@"page_image_loading.png"]];
    //brief
    top = _syimg.frame.origin.y + _syimg.frame.size.height + MARGIN;
    CGSize labelSize1 = CGSizeZero;
    labelSize1 = [_sybrief.text sizeWithFont:_sybrief.font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:_sytitle.lineBreakMode];
    _sybrief.frame = CGRectMake(left, top, labelSize1.width, labelSize1.height);
    
    //time
    top = _sybrief.frame.origin.y + _sybrief.frame.size.height + MARGIN;
    CGSize labelSize2 = CGSizeZero;
    labelSize2 = [_sytime.text sizeWithFont:_sytime.font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:_sytime.lineBreakMode];
    _sytime.frame = CGRectMake(left, top, labelSize2.width, labelSize2.height);
   
    
}


+ (CGFloat)rowHeightForObject:(id)object inColumnWidth:(CGFloat)columnWidth{
    
    CGFloat height = 0.0;
    CGFloat width = columnWidth - MARGIN * 2;
    
    height += MARGIN;
    
    // Image
    CGFloat objectWidth = [[object objectForKey:@"syImgWidth"] floatValue];
    CGFloat objectHeight = [[object objectForKey:@"syImgHeight"] floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    height += scaledHeight;
    
    // name
    NSString *caption = [object objectForKey:@"syName"];
    CGSize labelSize = CGSizeZero;
    UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
    labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    height += labelSize.height;
    
    // brief
    NSString *caption1 = [object objectForKey:@"syBrief"];
    CGSize labelSize1 = CGSizeZero;
    UIFont *labelFont1 = [UIFont boldSystemFontOfSize:14.0];
    labelSize1 = [caption1 sizeWithFont:labelFont1 constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    height += labelSize1.height;
    // time
    NSString *caption2 = [object objectForKey:@"syTime"];
    CGSize labelSize2 = CGSizeZero;
    UIFont *labelFont2 = [UIFont boldSystemFontOfSize:14.0];
    labelSize2 = [caption2 sizeWithFont:labelFont2 constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    height += labelSize2.height;
    
    height += MARGIN;
    
    return height;

};

- (void)collectionView:(PSCollectionView *)collectionView  fillCellWithObject:(id)object atIndex:(NSInteger)index {
    
        [super collectionView:collectionView fillCellWithObject:object atIndex:index];
     
        _sytitle.text = [object objectForKey:@"syName"];
        self.sysimgurl = [object objectForKey:@"syThumbUrl"];
        _sybrief.text = [object objectForKey:@"syBrief"];
        _sytime.text = [object objectForKey:@"syTime"];
    
}




@end
