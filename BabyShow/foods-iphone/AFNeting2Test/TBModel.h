//
//  TBModel.h
//  baiduTieba
//
//  Created by xb on 13-5-21.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBModel : NSObject

@property(nonatomic,strong) NSString *tb_title;
@property(nonatomic,strong) NSString *tb_brief;
@property(nonatomic,assign) NSString *tb_comment_count;
@property(nonatomic,strong) NSString *tb_author;
@property(nonatomic,strong) NSString *tb_publishtime;

- (void) initWithJSON:(NSDictionary *)order;
@end
