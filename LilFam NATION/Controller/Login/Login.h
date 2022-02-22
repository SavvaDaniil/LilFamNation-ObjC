//
//  Login.h
//  LilFam NATION
//
//  Created by Daniil Savva on 04.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Login : UIViewController <UITextFieldDelegate>

@property (weak) IBOutlet UIButton *btnLogin;
@property (weak) IBOutlet UIButton *btnReg;
@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UITextField *password;


@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
