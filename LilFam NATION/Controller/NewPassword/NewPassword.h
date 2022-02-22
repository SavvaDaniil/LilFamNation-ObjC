//
//  NewPassword.h
//  LilFam NATION
//
//  Created by Daniil Savva on 04.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewPassword : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak) IBOutlet UIButton *btnSave;

@end

@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
