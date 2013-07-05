//
//  TBService.m
//  baiduTieba
//
//  Created by xb on 13-5-22.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "TBService.h"
static TBService *_instance;
@implementation TBService


+ (TBService *)sharedService
{
    if(_instance == nil)
    {
        NSURL *url = [NSURL URLWithString:kAPIBaseURL];
        _instance = [[TBService alloc] initWithBaseURL:url];
    }
    return _instance;
}



- (BOOL)findTBByPageId:(NSString *)pageId
               success:(void (^)(id JSON))success
               failure:(void (^)(NSDictionary *error))failure{

    LOG(@"getTB list ...");
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   pageId, pageId,
                                   nil];
    
    return [self call:@"login.json"
              parameters:params
              success:success
              failure:failure];

};


@end
