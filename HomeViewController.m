//
//  HomeViewController.m
//  DBS_OTP1
//
//  Created by Luis Velando on 12/29/14.
//  Copyright (c) 2014 Luis Velando. All rights reserved.
//

#import "HomeViewController.h"

@implementation HomeViewController

@synthesize userList, userIndex, users, userPickerList, managedObjectContext, pickerText, usersText, userIDPassed, seedPassed, utypePassed, tempObjects, seeds, userids, utypes;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
    usersText = [[NSMutableArray alloc]init];
    userPickerList.delegate = self;
    userPickerList.dataSource = self;
    tempObjects = [[NSMutableArray alloc]init];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:self.managedObjectContext];
    NSError *error;
    [request setEntity:entity];
    users = [self.managedObjectContext executeFetchRequest:request error:&error];
    NSString *userID = [users valueForKey:@"userid"];
    NSString *utype = [users valueForKey:@"utype"];
    NSString *seed = [users valueForKey:@"seed"];
    
    seeds = [users valueForKey:@"seed"];
    utypes = [users valueForKey:@"utype"];
    userids = [users valueForKey:@"userid"];
    
    for(NSManagedObjectContext *data in users){
        userID = [data valueForKey:@"userid"];
        utype = [data valueForKey:@"utype"];
        seed = [data valueForKey:@"seed"];
        //NSLog(@"userid after loop : %@", userID);
        
        if(users != nil && users.count > 0){
            userPickerList.hidden = NO;
            if([utype isEqualToString:@"1"]){
                NSUInteger posi = [userID rangeOfString:@"."].location;
                NSString *corpUser = [userID substringWithRange:NSMakeRange(0, posi)];
                NSString *personalUser = [userID substringWithRange:NSMakeRange(posi + 1, userID.length - (posi + 1))];
                
                pickerText = [NSString stringWithFormat:@"Emp: %@ ** %@ - %@ ** %@", [corpUser substringToIndex:2], [corpUser substringWithRange:NSMakeRange(corpUser.length - 2, corpUser.length - (corpUser.length - 2))], [personalUser substringToIndex:2], [personalUser substringWithRange:NSMakeRange(personalUser.length - 2, personalUser.length - (personalUser.length - 2))]];
                
                if (![tempObjects containsObject:userID]) {
                    [usersText addObject:pickerText];
                    [tempObjects addObject:userID];
                }
            }
            else{
                pickerText = [NSString stringWithFormat:@"Per: %@ ** %@", [userID substringToIndex:2], [userID substringWithRange:NSMakeRange(userID.length -2, userID.length - (userID.length - 2))]];
                
                if (![tempObjects containsObject:userID]) {
                    [usersText addObject:pickerText];
                    [tempObjects addObject:userID];
                }
            }
            
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = YES;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:self.managedObjectContext];
    NSError *error;
    [request setEntity:entity];
    users = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    
    NSString *userID = @"";
    NSString *utype = @"";
    NSData *seed;
    
    seeds = [users valueForKey:@"seed"];
    utypes = [users valueForKey:@"utype"];
    userids = [users valueForKey:@"userid"];
    for(NSManagedObjectContext *data in users){
        userID = [data valueForKey:@"userid"];
        utype = [data valueForKey:@"utype"];
        seed = [data valueForKey:@"seed"];
        
        if(users != nil && users.count > 0){
            userPickerList.hidden = NO;
            if([utype isEqualToString:@"1"]){
                NSUInteger posi = [userID rangeOfString:@"."].location;
                NSString *corpUser = [userID substringWithRange:NSMakeRange(0, posi)];
                NSString *personalUser = [userID substringWithRange:NSMakeRange(posi + 1, userID.length - (posi + 1))];
                
                pickerText = [NSString stringWithFormat:@"Emp: %@ ** %@ - %@ ** %@", [corpUser substringToIndex:2], [corpUser substringWithRange:NSMakeRange(corpUser.length - 2, corpUser.length - (corpUser.length - 2))], [personalUser substringToIndex:2], [personalUser substringWithRange:NSMakeRange(personalUser.length - 2, personalUser.length - (personalUser.length - 2))]];
                
                if (![tempObjects containsObject:userID]) {
                    [usersText addObject:pickerText];
                    [tempObjects addObject:userID];
                }
                
            }
            else{
                pickerText = [NSString stringWithFormat:@"Per: %@ ** %@", [userID substringToIndex:2], [userID substringWithRange:NSMakeRange(userID.length -2, userID.length - (userID.length - 2))]];
                
                if (![tempObjects containsObject:userID]) {
                    [usersText addObject:pickerText];
                    [tempObjects addObject:userID];
                }
            }
            
        }
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return usersText.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [usersText objectAtIndex:row];
}

-(void)selectPickerRow{
    NSInteger row = [userPickerList selectedRowInComponent:0];
    userIDPassed = [userids objectAtIndex:row];
    utypePassed = [utypes objectAtIndex:row];
    seedPassed = [seeds objectAtIndex:row];
}

-(IBAction)registerOTPButton:(id)sender{
    [self performSegueWithIdentifier:@"registerView" sender:self];
}

-(IBAction)changePin:(id)sender{
    [self performSegueWithIdentifier:@"showChangePin" sender:self];
}

-(IBAction)generateOTP:(id)sender{
    
    if(users != nil && users.count > 0){
        [self selectPickerRow];
        [self performSegueWithIdentifier:@"generateOTPView" sender:self];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No User Selected" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)unwindToHomeController:(UIStoryboardSegue *)unwindSegue{
    
}

-(IBAction)logOut:(id)sender{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"generateOTPView"]) {
        GenerateOTPViewController *generateOTPView = segue.destinationViewController;
        generateOTPView.userID = userIDPassed;
        generateOTPView.seed = seedPassed;
        generateOTPView.utype = utypePassed;
    }
}

-(NSManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
    }
    return context;
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[NSAttributedString alloc]initWithString:[usersText objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

@end
