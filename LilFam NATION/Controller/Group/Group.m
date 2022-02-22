//
//  Group.m
//  LilFam NATION
//
//  Created by Daniil Savva on 16.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "Group.h"
#import "GlobalVariables.h"
#import "DAO.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h>

@interface Group ()

@end

@implementation Group
@synthesize actionBtn, BtnToMap, groupName, groupDate, groupTime, groupTeacher, groupDescriptionBranch, backgroundOfImage, groupDescription, img_of_teacher, groupSchedule, group_status_to_print, btnInstagram, btnSub2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    actionBtn.layer.cornerRadius = 10;
    BtnToMap.layer.cornerRadius = 10;
    backgroundOfImage.layer.cornerRadius = 2;
    btnInstagram.layer.cornerRadius = 10;
    [btnInstagram setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    groupDescription.lineBreakMode = NSLineBreakByWordWrapping;
    groupDescription.numberOfLines = 15;
    
    groupName.text = [GlobalVariables sharedInstance].global_name_of_group;
    groupTime.text = [GlobalVariables sharedInstance].global_time_of_group;
    groupTeacher.text = [GlobalVariables sharedInstance].global_name_of_teacher;
    groupDate.text = [GlobalVariables sharedInstance].global_dayweak_month_date;
    groupDescription.text = [NSString stringWithFormat:@"Описание: %@", [GlobalVariables sharedInstance].global_description];
    
    if(![[GlobalVariables sharedInstance].global_name_of_branch isEqualToString:@""]){
        groupDescriptionBranch.text = [NSString stringWithFormat:@"Местоположение: %@", [GlobalVariables sharedInstance].global_name_of_branch];
    } else {
        groupDescriptionBranch.hidden = TRUE;
    }
    if([[GlobalVariables sharedInstance].global_coordinates_of_branch isEqualToString:@"-"]){
        BtnToMap.hidden = TRUE;
    }
    
    
    btnSub2.layer.cornerRadius = 10;
    [btnSub2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSub2.hidden = true;
    if([[GlobalVariables sharedInstance].global_id_of_group isEqual:@"22"]){
        btnSub2.hidden = FALSE;
        actionBtn.hidden = true;
    }
    
    
    //для отлова закрытия других окно
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeAfterSuccessReservation:)  name:@"successReservation" object:nil];
    
    if(![[GlobalVariables sharedInstance].global_img_of_teacher isEqual:@"0"]){
        img_of_teacher.layer.cornerRadius = 54;
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [GlobalVariables sharedInstance].global_img_of_teacher]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                self->img_of_teacher.image = [UIImage imageWithData: data];
            });
        });
    }
    
    
    if(![[GlobalVariables sharedInstance].global_schedule_of_group isEqual:@"0"]){
        groupSchedule.text = [NSString stringWithFormat:@"Расписание группы: %@", [GlobalVariables sharedInstance].global_schedule_of_group];
    }
    
    if([[GlobalVariables sharedInstance].global_status_of_group isEqual:@"0"]){
        actionBtn.hidden = TRUE;
        group_status_to_print.text = @"ЗАНЯТИЕ ОТМЕНЕНО";
        group_status_to_print.textColor = [UIColor whiteColor];
        group_status_to_print.layer.borderColor = [UIColor redColor].CGColor;
        group_status_to_print.layer.borderWidth = 4.0;
        group_status_to_print.layer.backgroundColor = [UIColor redColor].CGColor;
        group_status_to_print.layer.cornerRadius = 4.0;
    }
    
    if([[GlobalVariables sharedInstance].global_status_of_group isEqual:@"2"]){
        actionBtn.hidden = TRUE;
        group_status_to_print.text = @"ВЫ УЖЕ ОТМЕТИЛИСЬ, ЖДЁМ ВАС!";
        group_status_to_print.textColor = [UIColor whiteColor];
        group_status_to_print.layer.borderColor = [UIColor blueColor].CGColor;
        group_status_to_print.layer.borderWidth = 4.0;
        group_status_to_print.layer.backgroundColor = [UIColor blueColor].CGColor;
        group_status_to_print.layer.cornerRadius = 4.0;
    }
}
- (void) closeAfterSuccessReservation:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"successReservation"])
        [self closeViewController];
}
- (IBAction)btnInstagramClick:(id)sender{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=studio.lilfam.nation"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    } else {
        NSURL* url = [[NSURL alloc] initWithString: @"https://www.instagram.com/studio.lilfam.nation"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
    }
}
- (IBAction)btnSub2Click {
    NSURL* url = [[NSURL alloc] initWithString: @"http://studio.lilfamnation.com/lilfamday"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
}

- (IBAction)btnClose:(id)sender {
    [self closeViewController];
}
-(void)closeViewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:Nil];
}

-(IBAction)clickBtnToMap:(id)sender {
    /*
    NSString *stringURL = [NSString stringWithFormat:@"https://www.google.com/maps/search/?api=1&query=%@",[GlobalVariables sharedInstance].global_coordinates_of_branch];
    NSURL *coordinates = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:coordinates];
     */
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]){
        NSString *string_for_url = [NSString stringWithFormat:@"comgooglemaps://center=%@&zoom=16",[GlobalVariables sharedInstance].global_coordinates_of_branch];
        NSURL *url_for_google_maps = [NSURL URLWithString:string_for_url];
        [[UIApplication sharedApplication] openURL:url_for_google_maps];
    } else {
        NSString *stringURL = [NSString stringWithFormat:@"https://www.google.com/maps/search/?api=1&query=%@",[GlobalVariables sharedInstance].global_coordinates_of_branch];
        NSURL *coordinates = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:coordinates];
    }
}

-(IBAction)Start:(id)sender {
    //проверка на заполненность профиля
    
    DAO *code = [DAO alloc];
    code = [code init];
    NSString *check_of_registration = [code check_registration_in_ios];
    
    if([check_of_registration isEqualToString:@"0"]){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Group *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentModalViewController:vc animated:NO];
    } else {
        [self checkProfileFillAndContinue];
    }
}

-(void)checkProfileFillAndContinue {
    
    
    DAO *code_profile = [DAO alloc];
    code_profile = [code_profile init];
    NSString *id_of_user = [code_profile select_value_1_from_DB:@"id_of_user"];
    NSString *key_access_from_server = [code_profile select_value_1_from_DB:@"key_access"];
    
    
    NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/first_step.php",[GlobalVariables sharedInstance].global_url]];
    NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
    NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@",id_of_user];
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
            
            
            NSString *random = [jsonDict objectForKey:@"a"];
            NSString *key_access_hash = [key_access_from_server md5];
            NSString *random_hash = [random md5];
            NSString *key_and_random = [NSString stringWithFormat:@"%@%@",key_access_hash,random_hash];
            NSString *check = [NSMutableString stringWithFormat:@"%@XXXXXXXXXXXXXXXXXXXXXX",key_and_random];
            NSString *check_hash = [check md5];
            
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/check_profile_fill.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_group=%@&date_of_action=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].global_id_of_group, [GlobalVariables sharedInstance].global_date_of_action];
            NSData *data_profile = [userUpdate_profile dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest_profile setHTTPBody:data_profile];
            //NSLog(@"Запрос check_profile_fill : %@",userUpdate_profile);
            
            NSError *error_profile = nil;
            NSHTTPURLResponse *responceCode_profile = nil;
            NSData *responseData_profile = [NSURLConnection sendSynchronousRequest:urlRequest_profile returningResponse:&responceCode_profile error:&error_profile];
            if (error_profile) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                }];
                [alert addAction:okAction];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                     [self presentViewController:alert animated:true completion:nil];
                });
            } else {
                NSLog(@"%@", [[NSString alloc] initWithData:responseData_profile encoding:NSASCIIStringEncoding]);
                
                NSError *jsonError_profile;
                NSDictionary * jsonDict_profile = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError_profile];
                if (jsonError_profile != nil) {
                    //NSLog(@"JSON isn't right:%@",jsonError);
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка на стороне сервера" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alert addAction:okAction];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                         [self presentViewController:alert animated:true completion:nil];
                    });
                } else {
                    NSLog(@"%@",jsonDict_profile);
                    
                    
                    if([[jsonDict_profile objectForKey:@"error"] isEqualToString:@"5"]){
                        
                    }
                    
                    
                    if([[jsonDict_profile objectForKey:@"profile_fill"] isEqualToString:@"1"]){
                        if([[jsonDict_profile objectForKey:@"special_status_for_tv_gr_access_denied"] isEqualToString:@"1"]){

                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Извините" message:@"Это закрытая группа, вы не подключены к группе.\n Если это ошибка, обратитесь пожалуйста к преподавателю или администратору." preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            }];
                            [alert addAction:okAction];
                            dispatch_async(dispatch_get_main_queue(), ^(void){
                                 [self presentViewController:alert animated:true completion:nil];
                            });
                            
                        } else {
                            //already_add_zanyatie
                            if([[jsonDict_profile objectForKey:@"already_add_zanyatie"] isEqualToString:@"1"]){
                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Извините" message:@"Вы уже отметились на занятие.\n Если это ошибка, сообщите пожалуйста администратору." preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                }];
                                [alert addAction:okAction];
                                dispatch_async(dispatch_get_main_queue(), ^(void){
                                     [self presentViewController:alert animated:true completion:nil];
                                });
                            } else {
                                [GlobalVariables sharedInstance].profileNotFill = [NSMutableString stringWithString:@"0"];
                                NSLog(@"Проверка на заполненность профиля прошла успешно");
                                
                                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                Group *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MyAbonements"];
                                CATransition *transition = [CATransition animation];
                                transition.duration = 0.3;
                                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                transition.type = kCATransitionPush;
                                transition.subtype = kCATransitionFromRight;
                                [self.view.window.layer addAnimation:transition forKey:nil];
                                [self presentModalViewController:vc animated:NO];
                            }
                        }
                    } else {
                        [GlobalVariables sharedInstance].profileNotFill = [NSMutableString stringWithString:@"1"];
                        
                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        Group *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Profile"];
                        CATransition *transition = [CATransition animation];
                        transition.duration = 0.3;
                        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                        transition.type = kCATransitionPush;
                        transition.subtype = kCATransitionFromRight;
                        [self.view.window.layer addAnimation:transition forKey:nil];
                        [self presentModalViewController:vc animated:NO];
                        
                    }
                    
                }
            }
            
            
        }
    }
    
}


@end




//           ДЛЯ ШИФРОВАНИЯ MD5 НАЧАЛО

@implementation NSString (MyAdditions)
- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end

@implementation NSData (MyAdditions)
- (NSString*)md5
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( self.bytes, (int)self.length, result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
