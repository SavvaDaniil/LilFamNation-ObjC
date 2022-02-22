//
//  AdminGroup.h
//  LilFam NATION
//
//  Created by Daniil Savva on 10.01.2020.
//  Copyright © 2020 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdminGroup : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *clientsTable;
    IBOutlet UILabel *nameGroup;
    IBOutlet UILabel *count_clients;
    IBOutlet UILabel *schetchik_of_clients_checked;
    IBOutlet UILabel *schetchik_of_clients_not_checked;
    IBOutlet UILabel *payment;
}
@property (weak) IBOutlet UIButton *btnQRcode;
@property (weak) IBOutlet UIButton *btnQRcodeAuto;

@property (strong, nonatomic) UITableView *clientsTable;
@property (weak) IBOutlet UIButton *actionCanselLesson;



@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
