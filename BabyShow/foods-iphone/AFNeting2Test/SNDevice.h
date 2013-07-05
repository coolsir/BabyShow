//
//  SNDevice.h
//  Animol
//
//  Copyright (c) 2011 Sammy NetWorks Co., Ltd. All rights reserved.
//



@interface SNDevice : NSObject

+ (NSString *)lang;

+ (void)setUniqueIdentifier:(NSString *)auid;
+ (NSString *)uniqueIdentifier;

+ (void)setSecret:(NSString *)adsecret;
+ (NSString *)secret;

+ (float)getFreeDiskspace;
+ (NSString *)deviceType;

@end
