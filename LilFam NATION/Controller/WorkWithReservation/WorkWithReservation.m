//
//  WorkWithReservation.m
//  LilFam NATION
//
//  Created by Daniil Savva on 02.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "WorkWithReservation.h"
#import "GlobalVariables.h"
#import "DAO.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h>

@interface WorkWithReservation ()

@end

@implementation WorkWithReservation
//@synthesize BtnToMap, btnCansel, name_of_group, day_week_to_print, time_from_of_group, name_of_abonement, name_of_branch, date_of_action_to_print, name_of_prepod;
@synthesize btnCansel, BtnToMap, groupName, groupDate, groupTime, groupTeacher, groupDescriptionBranch, backgroundOfImage, groupDescription, img_of_teacher, groupSchedule, group_status_to_print, lesson_date_of_buy, lesson_about_abonement;

- (void)viewDidLoad {
    [super viewDidLoad];
    BtnToMap.layer.cornerRadius = 10;
    btnCansel.layer.cornerRadius = 10;
    backgroundOfImage.layer.cornerRadius = 2;
    
    NSLog(@"[GlobalVariables sharedInstance].global_name_of_group = %@",[GlobalVariables sharedInstance].global_name_of_group);
    
    groupName.text = [GlobalVariables sharedInstance].global_name_of_group;
    groupTime.text = [GlobalVariables sharedInstance].global_time_of_group;
    groupTeacher.text = [GlobalVariables sharedInstance].global_name_of_teacher;
    groupDate.text = [GlobalVariables sharedInstance].global_dayweak_month_date;
    groupDescription.text = [NSString stringWithFormat:@"Описание: %@", [GlobalVariables sharedInstance].global_description];
    lesson_date_of_buy.text = [NSString stringWithFormat:@"Дата записи: %@", [GlobalVariables sharedInstance].lesson_date_of_buy];
    lesson_about_abonement.text = [NSString stringWithFormat:@"Использован абонемент: %@", [GlobalVariables sharedInstance].lesson_about_abonement];
    
    if(![[GlobalVariables sharedInstance].global_name_of_branch isEqualToString:@""]){
        groupDescriptionBranch.text = [NSString stringWithFormat:@"Местоположение: %@", [GlobalVariables sharedInstance].global_name_of_branch];
    } else {
        groupDescriptionBranch.hidden = TRUE;
    }
    if([[GlobalVariables sharedInstance].global_coordinates_of_branch isEqualToString:@"-"]){
        BtnToMap.hidden = TRUE;
    }
    
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
    
    if([[GlobalVariables sharedInstance].global_status_of_group isEqual:@"-1"]){
        btnCansel.hidden = TRUE;
        group_status_to_print.text = @"ЗАНЯТИЕ ОТМЕНЕНО";
        group_status_to_print.textColor = [UIColor whiteColor];
        group_status_to_print.layer.borderColor = [UIColor redColor].CGColor;
        group_status_to_print.layer.borderWidth = 4.0;
        group_status_to_print.layer.backgroundColor = [UIColor redColor].CGColor;
        group_status_to_print.layer.cornerRadius = 4.0;
    }
    
    if([[GlobalVariables sharedInstance].global_status_of_group isEqual:@"0"]){
        group_status_to_print.text = @"Отметьтесь с помощью QR-кода у преподавателя пожалуйста!";
        group_status_to_print.textColor = [UIColor whiteColor];
        group_status_to_print.layer.borderColor = [UIColor grayColor].CGColor;
        group_status_to_print.layer.borderWidth = 2.0;
        group_status_to_print.layer.backgroundColor = [UIColor grayColor].CGColor;
        group_status_to_print.layer.cornerRadius = 2.0;
    }
    if([[GlobalVariables sharedInstance].global_status_of_group isEqual:@"1"]){
        group_status_to_print.text = @"ВЫ УЖЕ ОТМЕТИЛИСЬ, ЖДЁМ ВАС!";
        group_status_to_print.textColor = [UIColor whiteColor];
        group_status_to_print.layer.borderColor = [UIColor blueColor].CGColor;
        group_status_to_print.layer.borderWidth = 4.0;
        group_status_to_print.layer.backgroundColor = [UIColor blueColor].CGColor;
        group_status_to_print.layer.cornerRadius = 4.0;
    }
    if([[GlobalVariables sharedInstance].global_status_of_group isEqual:@"2"] || [[GlobalVariables sharedInstance].global_status_of_group isEqual:@"3"]){
        //btnCansel.hidden = TRUE;
        group_status_to_print.text = @"ВЫ УЖЕ ОТМЕТИЛИСЬ, ЖДЁМ ВАС!";
        group_status_to_print.textColor = [UIColor whiteColor];
        group_status_to_print.layer.borderColor = [UIColor blueColor].CGColor;
        group_status_to_print.layer.borderWidth = 4.0;
        group_status_to_print.layer.backgroundColor = [UIColor blueColor].CGColor;
        group_status_to_print.layer.cornerRadius = 4.0;
    }
    
    
    
}


- (IBAction)btnClose:(id)sender {
    [self closeView];
}
-(void)closeView {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:Nil];
}

-(IBAction)clickBtnToMap:(id)sender {
    NSString *stringURL = [NSString stringWithFormat:@"https://www.google.com/maps/@%@,16z",[GlobalVariables sharedInstance].g_r_coordinates_of_branch];
    NSURL *coordinates = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:coordinates];
}

-(IBAction)clickbtnCansel:(id)sender {
    
    if([[GlobalVariables sharedInstance].global_status_of_group isEqualToString:@"3"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Лимит времени возврата исчерпан" message:@"Время, отведенное для отмены занятия до его начала, истекло.\n Если произошла ошибка или вы не смогли посетить занятие по личным обстоятельствам, позвоните пожалуйста нам, вопрос решим.\n +7 (495) 589-27-20" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        }];
        UIAlertAction *tryAganin = [UIAlertAction actionWithTitle:@"Позвонить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+74955892720"]];
        }];
        [alert addAction:tryAganin];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
    } else if([[GlobalVariables sharedInstance].global_status_of_group isEqualToString:@"2"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Преподаватель уже отметил вас" message:@"Если вы хотите отменить данное занятие, сообщите пожалуйста преподавателю или администратору.\n Если произошла ошибка, позвоните пожалуйста нам, вопрос решим.\n +7 (495) 589-27-20" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        }];
        UIAlertAction *tryAganin = [UIAlertAction actionWithTitle:@"Позвонить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:+74955892720"]];
        }];
        [alert addAction:tryAganin];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
    } else {
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Отменить занятие" message:@"Вы уверены, что хотите вернуть занятие?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        }];
        UIAlertAction *tryAganin = [UIAlertAction actionWithTitle:@"Выполнить" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self cansel_reservation];
        }];
        [alert addAction:tryAganin];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
    }
}

-(void)cansel_reservation {
    //[GlobalVariables sharedInstance].g_r_id_of_reservation
    
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
            
            //NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_cansel_zanyatie_and_delete_reservation.php",[GlobalVariables sharedInstance].global_url]];
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_cansel_lesson.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            //NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_reservation=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].g_r_id_of_reservation];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_notes=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].lesson_id_of_notes];
            NSData *data_profile = [userUpdate_profile dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest_profile setHTTPBody:data_profile];
            //NSLog(@"Отправляемые параметры %@",userUpdate_profile);
            
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
                    
                    if([[jsonDict_profile objectForKey:@"a"] isEqualToString:@"1"]){

                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Выполнено" message:@"Удаление брони и возвращение занятия абонементу прошло успешно" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                //чтобы вызвалась функция в view MyReservations
                                [self dismissViewControllerAnimated:NO completion:^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"changeReservation" object:self];
                                }];
                        }];
                        [alert addAction:okAction];
                        dispatch_async(dispatch_get_main_queue(), ^(void){
                             [self presentViewController:alert animated:true completion:nil];
                        });
                    }
                    
                    
                    
                }
            }
            
            
        }
    }
    
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
