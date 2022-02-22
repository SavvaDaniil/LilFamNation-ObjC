//
//  Contacts.m
//  LilFam NATION
//
//  Created by Daniil Savva on 27.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "Contacts.h"
#import "SceneDelegate.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface Contacts ()

@end

@implementation Contacts
@synthesize btnOpenUrl, btnOpenVK, btnOpenInstagram, btnOpenInstagramAgain;

- (void)viewDidLoad {
    [super viewDidLoad];
    btnOpenUrl.layer.cornerRadius = 10;
    btnOpenVK.layer.cornerRadius = 10;
    btnOpenInstagram.layer.cornerRadius = 10;
    btnOpenInstagramAgain.layer.cornerRadius = 10;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
- (IBAction)btnMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(IBAction)setbtnOpenUrl:(UIButton *)btnOpenUrl{
    NSURL* url = [[NSURL alloc] initWithString:@"http://studio.lilfamnation.com"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
}
-(IBAction)setbtnOpenVK:(UIButton *)btnOpenVK{
    NSURL *vkURL = [NSURL URLWithString:@"vk://vk.com/lilfam"];
    if ([[UIApplication sharedApplication] canOpenURL:vkURL]) {
        [[UIApplication sharedApplication] openURL:vkURL options:@{} completionHandler:^(BOOL success) {}];
    } else {
        NSURL* url = [[NSURL alloc] initWithString: @"http://vk.com/lilfam"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
    }
}
-(IBAction)setbtnOpenInstagram:(UIButton *)btnOpenInstagram{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=studio.lilfam.nation"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    } else {
        NSURL* url = [[NSURL alloc] initWithString: @"https://www.instagram.com/studio.lilfam.nation"];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
    }
}
-(IBAction)openInstagramAgain {
    [self setbtnOpenInstagram:btnOpenInstagram];
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
