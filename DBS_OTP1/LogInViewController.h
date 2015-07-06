//
//  LogInViewController.h
//  DBS_OTP1
//
//  Created by Luis Velando on 1/5/15.
//  Copyright (c) 2015 Luis Velando. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *pinTextField;

-(IBAction)logInButton:(id)sender;
-(IBAction)unwindToLogIn:(UIStoryboardSegue *)unwindSegue;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *loginText;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UILabel *personalizeLabel;

@end
