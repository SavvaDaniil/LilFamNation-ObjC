//
//  ChooseAbonement.m
//  LilFam NATION
//
//  Created by Daniil Savva on 27.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "ChooseAbonement.h"
#import "DAO.h"

@interface ChooseAbonement ()

@end

@implementation ChooseAbonement

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    NSURL *url_profile = [NSURL URLWithString:@"https://fame-application.com/lilfamnation/first_step.php"];
    NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
    NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@",@"1"];
    NSData *data_userUpdate_profile = [userUpdate_profile dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest_profile setHTTPBody:data_userUpdate_profile];
    [urlRequest_profile setHTTPMethod:@"POST"];
    
    

    NSError *error_profile = nil;
    NSHTTPURLResponse *responceCode_profile = nil;
    NSData *responseData_profile = [NSURLConnection sendSynchronousRequest:urlRequest_profile returningResponse:&responceCode_profile error:&error_profile];
    if (error_profile) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
    } else {
        NSLog(@"%@", [[NSString alloc] initWithData:responseData_profile encoding:NSASCIIStringEncoding]);
        
        NSError *jsonError;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            }];
            [alert addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                 [self presentViewController:alert animated:true completion:nil];
            });
        } else {
            NSLog(@"%@",jsonDict);
            /*
            NSString *random = [jsonDict objectForKey:@"a"];
            NSString *key_access_from_server = [code_profile select_value_1_from_DB:@"key_access"];
            NSString *key_access_hash = [key_access_from_server md5];
            random = [random md5];
            NSString *check_hash = [NSMutableString stringWithFormat:@"%@%@XXXXXXXXXXXXXXXXXXXXXX",key_access_hash,random];
            check_hash = [check_hash md5];
            */
            /*
            NSURL *url = [NSURL URLWithString:@"https://fame-application.com/lilfamnation/profile.php"];
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
            [urlRequest setHTTPMethod:@"POST"];
            NSString *userUpdate =[NSString stringWithFormat:@"a=%@&b=%@",id_of_user, check_hash];
            NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest setHTTPBody:data];
            
            NSError *error = nil;
            NSHTTPURLResponse *responceCode = nil;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responceCode error:&error];
            if (error) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                }];
                [alert addAction:okAction];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                     [self presentViewController:alert animated:true completion:nil];
                });
            } else {
                NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
                
                NSError *jsonError;
                NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
                if (jsonError != nil) {
                    //NSLog(@"JSON isn't right:%@",jsonError);
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alert addAction:okAction];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                         [self presentViewController:alert animated:true completion:nil];
                    });
                } else {
                    NSLog(@"%@",jsonDict);
                    [GlobalVariables sharedInstance].g_fio = [jsonDict objectForKey:@"fio"];
                    [GlobalVariables sharedInstance].g_mail = [jsonDict objectForKey:@"mail"];
                    [GlobalVariables sharedInstance].g_phone = [jsonDict objectForKey:@"phone"];
                    [GlobalVariables sharedInstance].g_birthday = [jsonDict objectForKey:@"birthday"];
                    [GlobalVariables sharedInstance].g_minor = [jsonDict objectForKey:@"minor"];
                    [GlobalVariables sharedInstance].g_gender = [jsonDict objectForKey:@"gender"];
                    [GlobalVariables sharedInstance].g_parent_fio = [jsonDict objectForKey:@"parent_fio"];
                    [GlobalVariables sharedInstance].g_parent_phone = [jsonDict objectForKey:@"parent_phone"];
                    
                    
                }
            }
            */
            
        }
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
