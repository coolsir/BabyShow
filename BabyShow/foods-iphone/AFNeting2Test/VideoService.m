//
//  VideoService.m
//  Foods
//
//  Created by 刘 麒麟 on 13-6-14.
//
//

#import "VideoService.h"
static VideoService *_instance;
@implementation VideoService



+ (VideoService *)sharedService
{
    if(_instance == nil)
    {
        NSURL *url = [NSURL URLWithString:kAPIBaseURL];
        _instance = [[VideoService alloc] initWithBaseURL:url];
    }
    return _instance;
}


- (BOOL)findTBByPageId:(NSString*)category
               pageNum:(NSString*)pageNum
              pageSize:(NSString*)pageSize
               success:(void (^)(id JSON))success
               failure:(void (^)(NSDictionary *error))failure{

    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   category,@"category", 
                                   pageNum,@"pageNumber",
                                   pageSize,@"pageSize",
                                   nil];
    
    return [self call:@"findVideos.json"
           parameters:params
              success:success
              failure:failure];


};

@end
