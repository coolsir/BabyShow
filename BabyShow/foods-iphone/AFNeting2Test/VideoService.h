//
//  VideoService.h
//  Foods
//
//  Created by 刘 麒麟 on 13-6-14.
//
//

#import "SNServiceBase.h"

@interface VideoService : SNServiceBase

+ (VideoService *)sharedService;

//-----------------------------------------------------------------------
//1 根据pageNum查找Videos
- (BOOL)findTBByPageId:(NSString*)category
               pageNum:(NSString*)pageNum
              pageSize:(NSString*)pageSize
                success:(void (^)(id JSON))success
                failure:(void (^)(NSDictionary *error))failure;

@end
