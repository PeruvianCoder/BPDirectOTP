//
//  LogInViewController.m
//  DBS_OTP1
//
//  Created by Luis Velando on 1/5/15.
//  Copyright (c) 2015 Luis Velando. All rights reserved.
//

#import "LogInViewController.h"

@implementation LogInViewController

@synthesize pinTextField, imageView, loginText, logInButton, personalizeLabel;

-(void)viewDidLoad{
    pinTextField.text = @"";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userPin = [defaults objectForKey:@"pin"];
    if(userPin == nil){
        NSString *language = [[NSLocale preferredLanguages]objectAtIndex:0];
        if([language isEqualToString:@"en"]){
            [logInButton setTitle:@"Register New PIN" forState:UIControlStateNormal];
            loginText.text = @"Please register a new pin below.";
        }
        else if ([language isEqualToString:@"es"]){
            [logInButton setTitle:@"Registrar PIN" forState:UIControlStateNormal];
            loginText.text = @"Configure su PIN";
        }
    }
    //[defaults setObject:@"111111" forKey:@"pin"];
    pinTextField.delegate = self;
    imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Images/main_background.jpg"]];
}

-(void)viewDidAppear:(BOOL)animated{
    pinTextField.text = @"";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userPin = [defaults objectForKey:@"pin"];
    if(userPin != nil){
        personalizeLabel.hidden = YES;
        NSString *language = [[NSLocale preferredLanguages]objectAtIndex:0];
        if([language isEqualToString:@"en"]){
            [logInButton setTitle:@"Login" forState:UIControlStateNormal];
            loginText.text = @"Please enter your PIN to login.";
        }
        else if([language isEqualToString:@"es"]){
            [logInButton setTitle:@"Ingresar" forState:UIControlStateNormal];
            loginText.text = @"Por favor ingrese su PIN.";
        }
    }
}

-(IBAction)logInButton:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userPin = [defaults objectForKey:@"pin"];
    NSString *pinEntered = pinTextField.text;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Pin" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    if(![pinEntered isEqualToString:@""]){
        if(userPin == nil && pinEntered.length == 6){
            NSString *language = [[NSLocale preferredLanguages]objectAtIndex:0];
            [defaults setObject:pinEntered forKey:@"pin"];
            if([language isEqualToString:@"en"]){
                [alert setTitle:@"Success!"];
                [alert setMessage:@"User registered successfully. Please Log-In to the Internet Banking to scan your code."];
                [alert show];
            }
            else if ([language isEqualToString:@"es"]){
                [alert setTitle:@"Exito!"];
                [alert setMessage:@"Su registro ha sido satisfactorio. Por favor ingrese a BPDirect para escanear su codigo."];
                [alert show];
            }
            [self performSegueWithIdentifier:@"registerPush" sender:self];
        }
        else if(![userPin isEqualToString:pinEntered]){
            pinTextField.text = @"";
            [alert show];
            return;
        }
        else{
            defaults = [NSUserDefaults standardUserDefaults];
            [self performSegueWithIdentifier:@"homeView" sender:self];
        }
        pinTextField.text = @"";
    }
    else{
        [alert show];
        return;
    }
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    pinTextField = textField;
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return (newString.length<=6);
}

-(IBAction)unwindToLogIn:(UIStoryboardSegue *)unwindSegue{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [pinTextField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view]endEditing:YES];
}
@end
