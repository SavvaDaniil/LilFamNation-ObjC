//
//  Login.m
//  LilFam NATION
//
//  Created by Daniil Savva on 04.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "Login.h"
#import "DAO.h"
#import "GlobalVariables.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h>

@interface Login ()

@end

@implementation Login
@synthesize btnLogin,btnReg, login, password;

- (void)viewDidLoad {
    [super viewDidLoad];
    btnLogin.layer.cornerRadius = 10;
    btnReg.layer.cornerRadius = 10;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successRegistration:)  name:@"successRegistration" object:nil];
}
- (void) successRegistration:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"successRegistration"])
        [self closeView];
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
-(IBAction)clickbtnReg:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Login *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Licence"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentModalViewController:vc animated:NO];
}


//чтобы клавиатура пряталась после нажатия return в поле field
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
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


-(IBAction)clickbtnLogin:(id)sender {
    if([login.text isEqualToString:@""] || [password.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Оба поля должны быть заполнены" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
        }];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
    } else {
        [self loginFunction];
    }
}

-(void)loginFunction {
    NSString *getLogin = login.text;
    NSString *getPassword = password.text;
    
    
    DAO *code = [DAO alloc];
    code = [code init];
    NSLog(@"Вызов функции регистрации");
    
    NSString* UDID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSMutableString * md5_1 = [NSMutableString stringWithString:[UDID md5]];
    [md5_1 appendString:@"jsdghjiojm_lsdfujijRTjbnfjsjkjgkj7735iHJFS677uHJHJFje8umn"];
    NSString* UDID_of_device_MD5 = [NSString stringWithString:[md5_1 md5]];
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/login.php",[GlobalVariables sharedInstance].global_url]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *userUpdate =[NSString stringWithFormat:@"udid=%@&hash_udid=%@&iphone0android1=0&login=%@&password=%@",UDID,UDID_of_device_MD5, getLogin, getPassword];
    NSData *data = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:data];
    

    NSError *error = nil;
    NSHTTPURLResponse *responceCode = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responceCode error:&error];
    if (error) {
        NSLog(@"Ошибка регистрации");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка сети" message:@"Не удалось сгенерировать ключ шифрования" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            
        }];
        UIAlertAction *tryAganin = [UIAlertAction actionWithTitle:@"Попробовать снова" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self loginFunction];
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
                
            }];
            UIAlertAction *tryAganin = [UIAlertAction actionWithTitle:@"Попробовать снова" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self loginFunction];
            }];
            [alert addAction:tryAganin];
            [alert addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                 [self presentViewController:alert animated:true completion:nil];
            });
        } else {
            NSLog(@"%@",jsonDict);
            
            if([[jsonDict objectForKey:@"error"] isEqualToString:@"0"]){
                NSLog(@"Успешная регистрация");
                [GlobalVariables sharedInstance].status_of_registration = [NSMutableString stringWithString:@"1"];
                [code update_data_in_DB_value_1:@"id_of_user" second:[jsonDict objectForKey:@"id_of_user"]];
                NSString *key_access_from_server = [jsonDict objectForKey:@"key_access"];
                NSString *key_access_from_server2 = [NSString stringWithFormat:@"%@fhhgkfdgjkuYUD8753kjJLSlfdspa8784353",key_access_from_server];
                key_access_from_server2 = [key_access_from_server2 md5];
                [code update_data_in_DB_value_1:@"key_access" second:key_access_from_server2];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Успешно" message:@"Спасибо за авторизацию. Нажмите пожалуйста 'Готово', чтобы продолжить" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Готово" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [self closeView];
                }];
                [alert addAction:okAction];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                     [self presentViewController:alert animated:true completion:nil];
                });
            }
            if([[jsonDict objectForKey:@"error"] isEqualToString:@"1"] || [[jsonDict objectForKey:@"error"] isEqualToString:@"2"]){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Неправильно введен логин или пароль" preferredStyle:UIAlertControllerStyleAlert];
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
