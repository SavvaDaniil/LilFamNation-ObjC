//
//  Settings.h
//  LilFam NATION
//
//  Created by Daniil Savva on 02.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Settings : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>{
    IBOutlet UITableView *settingsTable;
}
@property (strong, nonatomic) UITableView *settingsTable;

@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
