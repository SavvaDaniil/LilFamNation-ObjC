//
//  WorkWithAbonementHistory.h
//  LilFam NATION
//
//  Created by Daniil Savva on 20.01.2020.
//  Copyright © 2020 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkWithAbonementHistory : UIViewController <UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *reservationsTable;
    
    IBOutlet UILabel *name_of_abonement;
    IBOutlet UILabel *how_much_money;
    IBOutlet UILabel *date_of_buy;
    IBOutlet UILabel *how_much_days;
    IBOutlet UILabel *date_of_activation;
    IBOutlet UILabel *date_to_must_be_used;
    IBOutlet UILabel *skolko_iznachalno_zanyatiy;
    IBOutlet UILabel *ostalos;
    IBOutlet UILabel *status;
    
}
@property (strong, nonatomic) UITableView *reservationsTable;

@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
