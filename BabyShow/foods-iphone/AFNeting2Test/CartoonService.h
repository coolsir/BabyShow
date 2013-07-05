//
//  CartoonService.h
//  BabyShow
//
//  Created by 刘 麒麟 on 13-7-4.
//
//

#import "SNServiceBase.h"

@interface CartoonService : SNServiceBase

+ (CartoonService *)sharedService;
+ (CartoonService *)sharedSecureService;
@end
