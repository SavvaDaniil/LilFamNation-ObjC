//
//  Profile.m
//  LilFam NATION
//
//  Created by Daniil Savva on 17.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "Profile.h"

#import "ProfileData.h"
#import "GlobalVariables.h"
#import "DAO.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h> 


@interface Profile ()

@end

@implementation Profile {
    NSMutableArray *profileTableContent;
    
    NSMutableString *fio;
    NSMutableString *mail;
    NSMutableString *phone;
    NSMutableString *birthday;
    NSMutableString *gender;
    NSMutableString *parent_fio;
    NSMutableString *parent_phone;
    NSMutableString *minor;
}
@synthesize profileTable, btnSave;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnSave.layer.cornerRadius = 10;
    
    
    //profileTableContent = [NSArray arrayWithObjects:@"ФИО",@"Почта",@"Телефон",@"Пол",@"Дата рождения",@"ФИО родителя",@"Телефон родителя",nil];
    //profileTableContent = [NSArray arrayWithObjects:@"ФИО",@"Почта",@"Телефон",@"Пол",@"Дата рождения",nil];
    
    //для отлова закрытия других окно
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProfile:)  name:@"changeProfile" object:nil];
    
    [GlobalVariables sharedInstance].g_already_load_profile = [NSMutableString stringWithString:@"0"];
    /*
    UIImage* image_tab_bar_menu = [UIImage imageNamed:@"arrowshape.turn.up.left.fill"];
    CGRect frameimg = CGRectMake(0, 0, image_tab_bar_menu.size.width, image_tab_bar_menu.size.height);
    UIButton *viewLeftMenuButton = [[UIButton alloc] initWithFrame:frameimg];
    [viewLeftMenuButton setBackgroundImage:image_tab_bar_menu forState:UIControlStateNormal];
    [viewLeftMenuButton addTarget:self action:@selector(btnClose:)
         forControlEvents:UIControlEventTouchUpInside];
    [viewLeftMenuButton setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *LeftMenuButton =[[UIBarButtonItem alloc] initWithCustomView:viewLeftMenuButton];
    self.navigationItem.leftBarButtonItem = LeftMenuButton;
     */
    
    //проверяем регистрацию
    DAO *code_for_all = [DAO alloc];
    code_for_all = [code_for_all init];
    NSString *check_of_registration = [code_for_all check_registration_in_ios];
    
    if([check_of_registration isEqualToString:@"0"]){
        [GlobalVariables sharedInstance].status_of_registration = [NSMutableString stringWithString:@"0"];
        NSLog(@"ПРОВЕРКА НА РЕГИСТРАЦИЮ ПРОВАЛИЛАСЬ");
        //проводим регистрацию
        /*
        Registration *Registration1 = [Registration alloc];
        Registration1 = [Registration1 init];
        [Registration1 registration];
         */
    }
    if([check_of_registration isEqualToString:@"1"]){
        //запускаем загрузку нужных строк с сервера
        
        
        

        
    }

}
- (void) changeProfile:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"changeProfile"])
        [profileTable reloadData];
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
-(IBAction)btnSave:(UIButton *)btnSave{
    //NSString *secondContrllerText = [[NSUserDefaults standardUserDefaults] stringForKey:@"profilefield0"];
    //NSLog(@"Перехваченное значение из поля %@",secondContrllerText);
    
    
     
    if([[GlobalVariables sharedInstance].g_already_load_profile isEqualToString:@"1"]){

        for(int i=0;i<=2;i++){
            ProfileData *cell = [profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if(i == 0){
                [GlobalVariables sharedInstance].g_fio = [NSMutableString stringWithString:cell.fieldProfileData.text];
            }
            if(i == 1){
                [GlobalVariables sharedInstance].g_mail = [NSMutableString stringWithString:cell.fieldProfileData.text];
            }
            if(i == 2){
                [GlobalVariables sharedInstance].g_phone = [NSMutableString stringWithString:cell.fieldProfileData.text];
            }
            NSLog(@"Перехваченное значение из поля %@",cell.fieldProfileData.text);
        }
        if([[GlobalVariables sharedInstance].g_minor isEqualToString:@"1"]){
            for(int i=6;i<=7;i++){
                ProfileData *cell = [profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if(i == 6){
                    [GlobalVariables sharedInstance].g_parent_fio = [NSMutableString stringWithString:cell.fieldProfileData.text];
                }
                if(i == 7){
                    [GlobalVariables sharedInstance].g_parent_phone = [NSMutableString stringWithString:cell.fieldProfileData.text];
                }
                NSLog(@"Перехваченное значение из поля %@",cell.fieldProfileData.text);
            }
        }
        
        /*
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Идёт сохранение..." preferredStyle:UIAlertControllerStyleAlert];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
         //[self dismissViewControllerAnimated:NO completion:Nil];
         */

        DAO *code_profile = [DAO alloc];
        code_profile = [code_profile init];
        NSString *id_of_user = [code_profile select_value_1_from_DB:@"id_of_user"];
        NSString *key_access_from_server = [code_profile select_value_1_from_DB:@"key_access"];
        
        
        //NSURL *url_profile = [NSURL URLWithString:@"https://fame-application.com/lilfamnation/application/first_step.php"];
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
                
                //NSURL *url_profile = [NSURL URLWithString:@"https://fame-application.com/lilfamnation/application/save_profile.php"];
                NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/save_profile.php",[GlobalVariables sharedInstance].global_url]];
                NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
                [urlRequest_profile setHTTPMethod:@"POST"];
                NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@&fio=%@&phone=%@&mail=%@&gender=%@&birthday=%@&parent_fio=%@&parent_phone=%@",id_of_user, check_hash, [GlobalVariables sharedInstance].g_fio , [GlobalVariables sharedInstance].g_phone , [GlobalVariables sharedInstance].g_mail , [GlobalVariables sharedInstance].g_gender , [GlobalVariables sharedInstance].g_birthday , [GlobalVariables sharedInstance].g_parent_fio , [GlobalVariables sharedInstance].g_parent_phone];
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
                    NSDictionary * jsonDict_profile = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError_profile];
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
                        NSLog(@"%@",jsonDict_profile);
                        
                        if([[jsonDict_profile objectForKey:@"wrong_mail"] isEqualToString:@"1"]){

                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Указанный email уже существует" preferredStyle:UIAlertControllerStyleActionSheet];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                            }];
                            [alert addAction:okAction];
                            dispatch_async(dispatch_get_main_queue(), ^(void){
                                 [self presentViewController:alert animated:true completion:nil];
                            });
                            
                        } else if(![[GlobalVariables sharedInstance].g_minor isEqualToString:[jsonDict_profile objectForKey:@"minor"]]){
                            NSLog(@"Обнаружен несовершеннолетний");
                            [self loadProfile];
                        }
                        
                        
                    }
                }
                
                
            }
        }
        
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Обновите пожалуйста данные" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:NULL];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if([[GlobalVariables sharedInstance].profileNotFill isEqualToString:@"1"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Заполните пожалуйста недостающие поля" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:NULL];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
        [GlobalVariables sharedInstance].profileNotFill = [NSMutableString stringWithString:@"0"];
    }
    
    if([[GlobalVariables sharedInstance].g_already_load_profile isEqualToString:@"0"])
        [self loadProfile];
    
    
    
    
    
    /*
    NSURL *url = [NSURL URLWithString:@"https://fame-application.com/lilfamnation/application/first_step.php"];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *params = @"a=1&";
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    request.HTTPMethod = @"POST";
    NSDictionary *dictionary = @{@"a": @"1"};
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];
    if (!error) {
     NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
       fromData:data completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {

         if (error) {
             NSLog(@"dataTaskWithRequest error: %@", error);
         } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
             NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
             if (statusCode != 200) {
                 NSLog(@"Expected responseCode == 200; received %ld", (long)statusCode);
             } else{
                 NSError *parseError;
                 id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                 NSLog(@"else condtion");
                 if (!responseObject) {
                     NSLog(@"JSON parse error: %@", parseError);
                 } else {
                     NSLog(@"responseObject = %@", responseObject);
                 }
                 //if response was text/html, you might convert it to a string like so:
                 // ---------------------------------
                 NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 NSLog(@"final responseString = %@", responseString);
             }
         }
         
       }];

       // 5
       [uploadTask resume];
    }
    */
    
    /*
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://fame-application.com/lilfamnation/application/first_step.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithObjectsAndKeys: @"a", @"1",  @"1", @"a",  nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"dataTaskWithRequest error: %@", error);
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Expected responseCode == 200; received %ld", (long)statusCode);
            } else{
                NSError *parseError;
                id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                NSLog(@"else condtion");
                if (!responseObject) {
                    NSLog(@"JSON parse error: %@", parseError);
                } else {
                    NSLog(@"responseObject = %@", responseObject);
                }
                //if response was text/html, you might convert it to a string like so:
                // ---------------------------------
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"final responseString = %@", responseString);
            }
        }
    }];

    [postDataTask resume];
    */
    
    /*
    NSDictionary *mainDictionary = [NSDictionary dictionaryWithObjectsAndKeys: @"1",@"a", @"1284",@"SearchKey", nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://fame-application.com/lilfamnation/application/first_step.php"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    //[request setHTTPBody:[NSKeyedArchiver archivedDataWithRootObject:mainDictionary]];

    //You now can initiate the request with NSURLSession or NSURLConnection, however you prefer. For example, with NSURLSession, you might do:
    NSDictionary *dictionary = @{@"a": @"1"};
    NSError *error = nil;
    NSData *data_post = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&error];


    NSURLSessionTask *task = [[NSURLSession sharedSession] uploadTaskWithRequest:request
    fromData:data_post completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"dataTaskWithRequest error: %@", error);
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"Expected responseCode == 200; received %ld", (long)statusCode);
            } else{
                NSError *parseError;
                id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                NSLog(@"else condtion");
                if (!responseObject) {
                    NSLog(@"JSON parse error: %@", parseError);
                } else {
                    NSLog(@"responseObject = %@", responseObject);
                }
                //if response was text/html, you might convert it to a string like so:
                // ---------------------------------
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"final responseString = %@", responseString);
            }
        }
    }];

    [task resume];
    */
}


-(void)loadProfile {
    NSLog(@"Запуск loadProfile");
    
    DAO *code_profile = [DAO alloc];
    code_profile = [code_profile init];
    NSString *id_of_user = [code_profile select_value_1_from_DB:@"id_of_user"];
    NSString *key_access_from_server = [code_profile select_value_1_from_DB:@"key_access"];
    
    
    
    //NSURL *url_profile = [NSURL URLWithString:@"https://fame-application.com/lilfamnation/application/first_step.php"];
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
        NSLog(@"2424");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
    } else {
        NSLog(@"3535");
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
            
            NSLog(@"key_access_from_server = %@",key_access_from_server);
            NSLog(@"random = %@",random);
            NSLog(@"key_access_hash = %@",key_access_hash);
            NSLog(@"random_hash = %@",random_hash);
            NSLog(@"check = %@",check);
            NSLog(@"check_hash = %@",check_hash);
            
            //NSURL *url_profile = [NSURL URLWithString:@"https://fame-application.com/lilfamnation/application/profile.php"];
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/profile.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@",id_of_user, check_hash];
            NSData *data_profile = [userUpdate_profile dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest_profile setHTTPBody:data_profile];
            
            
            NSError *error_profile = nil;
            NSHTTPURLResponse *responceCode_profile = nil;
            NSData *responseData_profile = [NSURLConnection sendSynchronousRequest:urlRequest_profile returningResponse:&responceCode_profile error:&error_profile];
            if (error_profile) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером 3" preferredStyle:UIAlertControllerStyleActionSheet];
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
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером 4" preferredStyle:UIAlertControllerStyleActionSheet];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    }];
                    [alert addAction:okAction];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                         [self presentViewController:alert animated:true completion:nil];
                    });
                } else {
                    NSLog(@"%@",jsonDict_profile);
                    
                    
                    if([[jsonDict_profile objectForKey:@"error"] isEqualToString:@"5"]){
                        [code_profile clear_DB];
                        [self closeView];
                        return;
                    }
                    
                    NSMutableString *birthday_from_server = [NSMutableString stringWithString:@"2001-01-01"];
                    if([[jsonDict_profile objectForKey:@"birthday"] isEqual:@"0000-00-00"]){
                        birthday_from_server = [NSMutableString stringWithString:@"2001-01-01"];
                    } else {
                        birthday_from_server = [jsonDict_profile objectForKey:@"birthday"];
                    }
                    
                    [GlobalVariables sharedInstance].g_fio = [jsonDict_profile objectForKey:@"fio"];
                    [GlobalVariables sharedInstance].g_mail = [jsonDict_profile objectForKey:@"mail"];
                    [GlobalVariables sharedInstance].g_phone = [jsonDict_profile objectForKey:@"phone"];
                    [GlobalVariables sharedInstance].g_birthday = birthday_from_server;
                    [GlobalVariables sharedInstance].g_minor = [jsonDict_profile objectForKey:@"minor"];
                    [GlobalVariables sharedInstance].g_gender = [jsonDict_profile objectForKey:@"gender"];
                    [GlobalVariables sharedInstance].g_parent_fio = [jsonDict_profile objectForKey:@"parent_fio"];
                    [GlobalVariables sharedInstance].g_parent_phone = [jsonDict_profile objectForKey:@"parent_phone"];
                    
                    if([[jsonDict_profile objectForKey:@"minor"] isEqualToString:@"1"]){
                        profileTableContent = [NSMutableArray arrayWithObjects:@"ФИО",@"Почта",@"Телефон",@"Сменить пароль",@"Пол",@"Дата рождения",@"ФИО родителя",@"Телефон родителя",nil];
                    } else {
                        profileTableContent = [NSMutableArray arrayWithObjects:@"ФИО",@"Почта",@"Телефон",@"Сменить пароль",@"Пол",@"Дата рождения",nil];
                    }
                    
                    [GlobalVariables sharedInstance].g_already_load_profile = [NSMutableString stringWithString:@"1"];
                    [profileTable reloadData];
                }
            }
            
            
        }
    }
    
    
    
    
    
    /*
    NSError *error;
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"a=%@",id_of_user] dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            //NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);

        
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            }];
            [alert addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                 [self presentViewController:alert animated:true completion:nil];
            });
        } else {
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            
            NSError *jsonError;
            NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            if (jsonError != nil) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                }];
                [alert addAction:okAction];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                     [self presentViewController:alert animated:true completion:nil];
                });
            } else {
                NSLog(@"%@",jsonDict);
                
                NSString *random = [jsonDict objectForKey:@"a"];
                NSString *key_access_from_server = [code select_value_1_from_DB:@"key_access"];
                NSString *key_access_hash = [key_access_from_server md5];
                random = [random md5];
                NSString *check_hash = [NSMutableString stringWithFormat:@"%@%@XXXXXXXXXXXXXXXXXXXXXX",key_access_hash,random];
                check_hash = [check_hash md5];
                
                
                NSURL *url = [NSURL URLWithString:@"https://fame-application.com/lilfamnation/application/profile.php"];
                NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
                [urlRequest setHTTPMethod:@"POST"];
                NSString *userUpdate =[NSString stringWithFormat:@"a=%@&b=%@",id_of_user, check_hash];
                NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
                [urlRequest setHTTPBody:data];
                
                
            }
        }
        
        }];

    // Execute the task
    [task resume];
    */
    
}









//чтобы клавиатура пряталась после нажатия return в поле field
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    for(int i=0;i<=2;i++){
        ProfileData *cell = [profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(i == 0){
            [GlobalVariables sharedInstance].g_fio = [NSMutableString stringWithString:cell.fieldProfileData.text];
        }
        if(i == 1){
            [GlobalVariables sharedInstance].g_mail = [NSMutableString stringWithString:cell.fieldProfileData.text];
        }
        if(i == 2){
            [GlobalVariables sharedInstance].g_phone = [NSMutableString stringWithString:cell.fieldProfileData.text];
        }
        NSLog(@"Перехваченное значение из поля %@",cell.fieldProfileData.text);
    }
    if([[GlobalVariables sharedInstance].g_minor isEqualToString:@"1"]){
        for(int i=6;i<=7;i++){
            ProfileData *cell = [profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if(i == 6){
                [GlobalVariables sharedInstance].g_parent_fio = [NSMutableString stringWithString:cell.fieldProfileData.text];
            }
            if(i == 7){
                [GlobalVariables sharedInstance].g_parent_phone = [NSMutableString stringWithString:cell.fieldProfileData.text];
            }
            NSLog(@"Перехваченное значение из поля %@",cell.fieldProfileData.text);
        }
    }
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField){
        if (textField.text.length < 32 || string.length == 0){
            return YES;
        }
    }
    return NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [profileTableContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ProfileData";
    ProfileData *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    //UITableViewCellStyleSubtitle - с кратким описанием
    /*
    cell.textLabel.text = [catalogTable_g objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"преподаватель";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    */
    
    /*
    cell.groupTime.text = @"9:00";
    cell.groupName.text = [catalogTable_g objectAtIndex:indexPath.row];
    cell.groupTeacher.text = @"Преподаватель";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    */
    
    
    //NSLog(@"Проверяем %ld",(long)indexPath.row);
    
    //NSLog(@"Рисуются назянтия из секции %ld",(long)indexPath.section);
    //cell.groupTime.text = [scheduleSchetchikId valueForKey:[scheduleDict valueForKey:]];
    
    
    
    cell.labelProfileData.text = [profileTableContent objectAtIndex:indexPath.row];
   
    /*
    NSString *dayId = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSString *SchetchikId = [NSString stringWithFormat:@"%@", [[scheduleDict valueForKey:dayId] objectAtIndex:indexPath.row]];
    NSLog(@"scheduleSchetchikId = %@",SchetchikId);
    
    NSLog(@"Прочитал %@",[[scheduleSchetchikId valueForKey:SchetchikId] valueForKey:@"id_of_group"]);
    
    NSString *id_of_group = [[scheduleSchetchikId valueForKey:SchetchikId] valueForKey:@"id_of_group"];
    
    cell.groupTime.text = [[DBSchedule valueForKey:id_of_group] valueForKey:@"time_of_group"];
    cell.groupName.text = [[DBSchedule valueForKey:id_of_group] valueForKey:@"name_of_group"];
    cell.groupTeacher.text = [[DBSchedule valueForKey:id_of_group] valueForKey:@"teacher_of_group"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = SchetchikId;
    cell.textLabel.hidden = true;
    */
    
    if(indexPath.row == 0){
        cell.fieldProfileData.text = [GlobalVariables sharedInstance].g_fio;
    }
    if(indexPath.row == 1){
        cell.fieldProfileData.text = [GlobalVariables sharedInstance].g_mail;
    }
    if(indexPath.row == 2){
        cell.fieldProfileData.text = [GlobalVariables sharedInstance].g_phone;
    }
    if(indexPath.row == 4){
        if([[GlobalVariables sharedInstance].g_gender isEqualToString:@"1"]){
            cell.fieldProfileData.text = [NSString stringWithFormat:@"%@  ",@"женский"];
        } else if ([[GlobalVariables sharedInstance].g_gender isEqualToString:@"2"]) {
            cell.fieldProfileData.text = [NSString stringWithFormat:@"%@  ",@"мужской"];
        } else {
            cell.fieldProfileData.text = [NSString stringWithFormat:@"%@  ",@"не выбрано"];
        }
        cell.fieldProfileData.enabled = NO;
    }
    if(indexPath.row == 5){
        cell.fieldProfileData.text = [NSString stringWithFormat:@"%@  ", [GlobalVariables sharedInstance].g_birthday];
        cell.fieldProfileData.enabled = NO;
    }
    if(indexPath.row == 3){
        cell.fieldProfileData.enabled = NO;
    }
    
    if(indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5){
        //cell.fieldProfileData.hidden = true;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(indexPath.row == 6){
        cell.fieldProfileData.text = [GlobalVariables sharedInstance].g_parent_fio;
    }
    if(indexPath.row == 7){
        cell.fieldProfileData.text = [GlobalVariables sharedInstance].g_parent_phone;
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"Был выбран пункт %ld",(long)indexPath.row);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    NSLog(@"Был выбран пункт %@", cellText);
    
    
    if(indexPath.row == 3){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Profile *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"CheckPassword"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentModalViewController:vc animated:NO];
    }
    if(indexPath.row == 4){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Profile *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProfileGender"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentModalViewController:vc animated:NO];
    }
    if(indexPath.row == 5){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Profile *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProfileDateBirth"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentModalViewController:vc animated:NO];
    }
    
    /*
    NSString *id_of_group = [[scheduleSchetchikId valueForKey:cellText] valueForKey:@"id_of_group"];
    
    [GlobalVariables sharedInstance].global_date_of_action = id_of_group;
    [GlobalVariables sharedInstance].global_id_of_group = [[scheduleSchetchikId valueForKey:cellText] valueForKey:@"date_of_action"];
    
    [GlobalVariables sharedInstance].global_name_of_group = [[DBSchedule valueForKey:id_of_group] valueForKey:@"name_of_group"];
    [GlobalVariables sharedInstance].global_time_of_group = [[DBSchedule valueForKey:id_of_group] valueForKey:@"time_of_group"];
    [GlobalVariables sharedInstance].global_name_of_teacher = [[DBSchedule valueForKey:id_of_group] valueForKey:@"teacher_of_group"];
    
    
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
