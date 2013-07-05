//
//  CartoonService.m
//  BabyShow
//
//  Created by 刘 麒麟 on 13-7-4.
//
//

#import "CartoonService.h"
static CartoonService * _instance;
@implementation CartoonService



+ (CartoonService *)sharedService
{
    if(_instance == nil)
    {
        NSURL *url = [NSURL URLWithString:kAPIBaseURL];
        _instance = [[CartoonService alloc] initWithBaseURL:url];
    }
    return _instance;
}


@end
