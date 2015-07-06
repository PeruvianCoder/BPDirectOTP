//
//  ValidateViewController.m
//  BPDirectOTP
//
//  Created by Luis Velando on 3/23/15.
//  Copyright (c) 2015 Luis Velando. All rights reserved.
//

#import "ValidateViewController.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

@interface ValidateViewController ()

@end

@implementation ValidateViewController
@synthesize qrData, textFieldA,textFieldB, textFieldC, validateFieldA, validateFieldB, validateFieldC, validateTextA, validateTextB, validateTextC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUInteger posi1 = [qrData rangeOfString:@"~"].location;
    NSString *keyt = [qrData substringWithRange:NSMakeRange(posi1 + 1, qrData.length - (posi1 + 1))];
    keyt = [self replaceOTPB:keyt];
    
    NSString *textA = [keyt substringWithRange:NSMakeRange(0, 2 - 0)];
    validateTextA = [keyt substringWithRange:NSMakeRange(2, 4 - 2)];
    NSString *textB = [keyt substringWithRange:NSMakeRange(4, 6-4)];
    validateTextB = [keyt substringWithRange:NSMakeRange(6, 8 - 6)];
    NSString *textC = [keyt substringWithRange:NSMakeRange(8, 10 - 8)];
    validateTextC = [keyt substringWithRange:NSMakeRange(10, keyt.length - 10)];
    
    validateFieldA.delegate = self;
    validateFieldB.delegate = self;
    validateFieldC.delegate = self;
    
    textFieldA.text = textA;
    textFieldB.text = textB;
    textFieldC.text = textC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    NSUInteger posi1 = [qrData rangeOfString:@"~"].location;
    NSString *keyt = [qrData substringWithRange:NSMakeRange(posi1 + 1, qrData.length - (posi1 + 1))];
    keyt = [self replaceOTPB:keyt];
    
    NSString *textA = [keyt substringWithRange:NSMakeRange(0, 2 - 0)];
    validateTextA = [keyt substringWithRange:NSMakeRange(2, 4 - 2)];
    NSString *textB = [keyt substringWithRange:NSMakeRange(4, 6-4)];
    validateTextB = [keyt substringWithRange:NSMakeRange(6, 8 - 6)];
    NSString *textC = [keyt substringWithRange:NSMakeRange(8, 10 - 8)];
    validateTextC = [keyt substringWithRange:NSMakeRange(10, keyt.length - 10)];
    
    textFieldA.text = textA;
    textFieldB.text = textB;
    textFieldC.text = textC;
}

-(IBAction)acceptButton:(id)sender{
    NSString *language = [[NSLocale preferredLanguages]objectAtIndex:0];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"PIN has to be 2 digits." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    if (validateFieldA.text.length < 2 || validateFieldB.text.length < 2 || validateFieldC.text.length < 2) {
        if ([language isEqualToString:@"es"]) {
            [alert setMessage:@"PIN tiene que ser 2 digitos"];
            [alert show];
        }
        else if([language isEqualToString:@"en"]){
            [alert show];
        }
    }
    
    if(![validateTextA isEqualToString:validateFieldA.text] || ![validateTextB isEqualToString:validateFieldB.text] || ![validateTextC isEqualToString:validateFieldC.text]){
        if([language isEqualToString:@"es"]){
            [alert setMessage:@"PIN es invalido"];
            [alert show];
        }
        else if ([language isEqualToString:@"en"]){
            [alert setMessage:@"PIN is invalid"];
            [alert show];
        }
    }
    else{
        NSUInteger posi = [qrData rangeOfString:@"@"].location;
        NSString *userId = [qrData substringWithRange:NSMakeRange(0, posi - 0)];
        NSString *userType = [qrData substringWithRange:NSMakeRange(posi + 1, posi + 2 - (posi + 1))];
        NSString *seed = [qrData substringWithRange:NSMakeRange(posi + 2, qrData.length - (posi + 2))];
        
        userId = [self replaceOTPB:userId];
        seed = [self replaceOTPB:seed];
        
        NSData *data = [seed dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSData *encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:@"password" error:&error];
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc]init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entity];
        NSArray *usersFromDB = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        NSString *userIDFromDB = @"";
        NSString *utypeFromDB = @"";
        
        for(NSManagedObjectContext *data in usersFromDB){
            userIDFromDB = [data valueForKey:@"userid"];
            utypeFromDB = [data valueForKey:@"utype"];
            
            if (![userId isEqualToString:userIDFromDB]) {
                [newObject setValue:userId forKey:@"userid"];
                [newObject setValue:userType forKey:@"utype"];
                [newObject setValue:encryptedData forKey:@"seed"];
                [newObject setValue:[NSDate date] forKey:@"regdate"];
                [context save:&error];
                GenerateOTPViewController *genViewController = [[self storyboard]instantiateViewControllerWithIdentifier:@"generateView"];
                genViewController.encryptedSeedData = encryptedData;
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"User already exists" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }
        [self performSegueWithIdentifier:@"validToHomePush" sender:self];
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(IBAction)cancelButton:(id)sender{
    //where to go?!?!
    [self performSegueWithIdentifier:@"validToHomePush" sender:self];
}

-(NSString *)replaceCharOTPB:(char)keyVALS{
    NSString *rtnValue = @"";
    NSString *keyVal = [NSString stringWithFormat:@"%c", keyVALS];
    
    if([keyVal isEqualToString:@"q"]){
        rtnValue = @"A";
    }
    else if ([keyVal isEqualToString:@"^"]){
        rtnValue = @"B";
    }
    else if([keyVal isEqualToString:@"6"]){
        rtnValue = @"C";
    }
    else if ([keyVal isEqualToString:@"m"]){
        rtnValue = @"D";
    }
    else if([keyVal isEqualToString:@"C"]){
        rtnValue = @"E";
    }
    else if ([keyVal isEqualToString:@"<"]){
        rtnValue = @"F";
    }
    else if([keyVal isEqualToString:@"s"]){
        rtnValue = @"G";
    }
    else if([keyVal isEqualToString:@"6"]){
        rtnValue = @"H";
    }
    else if ([keyVal isEqualToString:@"7"]){
        rtnValue = @"J";
    }
    else if([keyVal isEqualToString:@">"]){
        rtnValue = @"K";
    }
    else if ([keyVal isEqualToString:@"B"]){
        rtnValue = @"L";
    }
    else if([keyVal isEqualToString:@"?"]){
        rtnValue = @"M";
    }
    else if([keyVal isEqualToString:@"d"]){
        rtnValue = @"N";
    }
    else if ([keyVal isEqualToString:@"v"]){
        rtnValue = @"P";
    }
    else if([keyVal isEqualToString:@"$"]){
        rtnValue = @"Q";
    }
    else if ([keyVal isEqualToString:@"9"]){
        rtnValue = @"R";
    }
    else if([keyVal isEqualToString:@"A"]){
        rtnValue = @"S";
    }
    else if([keyVal isEqualToString:@"g"]){
        rtnValue = @"T";
    }
    else if ([keyVal isEqualToString:@"!"]){
        rtnValue = @"U";
    }
    else if([keyVal isEqualToString:@"5"]){
        rtnValue = @"V";
    }
    else if ([keyVal isEqualToString:@"n"]){
        rtnValue = @"W";
    }
    else if([keyVal isEqualToString:@","]){
        rtnValue = @"X";
    }
    else if([keyVal isEqualToString:@"}"]){
        rtnValue = @"Y";
    }
    else if ([keyVal isEqualToString:@")"]){
        rtnValue = @"Z";
    }
    else if([keyVal isEqualToString:@"8"]){
        rtnValue = @"1";
    }
    else if ([keyVal isEqualToString:@"]"]){
        rtnValue = @"2";
    }
    else if([keyVal isEqualToString:@"("]){
        rtnValue = @"3";
    }
    else if([keyVal isEqualToString:@"{"]){
        rtnValue = @"4";
    }
    else if ([keyVal isEqualToString:@"["]){
        rtnValue = @"5";
    }
    else if([keyVal isEqualToString:@"*"]){
        rtnValue = @"6";
    }
    else if ([keyVal isEqualToString:@"|"]){
        rtnValue = @"7";
    }
    else if([keyVal isEqualToString:@"P"]){
        rtnValue = @"8";
    }
    else if([keyVal isEqualToString:@"k"]){
        rtnValue = @"9";
    }
    else if ([keyVal isEqualToString:@"1"]){
        rtnValue = @"0";
    }
    else{
        rtnValue = keyVal;
    }
    return rtnValue;
}

-(NSString *)replaceOTPB:(NSString *)keyVAL{
    NSString *rtnValue = @"";
    for(int i = 0; i < keyVAL.length; i++){
        rtnValue = [NSString stringWithFormat:@"%@%@", rtnValue, [self replaceCharOTPB:[keyVAL characterAtIndex:i] ]];
    }
    return rtnValue;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [[self view]endEditing:YES];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return (newString.length<=2);
}

@end
