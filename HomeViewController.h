//
//  HomeViewController.h
//  DBS_OTP1
//
//  Created by Luis Velando on 12/29/14.
//  Copyright (c) 2014 Luis Velando. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GenerateOTPViewController.h"

@interface HomeViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property NSInteger *userIndex;
@property NSMutableArray *userList;
@property (weak, nonatomic) IBOutlet UIPickerView *userPickerList;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property NSArray *users;
@property NSMutableArray *usersText;
@property NSString *pickerText;
@property NSString *userIDPassed;
@property NSData *seedPassed;
@property NSString *utypePassed;
@property NSMutableArray *tempObjects;

@property NSArray *seeds;
@property NSArray *utypes;
@property NSArray *userids;

-(IBAction)generateOTP:(id)sender;
-(IBAction)registerOTPButton:(id)sender;
-(IBAction)changePin:(id)sender;
-(IBAction)logOut:(id)sender;

-(IBAction)unwindToHomeController:(UIStoryboardSegue *)unwindSegue;

-(void)selectPickerRow;

@end
