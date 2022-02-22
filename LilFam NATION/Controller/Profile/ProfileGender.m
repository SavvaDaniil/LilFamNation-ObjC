//
//  ProfileGender.m
//  LilFam NATION
//
//  Created by Daniil Savva on 20.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "ProfileGender.h"
#import "GlobalVariables.h"
#import "DAO.h"

@interface ProfileGender ()

@end

@implementation ProfileGender{
    NSArray *genderArray;
}
@synthesize genderTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    genderArray = [NSArray arrayWithObjects:@"Не выбрано",@"Женский",@"Мужской", nil];
}
- (IBAction)btnClose:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:Nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [genderArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ProfileGender";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
 
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
 
    
    cell.textLabel.text = [genderArray objectAtIndex:indexPath.row];
    

    DAO *code = [DAO alloc];
    code = [code init];
    if(([[GlobalVariables sharedInstance].g_gender isEqualToString:@"0"] && indexPath.row == 0) || ([[GlobalVariables sharedInstance].g_gender isEqualToString:@""] && indexPath.row == 0)){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if([[GlobalVariables sharedInstance].g_gender isEqualToString:@"1"] && indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if([[GlobalVariables sharedInstance].g_gender isEqualToString:@"2"] && indexPath.row == 2){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    
    
    /*
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    */
    
    return cell;
}




-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Был выбран пункт %ld",(long)indexPath.row);
    
    DAO *code = [DAO alloc];
    code = [code init];
    
    if(indexPath.row == 0){
        //[code update_data_in_DB_value_1:@"gender" second:@"0"];
        [GlobalVariables sharedInstance].g_gender = [NSMutableString stringWithString:@"0"];
    }
    if(indexPath.row == 1){
        //[code update_data_in_DB_value_1:@"gender" second:@"1"];
        [GlobalVariables sharedInstance].g_gender = [NSMutableString stringWithString:@"1"];
    }
    if(indexPath.row == 2){
        //[code update_data_in_DB_value_1:@"gender" second:@"2"];
        [GlobalVariables sharedInstance].g_gender = [NSMutableString stringWithString:@"2"];
    }
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return CGFLOAT_MIN;
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
