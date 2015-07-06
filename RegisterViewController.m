//
//  RegisterViewController.m
//  DBS_OTP1
//
//  Created by Luis Velando on 12/29/14.
//  Copyright (c) 2014 Luis Velando. All rights reserved.
//

#import "RegisterViewController.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize videoPreviewLayer, viewPreview, alertView, hardCodeSeed, hardCodeUserId, hardCodeUType, passShowFieldA, passShowFieldB, passShowFieldC, passValidFieldA, passValidFieldB, passValidFieldC, passQRData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
    _captureSession = nil;
    _isReading = NO;
    alertView.delegate = self;

    HomeViewController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"blahBlah"];
    UIView *view = homeView.view;
    
//        hardCodeUType = @"1";
//        hardCodeSeed = @"8[^(kkk<(]8<<681*81]**mC6k{[kCq6|^^[Ck|6";
//        hardCodeUserId = @"6mC?O.OvC9qmO9";
//    
//        hardCodeUserId = [self replaceOTPB:hardCodeUserId];
//        hardCodeSeed = [self replaceOTPB:hardCodeSeed];
//    
//        NSData *data = [hardCodeSeed dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *error;
//        NSData *encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:@"password" error:&error];
//    
//        NSManagedObjectContext *context = [self managedObjectContext];
//        NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
//        [newObject setValue:hardCodeUserId forKey:@"userid"];
//        [newObject setValue:encryptedData forKey:@"seed"];
//        [newObject setValue:hardCodeUType forKey:@"utype"];
//    [self stopReading];

}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
    HomeViewController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"blahBlah"];
    UIView *view = homeView.view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)scanCodeButton:(id)sender{
    if(!_isReading){
        [self startReading];
    }
    else{
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Scanner is already running!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    _isReading = !_isReading;
}

-(BOOL)startReading{
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if(!input){
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    _captureSession = [[AVCaptureSession alloc]init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc]init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_captureSession];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [videoPreviewLayer setFrame:viewPreview.layer.bounds];
    [viewPreview.layer addSublayer:videoPreviewLayer];
    
    
    [_captureSession startRunning];
    //_isReading = YES;
    return YES;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if(metadataObjects != nil && [metadataObjects count]>0){
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]){
            NSString *qrData = [metadataObj stringValue];
            passQRData = qrData;
            
//            NSUInteger posi = [qrData rangeOfString:@"@"].location;
//            NSString *userId = [qrData substringWithRange:NSMakeRange(0, posi - 0)];
//            NSString *userType = [qrData substringWithRange:NSMakeRange(posi + 1, posi + 2 - (posi + 1))];
//            NSString *seed = [qrData substringWithRange:NSMakeRange(posi + 2, qrData.length - (posi + 2))];
//            
//            userId = [self replaceOTPB:userId];
//            seed = [self replaceOTPB:seed];
//            
//            NSData *data = [seed dataUsingEncoding:NSUTF8StringEncoding];
//            NSError *error;
//            NSData *encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:@"password" error:&error];
//            
//            NSManagedObjectContext *context = [self managedObjectContext];
//            NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
//
//            NSFetchRequest *request = [[NSFetchRequest alloc]init];
//            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:self.managedObjectContext];
//            [request setEntity:entity];
//            NSArray *usersFromDB = [self.managedObjectContext executeFetchRequest:request error:&error];
//
//            NSString *userIDFromDB = @"";
//            NSString *utypeFromDB = @"";
//            
//            for(NSManagedObjectContext *data in usersFromDB){
//                userIDFromDB = [data valueForKey:@"userid"];
//                utypeFromDB = [data valueForKey:@"utype"];
//                
//                if (![userId isEqualToString:userIDFromDB]) {
//                    [newObject setValue:userId forKey:@"userid"];
//                    [newObject setValue:userType forKey:@"utype"];
//                    [newObject setValue:encryptedData forKey:@"seed"];
//                    [newObject setValue:[NSDate date] forKey:@"regdate"];
//                    
//                    GenerateOTPViewController *genViewController = [[self storyboard]instantiateViewControllerWithIdentifier:@"generateView"];
//                    genViewController.encryptedSeedData = encryptedData;
//                }
//            }
            
            if(qrData.length > 0){
                [self stopReading];
            }
            
            _isReading = NO;
        }
    }
}

-(void)showAlert{
    alertView = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"New User Registered! Please hit cancel to go back." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView setTitle:@"Success!"];
    [alertView setMessage:@"New User Registered! Please press ok to go back."];
    [alertView show];
}

-(void)stopReading{
    [_captureSession stopRunning];
    [videoPreviewLayer removeFromSuperlayer];
    videoPreviewLayer = nil;
    _captureSession = nil;
    
//    NSData *data = [hardCodeSeed dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error;
//    NSData *encryptedData = [RNEncryptor encryptData:data withSettings:kRNCryptorAES256Settings password:@"password" error:&error];
//    
//    NSManagedObjectContext *context = [self managedObjectContext];
//    NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
//    [newObject setValue:@"6mC?O.OvC9qz13" forKey:@"userid"];
//    [newObject setValue:encryptedData forKey:@"seed"];
//    [newObject setValue:@"2" forKey:@"utype"];
    
    [self performSegueWithIdentifier:@"validatePush" sender:self];
}


-(IBAction)cancelButton:(id)sender{
    [self performSegueWithIdentifier:@"homePush" sender:self];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self performSegueWithIdentifier:@"homePush" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"homePush"]){
        HomeViewController *home = segue.destinationViewController;
    }
    if([[segue identifier] isEqualToString:@"validatePush"]){
        //todo pass qrData values to validViewController
        ValidateViewController *validVC = segue.destinationViewController;
        validVC.qrData = passQRData;
    }
}

@end
