//
//  SNServiceBase.h
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//

#import "AFHTTPClient.h"

@interface SNServiceBase : AFHTTPClient

@property (nonatomic, assign) BOOL testMode;
@property (nonatomic, assign) BOOL isReLogin;

- (void)request:(NSString *)path 
     parameters:(NSDictionary *)parameters
        success:(void (^)(id object))success 
        failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;

- (BOOL)call:(NSString *)path 
  parameters:(NSDictionary *)parameters
     success:(void (^)(id JSON))success 
     failure:(void (^)(NSDictionary *error))failure;

- (void)handleMessageResponse:(NSDictionary *)JSON;

@end
