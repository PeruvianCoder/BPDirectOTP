//
//  GenerateOTPViewController.h
//  DBS_OTP1
//
//  Created by Luis Velando on 1/2/15.
//  Copyright (c) 2015 Luis Velando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TOTPGenerator.h"
#import "MF_Base32Additions.h"
#import "GTMStringEncoding.h"
#import "NSData+Base64.h"

@interface GenerateOTPViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *otpLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property NSString *userID;
@property NSData *seed;
@property NSString *utype;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property NSArray *userData;
@property (nonatomic) float progressValue;
@property (nonatomic, strong)NSTimer *timer;
@property NSTimer *idleTimer;
@property NSData *encryptedSeedData;
@property TOTPGenerator *generator;
@property BOOL flag;
@property long timestamp;
@property NSString *theTimeStamp;

-(IBAction)cancelButton:(id)sender;
-(IBAction)generateOTP:(id)sender;
-(void)timerIncrease:(NSTimer *)timer;
-(void)timeOut;

@end
