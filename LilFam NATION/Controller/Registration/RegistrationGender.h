//
//  RegistrationGender.h
//  LilFam NATION
//
//  Created by Daniil Savva on 03.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegistrationGender : UIViewController <UITableViewDelegate> {
    IBOutlet UITableView *genderTable;
}

@property (strong, nonatomic) UITableView * genderTable;

@end

NS_ASSUME_NONNULL_END
