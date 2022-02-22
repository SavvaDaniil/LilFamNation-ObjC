//
//  AbonementsForBuy.h
//  LilFam NATION
//
//  Created by Daniil Savva on 02.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AbonementsForBuy : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>{
    IBOutlet UITableView *abonementsTable;
}
@property (strong, nonatomic) UITableView *abonementsTable;

@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
