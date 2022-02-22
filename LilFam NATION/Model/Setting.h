//
//  Setting.h
//  LilFam NATION
//
//  Created by Daniil Savva on 02.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Setting : UITableViewCell

//settingName settingSwitch
@property (weak, nonatomic) IBOutlet UILabel *settingName;
@property (weak, nonatomic) IBOutlet UISwitch *settingSwitch;


@end

NS_ASSUME_NONNULL_END
