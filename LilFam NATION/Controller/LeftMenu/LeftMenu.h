//
//  LeftMenu.h
//  LilFam NATION
//
//  Created by Daniil Savva on 15.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneDelegate.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeftMenu : UIViewController <UITableViewDelegate> {
    IBOutlet UITableView *leftMenu;
    IBOutlet UIImageView *logo;
}

@property (strong, nonatomic) UITableView * leftMenu;
@property (strong, nonatomic) UIImageView *logo;

@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
