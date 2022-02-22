//
//  RegistrationDateBirth.m
//  LilFam NATION
//
//  Created by Daniil Savva on 03.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "RegistrationDateBirth.h"
#import "GlobalVariables.h"

@interface RegistrationDateBirth ()

@end

@implementation RegistrationDateBirth
@synthesize datePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [datePicker setLocale: [NSLocale localeWithLocaleIdentifier:@"ru"]];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date_to_datePicker;
    @try {
        date_to_datePicker = [dateFormatter dateFromString:[GlobalVariables sharedInstance].g_birthday];
    } @catch (NSException *exception) {
        date_to_datePicker = [dateFormatter dateFromString:@"2000-01-01"];
    } @finally {
        date_to_datePicker = [dateFormatter dateFromString:@"2000-01-01"];
    }
    
    
     [datePicker setDate:date_to_datePicker];
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
