//
//  Video.h
//  Foods
//
//  Created by 刘 麒麟 on 13-6-14.
//
//

#import <Foundation/Foundation.h>

@interface Video : NSObject


@property(strong,nonatomic) NSString* videoName;
@property(strong,nonatomic) NSString* videoCategory;
@property(strong,nonatomic) NSString* grade;
@property(strong,nonatomic) NSString* starNum;
@property(strong,nonatomic) NSString* videoUrl;
@property(strong,nonatomic) NSString* videoThumbUrl;
@property(strong,nonatomic) NSString* videoArea;
@property(strong,nonatomic) NSString* videoType;



- (void) initWithJSON:(NSDictionary *)order;
@end
