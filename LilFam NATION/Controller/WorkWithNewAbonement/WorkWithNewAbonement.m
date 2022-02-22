//
//  WorkWithNewAbonement.m
//  LilFam NATION
//
//  Created by Daniil Savva on 06.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "WorkWithNewAbonement.h"
#import "GlobalVariables.h"
#import "DAO.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h>

#import <PassKit/PassKit.h>

@interface WorkWithNewAbonement () <PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation WorkWithNewAbonement {
    NSMutableArray *array_with_info_of_abonement;
    NSMutableArray *array_with_labels;
    NSMutableString *how_much_money;
    BOOL *paymentApplePay;
}
@synthesize abonementsTable, btnBuy, btnApplePay;

- (void)viewDidLoad {
    [super viewDidLoad];
    btnBuy.layer.cornerRadius = 10;
    btnApplePay.layer.cornerRadius = 10;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succeessPaymentRobokassa:)  name:@"succeessPaymentRobokassa" object:nil];
    
    /*
    PKPaymentButton *payButton = [[PKPaymentButton alloc] initWithPaymentButtonType:PKPaymentButtonTypeBuy paymentButtonStyle:PKPaymentButtonStyleBlack];
    payButton.frame = CGRectMake(0, 0, self.view.frame.size.width - 40, 44);
    payButton.center = self.view.center;
    [self.view addSubview:payButton];
    
    [payButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void) succeessPaymentRobokassa:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"succeessPaymentRobokassa"]){
        [self continueClosingAfterPayment];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self reloadAbonement];
}
- (void)appDidBecomeActive:(NSNotification *)notification {
    if(paymentApplePay){
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self dismissViewControllerAnimated:NO completion:^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"applePayPayment" object:self];
        }];
    }
}


-(void)continueClosingAfterPayment {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"succeessPayment" object:self];
    }];
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

-(IBAction)refreshTable {
    [self reloadAbonement];
}

-(void)reloadAbonement {

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
            
    
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_get_info_about_buyed_abonement.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_group=%@&id_base_of_abonement=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].global_id_of_group , [GlobalVariables sharedInstance].g_id_base_of_abonement];
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
                    

                    self->array_with_info_of_abonement = [jsonDict2 objectForKey:@"array_with_info_of_abonement"];
                    self->array_with_labels = [jsonDict2 objectForKey:@"array_with_labels"];
                    self->how_much_money = [jsonDict2 objectForKey:@"how_much_money"];

                    if([self -> how_much_money isEqualToString:@"0"]){
                        [btnBuy setTitle:@"Записаться" forState:UIControlStateNormal];
                    }
                    
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
    return [array_with_labels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"abonementTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    //NSLog(@"Проверяем номер ячейки %ld",(long)indexPath.row);
    cell.textLabel.text = [array_with_labels objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [array_with_info_of_abonement objectAtIndex:indexPath.row];
    return cell;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
              withRowAnimation:(UITableViewRowAnimation)animation {
    NSLog(@"Обновление таблицы с абонементом");
}


-(IBAction)btnApplePayClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Перенаправлеие" message:@"Вы будете перенаправлены на сайт оплаты, нажмите пожалуйста на странице оплаты вкладку Apple Pay" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ок" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self openBuyBrowser];
    }];
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:okAction];
    [alert addAction:closeAction];
    dispatch_async(dispatch_get_main_queue(), ^(void){
         [self presentViewController:alert animated:true completion:nil];
    });
}
-(void)openBuyBrowser {
    
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

            paymentApplePay = YES;
            
            NSURL* url = [[NSURL alloc] initWithString: [NSString stringWithFormat: @"https://lilfam.com/application/user_begin_payment_get.php?a=%@&b=%@&id_of_group=%@&id_base_of_abonement=%@&date_of_action=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].global_id_of_group , [GlobalVariables sharedInstance].g_id_base_of_abonement, [GlobalVariables sharedInstance].global_date_of_action]];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
            
        }
    }
}


- (IBAction)pay:(id)sender
{
    if([how_much_money isEqualToString:@"0"]){
        
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
                
        
                NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user_take_free.php",[GlobalVariables sharedInstance].global_url]];
                NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
                [urlRequest_profile setHTTPMethod:@"POST"];
                NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_group=%@&id_base_of_abonement=%@&date_of_action=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].global_id_of_group , [GlobalVariables sharedInstance].g_id_base_of_abonement, [GlobalVariables sharedInstance].global_date_of_action];
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
                        
                        if([[jsonDict2 objectForKey:@"answer"] isEqualToString:@"success"]){

                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Выполнено" message:@"Покупка товара прошла успешно" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                                [self continueClosingAfterPayment];
                            }];
                            [alert addAction:okAction];
                            dispatch_async(dispatch_get_main_queue(), ^(void){
                                 [self presentViewController:alert animated:true completion:nil];
                            });
                            
                        } else {
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleActionSheet];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
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
        
        
    } else {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WorkWithNewAbonement *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"WorkWithPaymentRobokassa"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentModalViewController:vc animated:NO];
    }
    
    
    
    /*
    if ([PKPaymentAuthorizationViewController canMakePayments]){
        NSLog(@"Платежи доступны!");
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        
        
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:[GlobalVariables sharedInstance].g_new_ab_name amount:[NSDecimalNumber decimalNumberWithString:[GlobalVariables sharedInstance].g_new_ab_cost]];
        
        request.paymentSummaryItems = @[total];
        request.countryCode = @"RU";
        request.currencyCode = @"RUB";
        request.supportedNetworks = @[PKPaymentNetworkAmex,PKPaymentNetworkMasterCard,PKPaymentNetworkVisa];
        request.merchantIdentifier = @"merchant.dsapplepayexample";
        request.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV | PKMerchantCapabilityCredit | PKMerchantCapabilityDebit;
        PKPaymentAuthorizationViewController *paymentpane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentpane.delegate = self;
        [self presentViewController:paymentpane animated:TRUE
                           completion:nil];
    }else {
        NSLog(@"Устройство не может оплатить!");
    }
    */
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    NSLog(@"Payment произведен: %@", payment);
    
    BOOL asyncSuccessful = TRUE;
    
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        NSLog(@"Успешно");
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        NSLog(@"Платеж провален");
    }
    
}

-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"Платеж завершен");
    [controller dismissViewControllerAnimated:true completion:nil];
    
    [self successPayment];
}



-(void)successPayment {
    
    
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
            
    
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_buy_abonement.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_group=%@&id_base_of_abonement=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].global_id_of_group , [GlobalVariables sharedInstance].g_id_base_of_abonement];
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
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка на стороне сервера" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alert addAction:okAction];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                         [self presentViewController:alert animated:true completion:nil];
                    });
                } else {
                    NSLog(@"%@",jsonDict2);
                    

                   CATransition *transition = [CATransition animation];
                   transition.duration = 0.3;
                   transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                   transition.type = kCATransitionPush;
                   transition.subtype = kCATransitionFromLeft;
                   [self.view.window.layer addAnimation:transition forKey:nil];
                   [self dismissViewControllerAnimated:NO completion:^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"succeessPayment" object:self];
                   }];
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
