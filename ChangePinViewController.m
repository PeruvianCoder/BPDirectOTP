//
//  ChangePinViewController.m
//  DBS_OTP1
//
//  Created by Luis Velando on 12/29/14.
//  Copyright (c) 2014 Luis Velando. All rights reserved.
//

#import "ChangePinViewController.h"

@interface ChangePinViewController ()

@end

@implementation ChangePinViewController

@synthesize oldPinTextField, PinTextField, confirmPinTextField, alertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PinTextField.delegate = self;
    oldPinTextField.delegate = self;
    confirmPinTextField.delegate = self;
    alertView.delegate = self;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelButton:(id)sender{
    [self performSegueWithIdentifier:@"goToHome" sender:self];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [PinTextField resignFirstResponder];
    [oldPinTextField resignFirstResponder];
    [confirmPinTextField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view]endEditing:YES];
}

-(IBAction)changePINButton:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *pin = [defaults objectForKey:@"pin"];
    NSString *oldPin = oldPinTextField.text;
    NSString *newPin = PinTextField.text;
    NSString *confirmPin = confirmPinTextField.text;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid PIN" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    NSString *language = [[NSLocale preferredLanguages]objectAtIndex:0];
    
    if(![pin isEqualToString:oldPin]){
        oldPinTextField.text = @"";
        PinTextField.text = @"";
        confirmPinTextField.text = @"";
        if ([language isEqualToString:@"en"]) {
            [alert show];
        }
        else if([language isEqualToString:@"es"]){
            [alert setMessage:@"PIN Invalido"];
        }
    }
    else if(newPin.length < 6){
        oldPinTextField.text = @"";
        PinTextField.text = @"";
        confirmPinTextField.text = @"";
        if([language isEqualToString:@"en"]){
            [alert setMessage:@"PIN has to be atleast 6 digits long."];
            [alert show];
        }
        else if ([language isEqualToString:@"es"]){
            [alert setMessage:@"PIN tiene que ser 6 digitos."];
            [alert show];
        }
    }
    else if(![newPin isEqualToString:confirmPin]){
        oldPinTextField.text = @"";
        PinTextField.text = @"";
        confirmPinTextField.text = @"";
        if([language isEqualToString:@"en"]){
            [alert setMessage:@"PINs do not match."];
            [alert show];
        }
        else if([language isEqualToString:@"es"]){
            [alert setMessage:@"Los PINs no coinciden."];
            [alert show];
        }
    }
    else{
        alertView = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Changed pin successfully!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:newPin forKey:@"pin"];
        [defaults synchronize];
        [alertView show];
        [self performSegueWithIdentifier:@"pushLogin" sender:self];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    PinTextField = textField;
//    confirmPinTextField = textField;
//    oldPinTextField = textField;
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return (newString.length<=6);
}


@end
