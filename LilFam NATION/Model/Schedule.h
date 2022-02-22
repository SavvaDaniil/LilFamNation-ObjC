//
//  Schedule.h
//  LilFam NATION
//
//  Created by Daniil Savva on 16.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Schedule : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *groupTime;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *groupTeacher;

@end

NS_ASSUME_NONNULL_END
