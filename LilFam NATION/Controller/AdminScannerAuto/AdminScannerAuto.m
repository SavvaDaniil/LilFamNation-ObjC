//
//  AdminScannerAuto.m
//  LilFam NATION
//
//  Created by Daniil Savva on 21.01.2020.
//  Copyright © 2020 Daniil Savva. All rights reserved.
//

#import "AdminScannerAuto.h"
#import "GlobalVariables.h"
#import "DAO.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h>

@interface AdminScannerAuto ()

@end

@implementation AdminScannerAuto {
    NSMutableString *resultScanner;
    
    NSMutableString *c;
    NSMutableString *date_of_action;
    NSMutableString *id_of_group;
    NSMutableString *name_of_group;
    NSMutableString *fio_of_client;
    NSMutableString *id_of_notes;
    NSMutableString *app_check;
}
@synthesize audioPlayerSuccess, audioPlayerError;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //чтобы экран не гас
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"mp3"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    NSError *error;
    audioPlayerSuccess = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL  error:&error];
    audioPlayerSuccess.delegate = self;
    audioPlayerSuccess.numberOfLoops = 0;
    [audioPlayerSuccess prepareToPlay];
    
    NSString *soundFilePath2 = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"mp3"];
    NSURL *soundFileURL2 = [NSURL fileURLWithPath:soundFilePath2];
    NSError *error2;
    audioPlayerError = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL2  error:&error2];
    audioPlayerError.delegate = self;
    audioPlayerError.numberOfLoops = 0;
    [audioPlayerError prepareToPlay];
}
- (IBAction)btnClose:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"exit_from_scanner" object:self];
    }];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self startReading];
}



/* РАБОТА СО СКАНЕРОМ */

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    _isReading = FALSE;
}

-(void)startReading{
    
    _captureSession = nil;
    _isReading = TRUE;
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (captureDevice.position == AVCaptureDevicePositionBack) {
        NSLog(@"back camera");
    }else if (captureDevice.position == AVCaptureDevicePositionFront){
        NSLog(@"Front Camera");
    }else{
        NSLog(@"Unspecified");
    }
    
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input)
    {
        NSLog(@"%@", [error localizedDescription]);
        //return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewforCamera.layer.bounds];
    [_viewforCamera.layer addSublayer:_videoPreviewLayer];
    [_captureSession startRunning];
}



-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        //NSString* result_of_scanner = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [self stopReading];
            _isReading = NO;
            NSLog(@"%@",metadataObj);
            resultScanner = [NSMutableString stringWithFormat:@"%@",[(AVMetadataMachineReadableCodeObject *)metadataObj stringValue]];
            
            //[self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:YES];
            
            //[self performSelectorOnMainThread:@selector(workwithresultofscanner) withObject:nil waitUntilDone:YES];
            //[self workwithresultofscanner];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self workwithresultofscanner];
            });
        }
        
    }
    
}

-(void)workwithresultofscanner{
    
    NSLog(@"resultScanner IS %@", resultScanner);
    NSData *data = [resultScanner dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    /*
    NSError *jsonError_qr_code;
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError_qr_code];
    if (jsonError_qr_code != nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"В QR-code не удалось распознать зашифрованные данные" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self try_to_restart_scanner];
        }];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
    }
     */
    
    NSString * id_of_client_from_server = [json objectForKey:@"a"];
    NSString * qr_code_from_server = [json objectForKey:@"b"];
    NSLog(@"id_of_user from server IS %@", id_of_client_from_server);
    NSLog(@"qr_code from server IS %@", qr_code_from_server);
    

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
        [self Alert_show_error:@"Ошибка связи с сервером" auto_relaunch_scanner:@"1"];
    } else {
        NSLog(@"%@", [[NSString alloc] initWithData:responseData_profile encoding:NSASCIIStringEncoding]);
        
        NSError *jsonError;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError != nil) {
            [self Alert_show_error:@"Ошибка на стороне сервера" auto_relaunch_scanner:@"1"];
        } else {
            NSLog(@"%@",jsonDict);
            
            NSString *random = [jsonDict objectForKey:@"a"];
            NSString *key_access_hash = [key_access_from_server md5];
            NSString *random_hash = [random md5];
            NSString *key_and_random = [NSString stringWithFormat:@"%@%@",key_access_hash,random_hash];
            NSString *check = [NSMutableString stringWithFormat:@"%@XXXXXXXXXXXXXXXXXXXXXX",key_and_random];
            NSString *check_hash = [check md5];
            
    
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_work_with_user_in_group_admin_QR.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_client=%@&qr_code=%@&data=%@",id_of_user, check_hash, id_of_client_from_server, qr_code_from_server, [GlobalVariables sharedInstance].admin_id_of_group_with_date_of_action];
            NSData *data_profile = [userUpdate_profile dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest_profile setHTTPBody:data_profile];
            NSLog(@"userUpdate_profile = %@",userUpdate_profile);
            
            
            NSError *error_profile = nil;
            NSHTTPURLResponse *responceCode_profile = nil;
            NSData *responseData_profile = [NSURLConnection sendSynchronousRequest:urlRequest_profile returningResponse:&responceCode_profile error:&error_profile];
            if (error_profile) {
                [self Alert_show_error:@"Ошибка на стороне сервера" auto_relaunch_scanner:@"1"];
            } else {
                NSLog(@"%@", [[NSString alloc] initWithData:responseData_profile encoding:NSASCIIStringEncoding]);
                
                NSError *jsonError_profile;
                NSDictionary * jsonDict2 = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError_profile];
                if (jsonError_profile != nil) {
                    //NSLog(@"JSON isn't right:%@",jsonError);
                    [self Alert_show_error:@"Ошибка на стороне сервера" auto_relaunch_scanner:@"1"];
                } else {
                    NSLog(@"%@",jsonDict2);
                    /*
                    self->array_of_clients = [jsonDict2 objectForKey:@"array_of_clients"];
                    self->nameGroup.text = [jsonDict2 objectForKey:@"name_of_group"];
                    self->count_clients.text = [NSString stringWithFormat:@"Количество: %@",[jsonDict2 objectForKey:@"schetchik_of_clients"]];
                    self->payment.text = [NSString stringWithFormat:@"Зарплата: %@ рублей",[jsonDict2 objectForKey:@"how_much_money_fact"]];
                    self->c = [NSMutableString stringWithFormat:@"%@",[jsonDict2 objectForKey:@"c"]];
                    self->date_of_action = [jsonDict2 objectForKey:@"date_of_action"];
                    */
                    
                    
                    if([[jsonDict2 objectForKey:@"error"] isEqualToString:@"wrong_code"]){
                        [self Alert_show_error:@"QR-код неверен или уже использован" auto_relaunch_scanner:@"1"];
                        return;
                    }
                    if([[jsonDict2 objectForKey:@"error"] isEqualToString:@"no_action"]){
                        [self Alert_show_error:@"Пользователь не отмечался на занятие" auto_relaunch_scanner:@"1"];
                        return;
                    }
                    if([[jsonDict2 objectForKey:@"c"] isEqualToString:@"0"]){
                        [self Alert_show_error:@"Извините, вы не подключены к данной группе" auto_relaunch_scanner:@"1"];
                        return;
                    }
                    
                    
                    
                    
                    self->id_of_notes = [jsonDict2 objectForKey:@"id_of_notes"];
                    
                    self->c = [NSMutableString stringWithFormat:@"%@",[jsonDict2 objectForKey:@"c"]];
                    self->date_of_action = [jsonDict2 objectForKey:@"date_of_action"];
                    self->id_of_group = [jsonDict2 objectForKey:@"id_of_group"];
                    self->name_of_group = [jsonDict2 objectForKey:@"name_of_group"];
                    self->fio_of_client = [jsonDict2 objectForKey:@"fio"];
                    self->app_check = [jsonDict2 objectForKey:@"app_check"];
                    
                    
                    NSString *alert_description = [NSString stringWithFormat:@"Группа: %@ \nФИО: %@ \n\nДата занятия: %@\nАбонемент: %@\nДата записи на занятие: %@ \n\n Дата активации: %@ \n Изначально занятий: %@ \n\n Использовать до: %@ \nСколько осталось: %@", [jsonDict2 objectForKey:@"name_of_group"],[jsonDict2 objectForKey:@"fio"],[jsonDict2 objectForKey:@"date_of_action"],[jsonDict2 objectForKey:@"name_of_abonement"], [jsonDict2 objectForKey:@"normal_date_time_of_buy"],[jsonDict2 objectForKey:@"date_of_activation"],[jsonDict2 objectForKey:@"skolko_iznachalno_zanyatiy"],[jsonDict2 objectForKey:@"date_to_must_be_used"],[jsonDict2 objectForKey:@"ostalos"]];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Результат запроса" message:alert_description preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *close = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                        [self try_to_restart_scanner];
                    }];
                    
                    UIAlertAction *app_check_change_not_check = [UIAlertAction actionWithTitle:@"Сменить статус на НЕ УЧТЕН" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                        [self try_to_restart_scanner];
                        [self app_check_change];
                    }];
                    
                    
                    
                    NSString *reservation_auto0_prepod1 = [NSString stringWithFormat:@"%@",[jsonDict2 objectForKey:@"reservation_auto0_prepod1"]];
                    NSString *reservation = [NSString stringWithFormat:@"%@",[jsonDict2 objectForKey:@"reservation"]];
                    if([c isEqualToString:@"1"]){
                        if([reservation_auto0_prepod1 isEqualToString:@"1"]){
                            if([reservation isEqualToString:@"1"]){
                                [self accept_reservation];
                            }
                        } else if([reservation_auto0_prepod1 isEqualToString:@"0"]){
                            if([app_check isEqualToString:@"0"]){
                                [self app_check_change];
                            } else if([app_check isEqualToString:@"1"]){
                                [alert addAction:app_check_change_not_check];
                                [alert addAction:close];
                                dispatch_async(dispatch_get_main_queue(), ^(void){
                                     [self presentViewController:alert animated:true completion:nil];
                                });
                            }
                        }
                    }
                    if([c isEqualToString:@"2"]){
                        if([reservation_auto0_prepod1 isEqualToString:@"1"]){
                            if([reservation isEqualToString:@"1"]){
                                [self accept_reservation];
                            } else if([reservation isEqualToString:@"2"]){
                                [self Alert_show_error:@"Клиент уже отмечен" auto_relaunch_scanner:@"1"];
                           }
                        } else if([reservation_auto0_prepod1 isEqualToString:@"0"]){
                            if([app_check isEqualToString:@"0"]){
                                [self app_check_change];
                            } else if([app_check isEqualToString:@"1"]){
                                [alert addAction:app_check_change_not_check];
                                [alert addAction:close];
                                dispatch_async(dispatch_get_main_queue(), ^(void){
                                     [self presentViewController:alert animated:true completion:nil];
                                });
                            }
                        }
                    }
                    
                    
                }
            }
            
            
        }
    }
}

-(void)try_to_restart_scanner {
    if(self->_isReading == NO || _isReading == NO){
        _isReading = YES;
        [self startReading];
    }
}

-(void)Alert_show_error:(NSString *) description auto_relaunch_scanner:(NSString *)auto_relaunch_scanner {
    [audioPlayerError play];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:description preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self try_to_restart_scanner];
    }];
    if(![auto_relaunch_scanner isEqualToString:@"1"]){
        [alert addAction:okAction];
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
         [self presentViewController:alert animated:true completion:nil];
    });
    

    if([auto_relaunch_scanner isEqualToString:@"1"]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:^{
                [self try_to_restart_scanner];
            }];
        });
    }
}

-(void)Alert_show_success:(NSString *) description auto_relaunch_scanner:(NSString *)auto_relaunch_scanner {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Успешно" message:description preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //[self try_to_restart_scanner];
    }];
    if(![auto_relaunch_scanner isEqualToString:@"1"]){
        [alert addAction:okAction];
    }
    dispatch_async(dispatch_get_main_queue(), ^(void){
         [self presentViewController:alert animated:true completion:nil];
    });
    

    if([auto_relaunch_scanner isEqualToString:@"1"]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:^{
                [self try_to_restart_scanner];
            }];
        });
    }
}


-(void)accept_reservation {
    
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
        [self Alert_show_error:@"Ошибка связи с сервером" auto_relaunch_scanner:@"1"];
    } else {
        NSLog(@"%@", [[NSString alloc] initWithData:responseData_profile encoding:NSASCIIStringEncoding]);
        
        NSError *jsonError;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError != nil) {
            [self Alert_show_error:@"Ошибка на стороне сервера" auto_relaunch_scanner:@"1"];
        } else {
            NSLog(@"%@",jsonDict);
            
            
            NSString *random = [jsonDict objectForKey:@"a"];
            NSString *key_access_hash = [key_access_from_server md5];
            NSString *random_hash = [random md5];
            NSString *key_and_random = [NSString stringWithFormat:@"%@%@",key_access_hash,random_hash];
            NSString *check = [NSMutableString stringWithFormat:@"%@XXXXXXXXXXXXXXXXXXXXXX",key_and_random];
            NSString *check_hash = [check md5];
            
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_accept_reservation.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_notes=%@",id_of_user, check_hash, id_of_notes];
            NSData *data_profile = [userUpdate_profile dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest_profile setHTTPBody:data_profile];
            //NSLog(@"Отправляемые параметры %@",userUpdate_profile);
            
            NSError *error_profile = nil;
            NSHTTPURLResponse *responceCode_profile = nil;
            NSData *responseData_profile = [NSURLConnection sendSynchronousRequest:urlRequest_profile returningResponse:&responceCode_profile error:&error_profile];
            if (error_profile) {
                [self Alert_show_error:@"Ошибка связи с сервером" auto_relaunch_scanner:@"1"];
            } else {
                NSLog(@"%@", [[NSString alloc] initWithData:responseData_profile encoding:NSASCIIStringEncoding]);
                
                NSError *jsonError_profile;
                NSDictionary * jsonDict_profile = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError_profile];
                if (jsonError_profile != nil) {
                    //NSLog(@"JSON isn't right:%@",jsonError);
                    [self Alert_show_error:@"Ошибка на стороне сервера" auto_relaunch_scanner:@"1"];
                } else {
                    NSLog(@"%@",jsonDict_profile);
                    
                    
                    if([[jsonDict_profile objectForKey:@"error"] isEqualToString:@"5"]){
                        [self Alert_show_error:@"Неизвестная ошибка. сообщите пожалуйста разработчику."  auto_relaunch_scanner:@"0"];
                    }
                    
                    if([[jsonDict_profile objectForKey:@"a"] isEqualToString:@"1"]){
                        [audioPlayerSuccess play];
                        [self Alert_show_success:@"Клиент отмечен успешно" auto_relaunch_scanner:@"1"];
                    }
                    
                    
                    
                }
            }
            
            
        }
    }
}

-(void)app_check_change {
    
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
            
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_change_app_check_main_table_ADMIN.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&id_of_notes=%@",id_of_user, check_hash, id_of_notes];
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
                        [audioPlayerSuccess play];
                    }
                    [self try_to_restart_scanner];
                }
            }
        }
    }
}





@end
