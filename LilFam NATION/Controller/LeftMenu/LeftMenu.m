//
//  LeftMenu.m
//  LilFam NATION
//
//  Created by Daniil Savva on 15.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "LeftMenu.h"
#import "GlobalVariables.h"
#import "DAO.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h>

@interface LeftMenu ()

@end

@implementation LeftMenu {
    NSArray *menuArray;
    NSMutableString *name_of_image_for_btn_of_menu_left;
}
@synthesize leftMenu, logo;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    
    DAO *code = [DAO alloc];
    code = [code init];
    NSString *check_of_registration = [code check_registration_in_ios];
    
    if([check_of_registration isEqualToString:@"0"]){
        menuArray = [NSArray arrayWithObjects:@"Войти",@"QR-код",@"Группы", @"Мои занятия",@"История покупок",@"Купить абонемент", @"Контакты", nil];
    }
    if([check_of_registration isEqualToString:@"1"]){
        menuArray = [NSArray arrayWithObjects:@"Профиль",@"QR-код",@"Группы", @"Мои занятия",@"История покупок",@"Купить абонемент", @"Контакты", @"Выйти", nil];
    }
    
    
    //leftMenu.separatorColor = [UIColor clearColor];
    leftMenu.separatorColor = [UIColor blackColor];
    leftMenu.alwaysBounceVertical = NO;
    
    //leftMenu.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(check_status_of_admin)];
    singleTap.numberOfTapsRequired = 1;
    [logo setUserInteractionEnabled:YES];
    [logo addGestureRecognizer:singleTap];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    DAO *code = [DAO alloc];
    code = [code init];
    NSString *check_of_registration = [code check_registration_in_ios];
    
    if([check_of_registration isEqualToString:@"0"]){
        menuArray = [NSArray arrayWithObjects:@"Войти",@"QR-код",@"Группы", @"Мои занятия",@"История покупок", @"Купить абонемент", @"Контакты", nil];
    }
    if([check_of_registration isEqualToString:@"1"]){
        menuArray = [NSArray arrayWithObjects:@"Профиль",@"QR-код",@"Группы", @"Мои занятия",@"История покупок", @"Купить абонемент", @"Контакты", @"Выйти", nil];
    }
    
    [leftMenu reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"LeftMenu";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
 
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
 
    
    cell.textLabel.text = [menuArray objectAtIndex:indexPath.row];
    
    /*
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    */
    
    return cell;
}




-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Был выбран пункт %ld",(long)indexPath.row);
    
    if(indexPath.row == 0){
        DAO *code = [DAO alloc];
        code = [code init];
        NSString *check_of_registration = [code check_registration_in_ios];
        if([check_of_registration isEqualToString:@"0"]){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LeftMenu *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentModalViewController:vc animated:NO];
        } else {
            [GlobalVariables sharedInstance].g_already_load_profile = [NSMutableString stringWithString:@"0"];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LeftMenu *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Profile"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentModalViewController:vc animated:NO];
            //[self presentViewController:vc animated:YES completion:nil];
        }
    }
    if(indexPath.row == 1){
        DAO *code = [DAO alloc];
        code = [code init];
        NSString *check_of_registration = [code check_registration_in_ios];
        if([check_of_registration isEqualToString:@"0"]){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LeftMenu *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentModalViewController:vc animated:NO];
        } else {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *centerView = [mainStoryboard instantiateViewControllerWithIdentifier:@"ClientCard"];
            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerView];
            [self.mm_drawerController setCenterViewController:centerNav withCloseAnimation:YES completion:nil];
        }
    }
    if(indexPath.row == 2){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *centerView = [mainStoryboard instantiateViewControllerWithIdentifier:@"CentralWindow"];
        UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerView];
        [self.mm_drawerController setCenterViewController:centerNav withCloseAnimation:YES completion:nil];
    }
    
    
    if(indexPath.row == 3){
        DAO *code = [DAO alloc];
        code = [code init];
        NSString *check_of_registration = [code check_registration_in_ios];
        if([check_of_registration isEqualToString:@"0"]){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LeftMenu *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentModalViewController:vc animated:NO];
        } else {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *centerView = [mainStoryboard instantiateViewControllerWithIdentifier:@"MyReservations"];
            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerView];
            [self.mm_drawerController setCenterViewController:centerNav withCloseAnimation:YES completion:nil];
        }
    }
    if(indexPath.row == 4){
        DAO *code = [DAO alloc];
        code = [code init];
        NSString *check_of_registration = [code check_registration_in_ios];
        if([check_of_registration isEqualToString:@"0"]){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LeftMenu *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentModalViewController:vc animated:NO];
        } else {
            [GlobalVariables sharedInstance].global_id_of_group = [NSMutableString stringWithString:@"0"];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *centerView = [mainStoryboard instantiateViewControllerWithIdentifier:@"MyAbonementsHistory"];
            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerView];
            [self.mm_drawerController setCenterViewController:centerNav withCloseAnimation:YES completion:nil];
        }
    }
    if(indexPath.row == 5){
        //Купить абонемент
        DAO *code = [DAO alloc];
        code = [code init];
        NSString *check_of_registration = [code check_registration_in_ios];
        if([check_of_registration isEqualToString:@"0"]){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LeftMenu *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentModalViewController:vc animated:NO];
        } else {
            [GlobalVariables sharedInstance].global_id_of_group = [NSMutableString stringWithString:@"0"];
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LeftMenu *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"AbonementsForBuy"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentModalViewController:vc animated:NO];
        }
    }
    if(indexPath.row == 6){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *centerView = [mainStoryboard instantiateViewControllerWithIdentifier:@"Contacts"];
        UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerView];
        [self.mm_drawerController setCenterViewController:centerNav withCloseAnimation:YES completion:nil];
    }
    if(indexPath.row == 7){
        [self areYouSureWantToExit];
        /*
        DAO *code = [DAO alloc];
        code = [code init];
        NSString *check_of_registration = [code check_registration_in_ios];
        if([check_of_registration isEqualToString:@"0"]){
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LeftMenu *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Login"];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentModalViewController:vc animated:NO];
        } else {
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *centerView = [mainStoryboard instantiateViewControllerWithIdentifier:@"Settings"];
            UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerView];
            [self.mm_drawerController setCenterViewController:centerNav withCloseAnimation:YES completion:nil];
        }
         */
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return CGFLOAT_MIN;
}




-(void)areYouSureWantToExit {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Выйти" message:@"Вы уверены, что хотите выйти из профиля?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Нет" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        
    }];
    UIAlertAction *tryAganin = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self logout];
    }];
    [alert addAction:tryAganin];
    [alert addAction:okAction];
    dispatch_async(dispatch_get_main_queue(), ^(void){
         [self presentViewController:alert animated:true completion:nil];
    });
}
-(void)logout {
    
    DAO *code = [DAO alloc];
    code = [code init];
    [code clear_DB];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *centerView = [mainStoryboard instantiateViewControllerWithIdentifier:@"CentralWindow"];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:centerView];
    [self.mm_drawerController setCenterViewController:centerNav withCloseAnimation:YES completion:nil];
}

-(void)check_status_of_admin {
    NSLog(@"Вызов check_status_of_admin");
    
    DAO *code_profile = [DAO alloc];
    code_profile = [code_profile init];
    NSString *id_of_user = [code_profile select_value_1_from_DB:@"id_of_user"];
    NSString *key_access_from_server = [code_profile select_value_1_from_DB:@"key_access"];
    
    if([id_of_user isEqualToString:@""] && [key_access_from_server isEqualToString:@""]){
        return;
    }
    
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
        
    } else {
        NSLog(@"%@", [[NSString alloc] initWithData:responseData_profile encoding:NSASCIIStringEncoding]);
        
        NSError *jsonError;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError != nil) {
            
        } else {
            NSLog(@"%@",jsonDict);
            
            NSString *random = [jsonDict objectForKey:@"a"];
            NSString *key_access_hash = [key_access_from_server md5];
            NSString *random_hash = [random md5];
            NSString *key_and_random = [NSString stringWithFormat:@"%@%@",key_access_hash,random_hash];
            NSString *check = [NSMutableString stringWithFormat:@"%@XXXXXXXXXXXXXXXXXXXXXX",key_and_random];
            NSString *check_hash = [check md5];
            
    
            NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/check_profile_admin.php",[GlobalVariables sharedInstance].global_url]];
            NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
            [urlRequest_profile setHTTPMethod:@"POST"];
            NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@&b=%@",id_of_user, check_hash];
            NSData *data_profile = [userUpdate_profile dataUsingEncoding:NSUTF8StringEncoding];
            [urlRequest_profile setHTTPBody:data_profile];
            
            
            NSError *error_profile = nil;
            NSHTTPURLResponse *responceCode_profile = nil;
            NSData *responseData_profile = [NSURLConnection sendSynchronousRequest:urlRequest_profile returningResponse:&responceCode_profile error:&error_profile];
            if (error_profile) {
                
            } else {
                NSLog(@"%@", [[NSString alloc] initWithData:responseData_profile encoding:NSASCIIStringEncoding]);
                
                NSError *jsonError_profile;
                NSDictionary * jsonDict2 = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError_profile];
                if (jsonError_profile != nil) {
                    //NSLog(@"JSON isn't right:%@",jsonError);
                } else {
                    NSLog(@"%@",jsonDict2);
                    
                    if([[jsonDict2 objectForKey:@"status_of_admin"] isEqualToString:@"1"]){
                        dispatch_async(dispatch_get_main_queue(),^{

                            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            LeftMenu *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Admin"];
                            CATransition *transition = [CATransition animation];
                            transition.duration = 0.3;
                            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                            transition.type = kCATransitionPush;
                            transition.subtype = kCATransitionFromRight;
                            [self.view.window.layer addAnimation:transition forKey:nil];
                            [self presentModalViewController:vc animated:NO];
                        });
                    } else {
                        NSLog(@"Ошибка доступа");
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
