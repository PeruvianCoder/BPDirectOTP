//
//  GenerateOTPViewController.m
//  DBS_OTP1
//
//  Created by Luis Velando on 1/2/15.
//  Copyright (c) 2015 Luis Velando. All rights reserved.
//

#import "GenerateOTPViewController.h"
#import "RNDecryptor.h"

@interface GenerateOTPViewController ()

@end

#define kMaxIdleTimeSeconds 60.0

@implementation GenerateOTPViewController

@synthesize userLabel, otpLabel, progressView, userData, userID, seed, utype, progressValue, timer, idleTimer, encryptedSeedData, generator, flag, timestamp, theTimeStamp;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *userIDFromDB = userID;
    flag = YES;
    [progressView setProgress:0];
    if([utype isEqualToString:@"1"]){
        NSUInteger posi = [userIDFromDB rangeOfString:@"."].location;
        NSString *corpUser = [userIDFromDB substringWithRange:NSMakeRange(0, posi)];
        NSString *personalUser = [userIDFromDB substringWithRange:NSMakeRange(posi + 1, userID.length - (posi + 1))];
        
        userIDFromDB = [NSString stringWithFormat:@"Emp: %@ ** %@ - %@ ** %@", [corpUser substringToIndex:2], [corpUser substringWithRange:NSMakeRange(corpUser.length - 2, corpUser.length - (corpUser.length - 2))], [personalUser substringToIndex:2], [personalUser substringWithRange:NSMakeRange(personalUser.length - 2, personalUser.length - (personalUser.length - 2))]];
        userLabel.text = userIDFromDB;
    }
    else{
        userIDFromDB = [NSString stringWithFormat:@"Per: %@ ** %@", [userIDFromDB substringToIndex:2], [userIDFromDB substringWithRange:NSMakeRange(userID.length -2, userID.length - (userID.length - 2))]];
        userLabel.text = userIDFromDB;
    }
    [self updateUI];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
}

-(void)updateUI{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"EST"];
    [dateFormatter setTimeZone:timeZone];
    
    timestamp = (long)[now timeIntervalSince1970];
    if(timestamp % 60 != 0){
        timestamp -= timestamp % 60;
    }
    theTimeStamp = [NSString stringWithFormat:@"%ld", timestamp];
    [self generatePIN];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)generatePIN{
    //[progressView setProgress:0];
    
    NSError *error;
    NSData *decryptedData = [RNDecryptor decryptData:seed withPassword:@"password" error:&error];
    NSString *decryptedSeed = [[NSString alloc]initWithData:decryptedData encoding:8];
    NSData *secretData = [decryptedSeed stringToHexData];    
    NSLog(@"secretData : %@", secretData);
    
    NSTimeInterval time = [theTimeStamp integerValue];
    
    generator = [[TOTPGenerator alloc]initWithSecret:secretData algorithm:kOTPGeneratorSHA512Algorithm digits:8 period:60];
    otpLabel.text = [generator generateOTPForDate:[NSDate dateWithTimeIntervalSince1970:time]];
    
    int count;
    count++;
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:time];
    
    timestamp = (long)[now timeIntervalSince1970];
    NSTimeInterval past = abs([now timeIntervalSinceNow]);
    NSLog(@"past: %f", past);
    NSLog(@"what is this: %f", past/60.0f);
    progressView.progress = past/60.0f;
}

-(void)timerIncrease:(NSTimer *)timer{
    NSLog(@"How many times do i get called?");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Time Expired. Please press the generate button to receive a new OTP." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    static int count = 0;
    count++;
    if(count<=60 && self.timer.valid){
        progressView.progress = (float)count/60.0f;
    }
    else{
        [self.timer invalidate];
        self.timer = nil;
        otpLabel.text = @"";
        //[alert show];
        [progressView setProgress:0];
        count = 0;
    }
}

-(void)cancelButton:(id)sender{
    [self.timer invalidate];
    
    self.timer = nil;
    [progressView setProgress:0];
    progressView.progress = 0;
    flag = NO;
}

-(void)timeOut{
    
}

-(void)resetIdleTimer{
    if(!idleTimer){
        idleTimer = [NSTimer scheduledTimerWithTimeInterval:kMaxIdleTimeSeconds target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    }
    else{
        if(fabs([idleTimer.fireDate timeIntervalSinceNow]) < kMaxIdleTimeSeconds - 1.0){
            [idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMaxIdleTimeSeconds]];
        }
    }
}

-(void)idleTimerExceeded{
    idleTimer = nil;
    [self resetIdleTimer];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"We detected inactivity, you have been logged out." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


@end
