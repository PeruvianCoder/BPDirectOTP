//
//  ChangePinViewController.h
//  DBS_OTP1
//
//  Created by Luis Velando on 12/29/14.
//  Copyright (c) 2014 Luis Velando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface ChangePinViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate>

-(IBAction)cancelButton:(id)sender;
-(IBAction)changePINButton:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *oldPinTextField;
@property (weak, nonatomic) IBOutlet UITextField *PinTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPinTextField;
@property UIAlertView *alertView;

@end
