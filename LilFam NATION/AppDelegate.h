//
//  AppDelegate.h
//  LilFam NATION
//
//  Created by Daniil Savva on 15.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVFoundation.h"
#import <CoreData/CoreData.h>
#import "MMDrawerController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;


@property (strong, nonatomic) UIWindow * window;
@property (strong, nonatomic) MMDrawerController *drawerController;

@property (nonatomic, strong) NSString *id_of_group_and_date_of_action;


- (void)saveContext;


@end

