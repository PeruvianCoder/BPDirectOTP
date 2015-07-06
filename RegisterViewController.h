//
//  RegisterViewController.h
//  DBS_OTP1
//
//  Created by Carlos Grijalva on 12/29/14.
//  Copyright (c) 2014 Luis Velando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>
#import "GenerateOTPViewController.h"
#import "HomeViewController.h"
#import "ValidateViewController.h"

@interface RegisterViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (nonatomic , strong) AVCaptureSession *captureSession;
@property (nonatomic , strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL isReading;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property UIAlertView *alertView;

-(IBAction)cancelButton:(id)sender;
-(IBAction)scanCodeButton:(id)sender;
-(BOOL)startReading;
-(void)stopReading;

-(NSString *)replaceOTPB:(NSString *)keyVAL;
-(NSString *)replaceCharOTPB:(char)keyVALS;

@property NSString *hardCodeUserId;
@property NSString *hardCodeSeed;
@property NSString *hardCodeUType;
@property NSString *passShowFieldA;
@property NSString *passShowFieldB;
@property NSString *passShowFieldC;
@property NSString *passValidFieldA;
@property NSString *passValidFieldB;
@property NSString *passValidFieldC;

@property NSString *passQRData;

@end
