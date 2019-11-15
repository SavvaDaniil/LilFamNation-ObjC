//
//  AppDelegate.h
//  LilFam NATION
//
//  Created by Daniil Savva on 15.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

