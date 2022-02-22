//
//  MyAbonementsHistory.m
//  LilFam NATION
//
//  Created by Daniil Savva on 20.01.2020.
//  Copyright © 2020 Daniil Savva. All rights reserved.
//

#import "MyAbonementsHistory.h"
#import "DAO.h"
#import "GlobalVariables.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h>
#import "SceneDelegate.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface MyAbonementsHistory ()

@end

@implementation MyAbonementsHistory {
    
    NSMutableString *count_of_purchases;
    NSMutableArray *array_count_notes_and_id_of_abonements;
    NSDictionary *array_with_info_of_abonements;
    NSMutableArray *array_with_info_of_abonements2;
    
    NSMutableString *app_time_minutes_blocked_return_for_group_add_zanyatie_by_auto;
}

@synthesize abonementsTable, btnBuyNewAbonement;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    btnBuyNewAbonement.layer.cornerRadius = 10;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exit_from_abonements_for_buy:)  name:@"exit_from_abonements_for_buy" object:nil];
}
- (void) exit_from_abonements_for_buy:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"exit_from_abonements_for_buy"]){
        //обновляем таблицу
        
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self reloadMyAbonements];
}
- (IBAction)btnMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(IBAction)clickbtnBuyNewAbonement:(id)sender {
    //убираю пока оплату в этой версии
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyAbonementsHistory *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"AbonementsForBuy"];
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
    [GlobalVariables sharedInstance].global_id_of_group = [NSMutableString stringWithString:@"0"];

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
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_group=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].global_id_of_group];
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
                    
                    /*
                    self->count_of_purchases = [jsonDict2 objectForKey:@"count_of_purchases"];
                    self->array_count_notes_and_id_of_abonements = [jsonDict2 objectForKey:@"array_count_notes_and_id_of_abonements"];
                    self->array_with_info_of_abonements = [jsonDict2 objectForKey:@"array_with_info_of_abonements"];
                    */
                    self->array_with_info_of_abonements2 = [jsonDict2 objectForKey:@"array_with_info_of_abonements2"];
                    
                    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [array_with_info_of_abonements2 count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Обновляем таблицу с абонементами");
    static NSString *simpleTableIdentifier = @"abonementsTable";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    
    NSLog(@"Проверяем номер ячейки %ld",(long)indexPath.row);
    
    
    NSString *id_of_notes = [NSString stringWithFormat:@"%@", [[array_with_info_of_abonements2 objectAtIndex:indexPath.row] valueForKey:@"id_of_notes"]];
    
    /*
    cell.labelNameOfAbonement.text = [[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"name_of_abonement"];
    
    cell.labelDescriptionOfAbonement.text = [NSString stringWithFormat:@"Осталось %@ из %@ / куп. %@",[[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"ostalos"],[[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"skolko_iznachalno_zanyatiy"],[[array_with_info_of_abonements valueForKey:id_of_notes] valueForKey:@"date_of_buy_to_show"]];
    
    
    cell.textLabel.text = id_of_notes;
    cell.textLabel.hidden = true;
    */
    
    cell.textLabel.text = [[array_with_info_of_abonements2 objectAtIndex:indexPath.row] valueForKey:@"name_of_abonement"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Осталось %@ из %@ / куп. %@",[[array_with_info_of_abonements2 objectAtIndex:indexPath.row] valueForKey:@"ostalos"],[[array_with_info_of_abonements2 objectAtIndex:indexPath.row] valueForKey:@"skolko_iznachalno_zanyatiy"],[[array_with_info_of_abonements2 objectAtIndex:indexPath.row] valueForKey:@"date_of_buy_to_show"]];
    
    if([[[array_with_info_of_abonements2 objectAtIndex:indexPath.row] valueForKey:@"status"] isEqualToString:@"0"]){
        cell.textLabel.textColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell.backgroundColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *id_of_notes = [NSString stringWithFormat:@"%@", [[array_with_info_of_abonements2 objectAtIndex:indexPath.row] valueForKey:@"id_of_notes"] ];
    NSLog(@"Был выбран пункт %@",id_of_notes);
    
    [GlobalVariables sharedInstance].history_id_of_notes = [NSMutableString stringWithString:id_of_notes];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyAbonementsHistory *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"WorkWithAbonementHistory"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentModalViewController:vc animated:NO];
     
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return CGFLOAT_MIN;
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
              withRowAnimation:(UITableViewRowAnimation)animation {
    NSLog(@"Обновление таблицы с абонементами");
}






@end
