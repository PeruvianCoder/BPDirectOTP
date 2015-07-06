//
//  ValidateViewController.h
//  BPDirectOTP
//
//  Created by Luis Velando on 3/23/15.
//  Copyright (c) 2015 Luis Velando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GenerateOTPViewController.h"

@interface ValidateViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *validateFieldA;
@property (weak, nonatomic) IBOutlet UITextField *validateFieldB;
@property (weak, nonatomic) IBOutlet UITextField *validateFieldC;

@property (weak, nonatomic) IBOutlet UILabel *textFieldA;
@property (weak, nonatomic) IBOutlet UILabel *textFieldB;
@property (weak, nonatomic) IBOutlet UILabel *textFieldC;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property NSString *qrData;
@property NSString *validateTextA;
@property NSString *validateTextB;
@property NSString *validateTextC;

-(IBAction)acceptButton:(id)sender;
-(IBAction)cancelButton:(id)sender;

-(NSString *)replaceOTPB:(NSString *)keyVAL;
-(NSString *)replaceCharOTPB:(char)keyVALS;

@end
