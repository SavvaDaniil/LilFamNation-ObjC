//
//  Admin.h
//  LilFam NATION
//
//  Created by Daniil Savva on 10.01.2020.
//  Copyright © 2020 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Admin : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *lessonsTable;
}
@property (strong, nonatomic) UITableView *lessonsTable;

@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
