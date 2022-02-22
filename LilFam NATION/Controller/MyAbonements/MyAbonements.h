//
//  MyAbonements.h
//  LilFam NATION
//
//  Created by Daniil Savva on 30.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAbonements : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>{
    IBOutlet UITableView *abonementsTable;
}

@property (strong, nonatomic) UITableView *abonementsTable;
@property (weak) IBOutlet UIButton *btnBuyNewAbonement;

@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
