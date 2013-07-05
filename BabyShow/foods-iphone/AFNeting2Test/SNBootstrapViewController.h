//
//  SNBootstrapViewController.h
//  BabyShow
//
//  Created by 刘 麒麟 on 13-6-26.
//
//

#import <UIKit/UIKit.h>
#import "DDMenuController.h"
@interface SNBootstrapViewController : UIViewController

@property(nonatomic,strong ) IBOutlet UIProgressView *progressView;

@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UIImageView *startupImageView;
@property (nonatomic, retain) IBOutlet UIImageView *animolLogoImageView;
@property (retain, nonatomic) IBOutlet UIImageView *topBgImageView;




@end
