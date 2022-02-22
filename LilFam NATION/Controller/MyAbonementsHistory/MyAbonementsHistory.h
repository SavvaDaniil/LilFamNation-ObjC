//
//  MyAbonementsHistory.h
//  LilFam NATION
//
//  Created by Daniil Savva on 20.01.2020.
//  Copyright © 2020 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAbonementsHistory : UIViewController <UITableViewDataSource,UITableViewDelegate>{
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
