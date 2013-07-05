//
//  TBService.h
//  baiduTieba
//
//  Created by xb on 13-5-22.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNServiceBase.h"
@interface TBService : SNServiceBase <UIAlertViewDelegate>

+ (TBService *)sharedService;

//------------------------------------------------------------------------------
- (BOOL)findTBByPageId:(NSString*)pageId
                          success:(void (^)(id JSON))success
                          failure:(void (^)(NSDictionary *error))failure;
@end
