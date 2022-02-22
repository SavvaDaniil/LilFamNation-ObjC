//
//  MyReservations.m
//  LilFam NATION
//
//  Created by Daniil Savva on 02.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "MyReservations.h"
#import "DAO.h"
#import "GlobalVariables.h"
#import "Reservation.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h>
#import "SceneDelegate.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface MyReservations ()

@end

@implementation MyReservations {
    NSMutableString *count_of_lessons;
    NSMutableArray *array_of_lessons;
}
@synthesize reservationsTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeReservation:)  name:@"changeReservation" object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self reloadMyReservations];
}
- (IBAction)btnMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(IBAction)refreshTable {
    [self reloadMyReservations];
}

- (void) changeReservation:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"changeReservation"])
        [self reloadMyReservations];
}
-(void)reloadMyReservations {
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
            
    
            //NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_list_of_reservations.php",[GlobalVariables sharedInstance].global_url]];
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_list_of_lessons.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@",id_of_user, check_hash];
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
                    

                    self->array_of_lessons = [jsonDict2 objectForKey:@"array_of_lessons"];
                    
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                        NSLog(@"Асинхронное обновление");
                        [self.reservationsTable reloadData];
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
    return [array_of_lessons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Обновляем таблицу с бронью");
    static NSString *simpleTableIdentifier = @"reservarionsTable";
    //Reservation *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    
    NSLog(@"Проверяем номер ячейки %ld",(long)indexPath.row);
    
    
    NSString *status = [NSString stringWithString:[[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"status"]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@ (%@)", [[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"date_of_action_to_print"], [[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"name_of_group"], [[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"time_from_of_group"]];
    
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
    
    //[GlobalVariables sharedInstance].lesson_id_of_group_with_date_of_action = [NSMutableString stringWithFormat:@"%@_%@",[[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"id_of_group"],[[array_of_lessons objectAtIndex:indexPath.row] valueForKey:@"date_of_action"]];
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
            
    
            //NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_work_with_reservation.php",[GlobalVariables sharedInstance].global_url]];
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_work_with_lesson.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            //NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_reservation=%@",id_of_user, check_hash, cellText];
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
                    
/*

 NSMutableString *g_r_id_of_reservation;
 NSMutableString *g_r_name_of_group;
 NSMutableString *g_r_dayweak_month_date;
 NSMutableString *g_r_time_of_group;
 NSMutableString *g_r_name_of_teacher;
 NSMutableString *g_r_name_of_abonement;
 NSMutableString *g_r_name_of_branch;
 NSMutableString *g_r_coordinates_of_branch;
 NSMutableString *g_r_status_of_resevation;
 */
                    /*
                    [GlobalVariables sharedInstance].g_r_id_of_reservation = [NSMutableString stringWithString:cellText];
                    [GlobalVariables sharedInstance].g_r_name_of_group = [jsonDict2 objectForKey:@"name_of_group"];
                    [GlobalVariables sharedInstance].g_r_dayweak_month_date = [jsonDict2 objectForKey:@"day_week_to_print"];
                    [GlobalVariables sharedInstance].g_r_time_of_group = [jsonDict2 objectForKey:@"time_from_of_group"];
                    [GlobalVariables sharedInstance].g_r_name_of_teacher = [jsonDict2 objectForKey:@"fio_of_prepod"];
                    [GlobalVariables sharedInstance].g_r_name_of_abonement = [jsonDict2 objectForKey:@"name_of_abonement"];
                    [GlobalVariables sharedInstance].g_r_name_of_branch = [jsonDict2 objectForKey:@"name_of_branch"];
                    [GlobalVariables sharedInstance].g_r_coordinates_of_branch = [jsonDict2 objectForKey:@"coordinates_of_branch"];
                    [GlobalVariables sharedInstance].g_r_status_of_resevation = [jsonDict2 objectForKey:@"status"];
                    [GlobalVariables sharedInstance].g_r_date_of_action = [jsonDict2 objectForKey:@"date_of_action_to_print"];
                    */

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
                    MyReservations *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"WorkWithReservation"];
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
    NSLog(@"Обновление таблицы с уроками");
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
