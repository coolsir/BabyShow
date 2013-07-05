//
//  Video.m
//  Foods
//
//  Created by 刘 麒麟 on 13-6-14.
//
//

#import "Video.h"

@implementation Video

-(id)init{
    
    self = [super init];
    return self;
};

- (void) initWithJSON:(NSDictionary *)video{
    if (self) {
        self.videoName = [video objectForKey:@"videoName"];
        self.videoCategory = [video objectForKey:@"videoCategory"];
        self.grade = [video objectForKey:@"grade"];
        self.starNum = [video objectForKey:@"starNum"];
        self.videoUrl = [video objectForKey:@"videoUrl"];
        self.videoThumbUrl = [video objectForKey:@"videoThumbUrl"];
        self.videoArea = [video objectForKey:@"videoArea"];
        self.videoType = [video objectForKey:@"videoType"];
    }
  
};

- (void)dealloc
{
    [self.videoType release];
    [self.videoName release];
    [self.videoCategory release];
    [self.videoThumbUrl release];
    [self.videoArea  release];
    [self.starNum release];
    [self.grade release];
    [self.videoUrl release];
    [super dealloc];
}
@end
