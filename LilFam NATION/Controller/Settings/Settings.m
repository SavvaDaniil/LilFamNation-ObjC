//
//  Settings.m
//  LilFam NATION
//
//  Created by Daniil Savva on 02.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "Settings.h"
#import "Setting.h"
#import "DAO.h"
#import "GlobalVariables.h"
#import "CoreLocation/CoreLocation.h"
#import <CommonCrypto/CommonDigest.h>
#import "SceneDelegate.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface Settings ()

@end

@implementation Settings {
    NSMutableArray *arraySettingsTable;
    NSMutableArray *arraySettingsTable_name;
    NSMutableArray *arraySettingsTable_switch;
}
@synthesize settingsTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    
}
- (IBAction)btnMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arraySettingsTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"settingsTable";
    Setting *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    
    cell.settingName.text = [arraySettingsTable_name objectAtIndex:indexPath.row];
   
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"Был выбран пункт %ld",(long)indexPath.row);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    NSLog(@"Был выбран пункт %@", cellText);
    
    
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
