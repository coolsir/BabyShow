
//
//  StoryService.m
//  Foods
//
//  Created by 刘 麒麟 on 13-6-19.
//
//

#import "StoryService.h"
static StoryService *_instance;
@implementation StoryService


+ (StoryService *)sharedService
{
    if(_instance == nil)
    {
        NSURL *url = [NSURL URLWithString:kAPIBaseURL];
        _instance = [[StoryService alloc] initWithBaseURL:url];
    }
    return _instance;
}

- (BOOL)findStorysByPageId:(NSString*)category
                   pageNum:(NSString*)pageNum
                  pageSize:(NSString*)pageSize
                   success:(void (^)(id JSON))success
                   failure:(void (^)(NSDictionary *error))failure{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   category,@"category",
                                   pageNum,@"pageNumber",
                                   pageSize,@"pageSize",
                                   nil];
    
    return [self call:@"findStorys.json"
           parameters:params
              success:success
              failure:failure];

};


@end
