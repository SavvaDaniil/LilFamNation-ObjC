//
//  WorkWithReservation.h
//  LilFam NATION
//
//  Created by Daniil Savva on 02.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkWithReservation : UIViewController

@property (weak) IBOutlet UIButton *BtnToMap;
/*
@property (weak, nonatomic) IBOutlet UILabel *name_of_group;
@property (weak, nonatomic) IBOutlet UILabel *day_week_to_print;
@property (weak, nonatomic) IBOutlet UILabel *time_from_of_group;
@property (weak, nonatomic) IBOutlet UILabel *name_of_abonement;
@property (weak, nonatomic) IBOutlet UILabel *name_of_branch;
@property (weak, nonatomic) IBOutlet UILabel *date_of_action_to_print;
@property (weak, nonatomic) IBOutlet UILabel *name_of_prepod;
*/
@property (weak, nonatomic) IBOutlet UILabel *groupTime;
@property (weak, nonatomic) IBOutlet UILabel *groupDate;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *groupTeacher;
@property (weak, nonatomic) IBOutlet UILabel *groupDescriptionBranch;
@property (weak, nonatomic) IBOutlet UILabel *groupDescription;
@property (weak, nonatomic) IBOutlet UIImageView *img_of_teacher;
@property (weak, nonatomic) IBOutlet UILabel *groupSchedule;
@property (weak, nonatomic) IBOutlet UILabel *group_status_to_print;

@property (weak, nonatomic) IBOutlet UILabel *lesson_date_of_buy;
@property (weak, nonatomic) IBOutlet UILabel *lesson_about_abonement;

@property (weak) IBOutlet UIView *backgroundOfImage;

@property (weak) IBOutlet UIButton *btnCansel;


@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
