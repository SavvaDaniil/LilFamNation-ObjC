//
//  Registration.h
//  LilFam NATION
//
//  Created by Daniil Savva on 24.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Registration : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>{
    IBOutlet UITableView *profileTable;
}

@property (strong, nonatomic) UITableView *profileTable;
@property (weak) IBOutlet UIButton *btnRegistration;



-(void)registration;




@end



//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
