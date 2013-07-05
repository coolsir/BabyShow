//
//  StoryService.h
//  Foods
//
//  Created by 刘 麒麟 on 13-6-19.
//
//

#import "SNServiceBase.h"

@interface StoryService : SNServiceBase
+ (StoryService *)sharedService;

//-----------------------------------------------------------------------
//1 根据pageNum查找Storys
- (BOOL)findStorysByPageId:(NSString*)category
               pageNum:(NSString*)pageNum
              pageSize:(NSString*)pageSize
               success:(void (^)(id JSON))success
               failure:(void (^)(NSDictionary *error))failure;
@end
