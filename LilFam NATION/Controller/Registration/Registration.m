//
//  Registration.m
//  LilFam NATION
//
//  Created by Daniil Savva on 24.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "Registration.h"
#import "RegistrationCell.h"
#import "GlobalVariables.h"
#import "DAO.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h> 

@interface Registration ()

@end

@implementation Registration {
    NSMutableArray *regTableContent;
    
    NSMutableString *fio;
    NSMutableString *mail;
    NSMutableString *phone;
    NSMutableString *birthday;
    NSMutableString *gender;
    NSMutableString *parent_fio;
    NSMutableString *parent_phone;
    NSMutableString *minor;
}
@synthesize profileTable, btnRegistration;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnRegistration.layer.cornerRadius = 10;
    
    
    [GlobalVariables sharedInstance].g_fio = [NSMutableString stringWithString:@""];
    [GlobalVariables sharedInstance].g_mail = [NSMutableString stringWithString:@""];
    [GlobalVariables sharedInstance].g_phone= [NSMutableString stringWithString:@""];
    [GlobalVariables sharedInstance].g_gender= [NSMutableString stringWithString:@""];
    [GlobalVariables sharedInstance].g_reg_password = [NSMutableString stringWithString:@""];
    [GlobalVariables sharedInstance].g_gender = [NSMutableString stringWithString:@""];
    [GlobalVariables sharedInstance].g_birthday = [NSMutableString stringWithString:@""];
    [GlobalVariables sharedInstance].g_parent_fio = [NSMutableString stringWithString:@""];
    [GlobalVariables sharedInstance].g_parent_phone = [NSMutableString stringWithString:@""];
    
    //[self registration];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    //if(![[GlobalVariables sharedInstance].g_birthday])
     //   [GlobalVariables sharedInstance].g_birthday = [NSMutableString stringWithString:@"2000-01-01"];
     //   NSLog(@"Обнуление даты");
    
    regTableContent = [NSMutableArray arrayWithObjects:@"ФИО",@"Почта",@"Телефон",@"Пароль",@"Пол",@"Дата рождения",nil];
    
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

-(IBAction)btnSuccess:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:Nil];
}
-(IBAction)btnTryAgain:(id)sender {
    //[self registration];
}
-(IBAction)btnCansel:(id)sender {
    //[self closeViewController];
}
-(void)canselReg {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:Nil];
}
-(void)closeViewController {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self dismissViewControllerAnimated:NO completion:Nil];
    
    //чтобы вызвалась функция в view Profile
    [self dismissViewControllerAnimated:NO completion:^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"successReg" object:self];
    }];
}






-(IBAction)clickBtnRegistration:(id)sender {
    if([[GlobalVariables sharedInstance].g_fio isEqualToString:@""] || [[GlobalVariables sharedInstance].g_mail isEqualToString:@""] || [[GlobalVariables sharedInstance].g_phone isEqualToString:@""] || [[GlobalVariables sharedInstance].g_reg_password isEqualToString:@""] || [[GlobalVariables sharedInstance].g_gender isEqualToString:@""] || [[GlobalVariables sharedInstance].g_birthday isEqualToString:@""]){
        [self errorAlert:@"Не все поля заполнены"];
    } else {
        if([[GlobalVariables sharedInstance].g_minor isEqualToString:@"1"] && ([[GlobalVariables sharedInstance].g_parent_fio isEqualToString:@""] || [[GlobalVariables sharedInstance].g_parent_phone isEqualToString:@""])){
            [self errorAlert:@"Заполните пожалуйста данные связи с вашими родителями 1"];
        } else {
            //начинаем регистрацию
            [self registration];
        }
    }
}

-(void)registration {
    NSLog(@"Вызов функции регистрации");
    
    DAO *code = [DAO alloc];
    code = [code init];
    
    NSString* UDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSMutableString * md5_1 = [NSMutableString stringWithString:[UDID md5]];
    [md5_1 appendString:@"jsdghjiojm_lsdfujijRTjbnfjsjkjgkj7735iHJFS677uHJHJFje8umn"];
    NSString* UDID_of_device_MD5 = [NSString stringWithString:[md5_1 md5]];
    
    
    //NSURL *url = [NSURL URLWithString:@"https://fame-application.com/lilfamnation/application/auth.php"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/auth.php",[GlobalVariables sharedInstance].global_url]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *userUpdate = [NSString stringWithFormat:@"udid=%@&hash_udid=%@&iphone0android1=0&fio=%@&phone=%@&mail=%@&gender=%@&birthday=%@&parent_fio=%@&parent_phone=%@&password=%@", UDID, UDID_of_device_MD5, [GlobalVariables sharedInstance].g_fio , [GlobalVariables sharedInstance].g_phone , [GlobalVariables sharedInstance].g_mail , [GlobalVariables sharedInstance].g_gender , [GlobalVariables sharedInstance].g_birthday , [GlobalVariables sharedInstance].g_parent_fio , [GlobalVariables sharedInstance].g_parent_phone, [GlobalVariables sharedInstance].g_reg_password];
    NSLog(@"%@",userUpdate);
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:data];
    

    NSError *error = nil;
    NSHTTPURLResponse *responceCode = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responceCode error:&error];
    if (error) {
        NSLog(@"Ошибка регистрации");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка сети" message:@"Не удалось сгенерировать ключ шифрования" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [self canselReg];
        }];
        UIAlertAction *tryAganin = [UIAlertAction actionWithTitle:@"Попробовать снова" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self registration];
        }];
        [alert addAction:tryAganin];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
    } else {
        NSLog(@"%@", [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
        NSError *jsonError;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError != nil) {
            NSLog(@"JSON isn't right:%@",jsonError);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка сети" message:@"Ошибка на стороне сервера" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                [self canselReg];
            }];
            UIAlertAction *tryAganin = [UIAlertAction actionWithTitle:@"Попробовать снова" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self registration];
            }];
            [alert addAction:tryAganin];
            [alert addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                 [self presentViewController:alert animated:true completion:nil];
            });
        } else {
            NSLog(@"%@",jsonDict);

            if([[jsonDict objectForKey:@"error"] isEqualToString:@"1"]){
                [GlobalVariables sharedInstance].g_minor = [NSMutableString stringWithString:@"0"];
                [self errorAlert:@"Не все поля заполнены"];
            } else if([[jsonDict objectForKey:@"error"] isEqualToString:@"2"]){
                [GlobalVariables sharedInstance].g_minor = [NSMutableString stringWithString:@"0"];
                [self errorAlert:@"Не указан email"];
            } else if([[jsonDict objectForKey:@"error"] isEqualToString:@"3"]){
                [GlobalVariables sharedInstance].g_minor = [NSMutableString stringWithString:@"0"];
                [self errorAlert:@"Указанный email уже зарегистрирован в базе"];
            } else if([[jsonDict objectForKey:@"error"] isEqualToString:@"4"]){
                
                [GlobalVariables sharedInstance].g_minor = [NSMutableString stringWithString:@"1"];
                regTableContent = [NSMutableArray arrayWithObjects:@"ФИО",@"Почта",@"Телефон",@"Пароль",@"Пол",@"Дата рождения",@"ФИО родителя",@"Телефон родителя",nil];
                [profileTable reloadData];
                [self errorAlert:@"Укажите пожалуйста контакты ваших родителей"];
            } else {
                NSLog(@"Успешная регистрация");
                
                [GlobalVariables sharedInstance].status_of_registration = [NSMutableString stringWithString:@"1"];
                [code update_data_in_DB_value_1:@"id_of_user" second:[jsonDict objectForKey:@"id_of_user"]];
                NSString *key_access_from_server = [jsonDict objectForKey:@"key_access"];
                NSString *key_access_from_server2 = [NSString stringWithFormat:@"%@fhhgkfdgjkuYUD8753kjJLSlfdspa8784353",key_access_from_server];
                key_access_from_server2 = [key_access_from_server2 md5];
                [code update_data_in_DB_value_1:@"key_access" second:key_access_from_server2];

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Успешно" message:@"Спасибо за регистрацию. Нажмите пожалуйста 'Готово', чтобы продолжить" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Готово" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [self closeViewController];
                }];
                [alert addAction:okAction];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                     [self presentViewController:alert animated:true completion:nil];
                });
                
            }
            
            
        }
    }
    
    //NSString *answer_code = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    
}

-(void)errorAlert:(NSString *)explanation {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:explanation preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^(void){
         [self presentViewController:alert animated:true completion:nil];
    });
}














//чтобы клавиатура пряталась после нажатия return в поле field
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    for(int i=0;i<=3;i++){
        RegistrationCell *cell = [profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(i == 0){
            [GlobalVariables sharedInstance].g_fio = [NSMutableString stringWithString:cell.fieldProfileData.text];
        }
        if(i == 1){
            [GlobalVariables sharedInstance].g_mail = [NSMutableString stringWithString:cell.fieldProfileData.text];
        }
        if(i == 2){
            [GlobalVariables sharedInstance].g_phone = [NSMutableString stringWithString:cell.fieldProfileData.text];
        }
        if(i == 3){
            [GlobalVariables sharedInstance].g_reg_password = [NSMutableString stringWithString:cell.fieldProfileData.text];
        }
        NSLog(@"Перехваченное значение из поля %@",cell.fieldProfileData.text);
    }
    if([[GlobalVariables sharedInstance].g_minor isEqualToString:@"1"]){
        for(int i=6;i<=7;i++){
            RegistrationCell *cell = [profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if(i == 6){
                [GlobalVariables sharedInstance].g_parent_fio = [NSMutableString stringWithString:cell.fieldProfileData.text];
            }
            if(i == 7){
                [GlobalVariables sharedInstance].g_parent_phone = [NSMutableString stringWithString:cell.fieldProfileData.text];
            }
        }
    }
    
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField){
        if (textField.text.length < 64 || string.length == 0){
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
    return [regTableContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"registrationData";
    RegistrationCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    
    cell.labelProfileData.text = [regTableContent objectAtIndex:indexPath.row];
   
    
    if(indexPath.row == 0){
        cell.fieldProfileData.text = [GlobalVariables sharedInstance].g_fio;
    }
    if(indexPath.row == 1){
        cell.fieldProfileData.text = [GlobalVariables sharedInstance].g_mail;
    }
    if(indexPath.row == 2){
        cell.fieldProfileData.text = [GlobalVariables sharedInstance].g_phone;
    }
    if(indexPath.row == 3){
        cell.fieldProfileData.secureTextEntry = TRUE;
        cell.fieldProfileData.text = [GlobalVariables sharedInstance].g_reg_password;
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
    
    if(indexPath.row == 4 || indexPath.row == 5){
        //cell.fieldProfileData.hidden = true;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"Был выбран пункт %ld",(long)indexPath.row);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    NSLog(@"Был выбран пункт %@", cellText);
    
    
    if(indexPath.row == 4){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        Registration *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegistrationGender"];
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
        Registration *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"RegistrationDateBirth"];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentModalViewController:vc animated:NO];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return CGFLOAT_MIN;
}




-(void)registration2 {
    
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
