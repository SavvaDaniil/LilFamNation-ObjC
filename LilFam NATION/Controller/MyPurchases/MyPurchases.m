//
//  MyPurchases.m
//  LilFam NATION
//
//  Created by Daniil Savva on 17.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "MyPurchases.h"
#import "SceneDelegate.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface MyPurchases ()

@end

@implementation MyPurchases

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    
    
}
- (IBAction)btnMenu:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
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
