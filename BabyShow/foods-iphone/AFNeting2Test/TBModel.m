//
//  TBModel.m
//  baiduTieba
//
//  Created by xb on 13-5-21.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "TBModel.h"

@implementation TBModel

@synthesize tb_title;
@synthesize tb_brief;
@synthesize tb_comment_count;
@synthesize tb_author;
@synthesize tb_publishtime;


-(id)init{
    
   self = [super init];
    return self;
};


- (void) initWithJSON:(NSDictionary *)order{
        
        self.tb_title = [order objectForKey:@"tb_title"];
        self.tb_brief = [order objectForKey:@"tb_brief"];
        self.tb_comment_count = [order objectForKey:@"tb_comment_count"];
        self.tb_author = [order objectForKey:@"tb_author"];
        self.tb_publishtime = [order objectForKey:@"tb_publishtime"];
};




-(void)dealloc{

    [self.tb_title release];
    [self.tb_brief release];
    [self.tb_author release];
    [self.tb_comment_count release];
    [self.tb_publishtime release];
    [super dealloc];
}


@end
