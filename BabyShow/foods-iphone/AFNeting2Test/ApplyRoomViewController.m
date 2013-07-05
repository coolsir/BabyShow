//
//  ApplyRoomViewController.m
//  BabyShow
//
//  Created by 刘 麒麟 on 13-6-28.
//
//

#import "ApplyRoomViewController.h"

@interface ApplyRoomViewController ()

@end

@implementation ApplyRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//RoomCode
    UILabel *labRoomCode = [[UILabel alloc] init];
    labRoomCode.text = @"Apply RoomCode :";
    CGSize labelSize = CGSizeZero;
    labelSize = [labRoomCode.text sizeWithFont:labRoomCode.font constrainedToSize:CGSizeMake(320, INT_MAX) lineBreakMode:labRoomCode.lineBreakMode];
    labRoomCode.frame = CGRectMake(40, 80, labelSize.width, labelSize.height);
    [self.view addSubview:labRoomCode];
    [labRoomCode release];
    
    //RoomCodeTextFiled
    UITextField *tfRoomCode = [[UITextField alloc] init];
    
    tfRoomCode.frame = CGRectMake(labRoomCode.origin.x+100, labRoomCode.origin.y, labRoomCode.width, labRoomCode.height);
    
    [self.view addSubview:tfRoomCode];
    [tfRoomCode release];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
