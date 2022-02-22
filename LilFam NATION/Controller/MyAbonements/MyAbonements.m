//
//  MyAbonements.m
//  LilFam NATION
//
//  Created by Daniil Savva on 30.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "MyAbonements.h"
#import "GlobalVariables.h"
#import "DAO.h"
#import "AbonementBuyed.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h> 

@interface MyAbonements ()

@end

@implementation MyAbonements {
    
    NSMutableString *count_of_purchases;
    NSMutableArray *array_count_notes_and_id_of_abonements;
    NSDictionary *array_with_info_of_abonements;
    
    NSMutableString *app_time_minutes_blocked_return_for_group_add_zanyatie_by_auto;
}
@synthesize abonementsTable, btnBuyNewAbonement;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnBuyNewAbonement.layer.cornerRadius = 10;
    //btnBuyNewAbonement.hidden = TRUE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exit_from_abonements_for_buy:)  name:@"exit_from_abonements_for_buy" object:nil];
}
- (void) exit_from_abonements_for_buy:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"exit_from_abonements_for_buy"]){
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"successReservation" object:self];
        }];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self reloadMyAbonements];
}
- (void)appDidBecomeActive:(NSNotification *)notification {
    //NSLog(@"appDidBecomeActive");
    //[self reloadMyAbonements];
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
-(IBAction)clickbtnBuyNewAbonement:(id)sender {
    //убираю пока оплату в этой версии
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyAbonements *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"AbonementsForBuy"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentModalViewController:vc animated:NO];
}

-(IBAction)refreshTable {
    [self reloadMyAbonements];
}

-(void)reloadMyAbonements {

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
            
    
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_list_buyed_abonement.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_group=%@&date_of_action=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].global_id_of_group, [GlobalVariables sharedInstance].global_date_of_action];
            NSData *data_profile = [userUpdate_profile dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest_profile setHTTPBody:data_profile];
            
            
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
                NSDictionary * jsonDict2 = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError_profile];
                if (jsonError_profile != nil) {
                    //NSLog(@"JSON isn't right:%@",jsonError);
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alert addAction:okAction];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                         [self presentViewController:alert animated:true completion:nil];
                    });
                } else {
                    NSLog(@"%@",jsonDict2);
                    

                    self->count_of_purchases = [jsonDict2 objectForKey:@"count_of_purchases"];
                    self->array_count_notes_and_id_of_abonements = [jsonDict2 objectForKey:@"array_count_notes_and_id_of_abonements"];
                    self->array_with_info_of_abonements = [jsonDict2 objectForKey:@"array_with_info_of_abonements"];
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                        NSLog(@"Асинхронное обновление");
                        [self.abonementsTable reloadData];
                    });
                }
            }
            
            
        }
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//количество записей в каждой секции. Количество занятий в день
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [[count_of_purchases valueForKey:[NSString stringWithFormat:@"%ld",(long)section]] count];
    return [count_of_purchases intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Обновляем таблицу с абонементами");
    
    
    static NSString *simpleTableIdentifier = @"abonementsTable";

    //AbonementBuyed *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    //UITableViewCellStyleSubtitle - с кратким описанием
    
    NSLog(@"Проверяем номер ячейки %ld",(long)indexPath.row);
    
    
    NSString *id_of_notes = [NSString stringWithFormat:@"%@", [array_count_notes_and_id_of_abonements objectAtIndex:indexPath.row]];
    
    /*
    cell.labelNameOfAbonement.text = [[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"name_of_abonement"];
    
    cell.labelDescriptionOfAbonement.text = [NSString stringWithFormat:@"Осталось %@ из %@ / куп. %@",[[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"ostalos"],[[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"skolko_iznachalno_zanyatiy"],[[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"date_of_buy_to_show"]];
    
    
    cell.textLabel.text = id_of_notes;
    cell.textLabel.hidden = true;
    */
    
    cell.textLabel.text = [[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"name_of_abonement"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Осталось %@ из %@ / куп. %@",[[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"ostalos"],[[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"skolko_iznachalno_zanyatiy"],[[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"date_of_buy_to_show"]];
    
    /*
    //NSLog(@"Рисуются назянтия из секции %ld",(long)indexPath.section);
    //cell.groupTime.text = [scheduleSchetchikId valueForKey:[scheduleDict valueForKey:]];
    NSString *dayId = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSLog(@"Проверяем день по счету %@",dayId);
    NSString *SchetchikId = [NSString stringWithFormat:@"%@", [[scheduleDict2 valueForKey:dayId] objectAtIndex:indexPath.row]];
    NSLog(@"Получаем временный индекс группы scheduleSchetchikId = %@",SchetchikId);
    
    NSLog(@"Прочитал id_of_group %@ ищем данные о ней в базе данных расписания полученной",[[scheduleSchetchikId2 valueForKey:SchetchikId] valueForKey:@"id_of_group"]);
    
    NSString *id_of_group = [[scheduleSchetchikId2 valueForKey:SchetchikId] valueForKey:@"id_of_group"];
    
    cell.groupTime.text = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"time_of_group"];
    cell.groupName.text = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"name_of_group"];
    //cell.groupTeacher.text = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"teacher_of_group"];
    cell.groupTeacher.text = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"name_of_branch"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = SchetchikId;
    cell.textLabel.hidden = true;
    */
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"Был выбран пункт %ld",(long)indexPath.row);
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //NSString *cellText = cell.textLabel.text;
    //NSLog(@"Был выбран пункт %@",cellText);
    
    NSString *id_of_notes = [NSString stringWithFormat:@"%@", [array_count_notes_and_id_of_abonements objectAtIndex:indexPath.row]];
    NSLog(@"Был выбран пункт %@",id_of_notes);
    
    [self script_for_prepare_add_zanyatie:id_of_notes];
    
    //NSLog(@"Вытаскиваем reservation_auto0_prepod1 = %@",[[array_with_info_of_abonements valueForKey:cellText] valueForKey:@"reservation_auto0_prepod1"]);
    
    
    
    
    
    
    /*
    //узнаем данные о группе
    NSString *id_of_group = [[scheduleSchetchikId2 valueForKey:cellText] valueForKey:@"id_of_group"];
    
    [GlobalVariables sharedInstance].global_id_of_group = [NSMutableString stringWithString:id_of_group];
    [GlobalVariables sharedInstance].global_date_of_action = [[scheduleSchetchikId2 valueForKey:cellText] valueForKey:@"date_of_action"];
    
    [GlobalVariables sharedInstance].global_name_of_group = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"name_of_group"];
    [GlobalVariables sharedInstance].global_time_of_group = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"time_of_group"];
    [GlobalVariables sharedInstance].global_name_of_teacher = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"teacher_of_group"];
    [GlobalVariables sharedInstance].global_name_of_branch = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"name_of_branch"];
    [GlobalVariables sharedInstance].global_id_of_teacher = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"id_of_teacher"];
    
    //день занятия
    NSInteger b = [[[scheduleSchetchikId2 valueForKey:cellText] valueForKey:@"id_of_day_of_weak"] integerValue];
    [GlobalVariables sharedInstance].global_dayweak_month_date = [NSMutableString stringWithString:[scheduleDate2 objectAtIndex:b]];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Group"];
    //[self presentModalViewController:vc animated:YES];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentModalViewController:vc animated:NO];
     */
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return CGFLOAT_MIN;
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
              withRowAnimation:(UITableViewRowAnimation)animation {
    NSLog(@"Обновление таблицы с абонементами");
}


-(void)script_for_prepare_add_zanyatie:(NSString *)id_of_notes {
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
            
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_prepare_add_zanyatie.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_group=%@&id_of_notes=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].global_id_of_group, id_of_notes];
            NSData *data_profile = [userUpdate_profile dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest_profile setHTTPBody:data_profile];
            
            NSLog(@"script_for_prepare_add_zanyatie = %@",userUpdate_profile);
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
                    
                    self->app_time_minutes_blocked_return_for_group_add_zanyatie_by_auto = [jsonDict_profile objectForKey:@"app_time_minutes_blocked_return_for_group_add_zanyatie_by_auto"];
                    [self alertIsOk:[jsonDict_profile objectForKey:@"reservation_auto0_prepod1"] id_of_notes:id_of_notes];
                    
                    
                }
            }
            
            
        }
    }
}


-(void)alertIsOk:(NSString *) reservation_auto0_prepod1 id_of_notes:(NSString *) id_of_notes {
    if([reservation_auto0_prepod1 isEqualToString:@"0"]){
        NSString *message_with_time_block_returning = [NSString stringWithFormat:@"Примечание: Бронь автоматически заблокируется за %@ минут до начала занятия.",app_time_minutes_blocked_return_for_group_add_zanyatie_by_auto];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Вы уверены?" message:message_with_time_block_returning preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        }];
        UIAlertAction *tryAganin = [UIAlertAction actionWithTitle:@"Принять" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self script_for_add_zanyatie_and_reservation:id_of_notes];
        }];
        [alert addAction:tryAganin];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
        
    } else if([reservation_auto0_prepod1 isEqualToString:@"1"]){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Вы уверены?" message:@"Перед занятием отметьте пожалуйста свой QR-код у преподавателя или у администратора.\n Если вы не отметитесь в день занятия, бронь будет автоматически снята, а занятие автоматически возвращено абонементу" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        }];
        UIAlertAction *tryAganin = [UIAlertAction actionWithTitle:@"Принять" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self script_for_add_zanyatie_and_reservation:id_of_notes];
        }];
        [alert addAction:tryAganin];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
        
    } else {
        
    }
}

-(void)script_for_add_zanyatie_and_reservation:(NSString *) id_of_notes {
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
            
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_add_zanyatie_and_reservation.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_group=%@&id_of_notes=%@&date_of_action=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].global_id_of_group, id_of_notes, [GlobalVariables sharedInstance].global_date_of_action];
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

                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Спасибо" message:@"Бронирование прошло успешно" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {

                            //чтобы вызвалась функция в Group
                            [self dismissViewControllerAnimated:NO completion:^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"successReservation" object:self];
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
