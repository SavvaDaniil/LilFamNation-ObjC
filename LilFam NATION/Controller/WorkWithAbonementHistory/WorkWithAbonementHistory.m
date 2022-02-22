//
//  WorkWithAbonementHistory.m
//  LilFam NATION
//
//  Created by Daniil Savva on 20.01.2020.
//  Copyright © 2020 Daniil Savva. All rights reserved.
//

#import "WorkWithAbonementHistory.h"
#import "GlobalVariables.h"
#import "DAO.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h>

@interface WorkWithAbonementHistory ()

@end

@implementation WorkWithAbonementHistory {
    NSMutableArray *array_with_info_of_abonement;
    NSMutableArray *array_of_lessons;
}
@synthesize reservationsTable;

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self loadworkwithabonementhistory];
}
-(IBAction)refreshView {
    [self loadworkwithabonementhistory];
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
-(void)loadworkwithabonementhistory {

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
            
    
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_get_info_about_buyed_abonement_HISTORY.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_notes=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].history_id_of_notes];
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
                NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError_profile];
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
                    NSLog(@"%@",jsonDict);
                    
                    self -> array_with_info_of_abonement = [jsonDict objectForKey:@"array_with_info_of_abonement"];
                    self -> array_of_lessons = [[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"array_of_lessons"];
                    NSLog(@"array_with_info_of_abonements = %@",array_with_info_of_abonement);
                    
                    
self -> name_of_abonement.text = [NSString stringWithFormat:@"Наименование: %@",[[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"name_of_abonement"]];
self -> how_much_money.text = [NSString stringWithFormat:@"Сумма: %@ рублей",[[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"how_much_money"]];
self -> date_of_buy.text = [NSString stringWithFormat:@"Дата покупки: %@",[[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"date_of_buy"]];
self -> how_much_days.text = [NSString stringWithFormat:@"На сколько дней: %@",[[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"how_much_days"]];
self -> date_of_activation.text = [NSString stringWithFormat:@"Дата активации: %@",[[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"date_of_activation"]];
self -> date_to_must_be_used.text = [NSString stringWithFormat:@"Использовать до: %@",[[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"date_to_must_be_used"]];
self -> skolko_iznachalno_zanyatiy.text = [NSString stringWithFormat:@"На сколько занятий: %@",[[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"skolko_iznachalno_zanyatiy"]];
self -> ostalos.text = [NSString stringWithFormat:@"Осталось: %@",[[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"ostalos"]];
                    
                    
if([[[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"status"] isEqualToString:@"0"]){
    self -> status.text = @"Статус: Занятий не осталось";
    self -> status.textColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
} else if([[[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"status"] isEqualToString:@"-1"]){
    self -> status.text = @"Статус: Истёк срок использования";
    self -> status.textColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
} else if([[[array_with_info_of_abonement objectAtIndex:0] valueForKey:@"status"] isEqualToString:@"1"]){
    self -> status.text = @"Статус: Доступен для использования";
    self -> status.textColor = [UIColor colorWithRed:0.00 green:0.50 blue:0.00 alpha:1.0];
}
                    [reservationsTable reloadData];
                    
                }
            }
            
            
        }
    }
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array_of_lessons count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Обновляем таблицу с бронью");
    static NSString *simpleTableIdentifier = @"reservarionsTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    
    NSLog(@"Проверяем номер ячейки %ld",(long)indexPath.row);
    
    
    NSString *status = [NSString stringWithString:[[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"status"]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d) %@ - %@ (%@)",(indexPath.row + 1), [[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"date_of_action_to_print"], [[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"name_of_group"], [[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"time_from_of_group"]];
    
    if([status isEqualToString:@"0"] || [status isEqualToString:@"1"]){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"name_of_branch"], @"В ожидании"];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
    } else if([status isEqualToString:@"3"] || [status isEqualToString:@"2"]){
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"name_of_branch"], @"Успешно использована"];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.00 green:0.50 blue:0.00 alpha:1.0];
    }
    
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *id_of_notes = [NSString stringWithString:[[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"id_of_notes"]];
    NSLog(@"Был выбран пункт %ld , где id_of_notes = %@",(long)indexPath.row, id_of_notes);
    
    [GlobalVariables sharedInstance].lesson_id_of_notes = [NSMutableString stringWithString:id_of_notes];
    
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
            
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_work_with_lesson.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_notes=%@",id_of_user, check_hash, id_of_notes];
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
                NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError_profile];
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
                    NSLog(@"%@",jsonDict);
                
                    [GlobalVariables sharedInstance].global_id_of_group = [jsonDict objectForKey:@"id_of_group"];
                    [GlobalVariables sharedInstance].global_date_of_action = [jsonDict objectForKey:@"date_of_action"];
                    [GlobalVariables sharedInstance].global_name_of_group = [jsonDict objectForKey:@"name_of_group"];
                    [GlobalVariables sharedInstance].global_time_of_group = [jsonDict objectForKey:@"time_of_group"];
                    [GlobalVariables sharedInstance].global_name_of_teacher = [jsonDict objectForKey:@"teacher_of_group"];
                    [GlobalVariables sharedInstance].global_name_of_branch = [jsonDict objectForKey:@"name_of_branch"];
                    [GlobalVariables sharedInstance].global_description_of_branch = [jsonDict objectForKey:@"description_of_branch"];
                    [GlobalVariables sharedInstance].global_coordinates_of_branch = [jsonDict objectForKey:@"coordinates_of_branch"];
                    [GlobalVariables sharedInstance].global_id_of_teacher = [jsonDict objectForKey:@"id_of_teacher"];
                    [GlobalVariables sharedInstance].global_dayweak_month_date = [jsonDict objectForKey:@"dayweek_month_date"];
                    [GlobalVariables sharedInstance].global_description = [jsonDict objectForKey:@"description"];
                    [GlobalVariables sharedInstance].global_img_of_teacher = [jsonDict objectForKey:@"img_of_teacher"];
                    [GlobalVariables sharedInstance].global_schedule_of_group = [jsonDict objectForKey:@"schedule_of_group"];
                    [GlobalVariables sharedInstance].global_status_of_group = [jsonDict objectForKey:@"status_of_group"];

                    [GlobalVariables sharedInstance].lesson_date_of_buy = [jsonDict objectForKey:@"normal_date_time_of_buy"];
                    [GlobalVariables sharedInstance].lesson_about_abonement = [jsonDict objectForKey:@"name_of_abonement"];
                    
                    
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    WorkWithAbonementHistory *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"WorkWithReservation"];
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return CGFLOAT_MIN;
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
              withRowAnimation:(UITableViewRowAnimation)animation {
    NSLog(@"Обновление таблицы с уроками абонемента");
}


@end
