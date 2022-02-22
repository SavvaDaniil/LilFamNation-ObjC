//
//  ProfileDateBirth.m
//  LilFam NATION
//
//  Created by Daniil Savva on 20.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "ProfileDateBirth.h"
#import "GlobalVariables.h"

@interface ProfileDateBirth ()

@end

@implementation ProfileDateBirth
@synthesize datePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [datePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"ru"]];
    //[GlobalVariables sharedInstance].g_birthday
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date_to_datePicker = [dateFormatter dateFromString:[GlobalVariables sharedInstance].g_birthday];
    [datePicker setDate:date_to_datePicker];
    
    
    /*
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
     */
}

- (IBAction)btnClose:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self dismissViewControllerAnimated:NO completion:Nil];
    
    //чтобы вызвалась функция в view Profile
    [self dismissViewControllerAnimated:NO completion:^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"changeProfile" object:self];
    }];
}


- (IBAction)datePickerChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSLog(@"%@",[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate: datePicker.date]]);
    [GlobalVariables sharedInstance].g_birthday = [NSMutableString stringWithString:[dateFormatter stringFromDate: datePicker.date]];
}

- (IBAction)closeDatePicker:(id)sender {
    
}

//Needed to prevent keyboard from opening
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
