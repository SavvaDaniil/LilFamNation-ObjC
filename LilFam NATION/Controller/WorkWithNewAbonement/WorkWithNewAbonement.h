//
//  WorkWithNewAbonement.h
//  LilFam NATION
//
//  Created by Daniil Savva on 06.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkWithNewAbonement : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>{
    IBOutlet UITableView *abonementsTable;
}
@property (strong, nonatomic) UITableView *abonementsTable;
@property (weak) IBOutlet UIButton *btnApplePay;
@property (weak) IBOutlet UIButton *btnBuy;

@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
