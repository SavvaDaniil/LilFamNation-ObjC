//
//  Group.h
//  LilFam NATION
//
//  Created by Daniil Savva on 16.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Group : UIViewController


@property (weak) IBOutlet UIButton *actionBtn;
@property (weak) IBOutlet UIButton *BtnToMap;

@property (weak, nonatomic) IBOutlet UILabel *groupTime;
@property (weak, nonatomic) IBOutlet UILabel *groupDate;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *groupTeacher;
@property (weak, nonatomic) IBOutlet UILabel *groupDescriptionBranch;
@property (weak, nonatomic) IBOutlet UILabel *groupDescription;
@property (weak, nonatomic) IBOutlet UIImageView *img_of_teacher;
@property (weak, nonatomic) IBOutlet UILabel *groupSchedule;
@property (weak, nonatomic) IBOutlet UILabel *group_status_to_print;
@property (weak) IBOutlet UIButton *btnInstagram;
@property (weak) IBOutlet UIButton *btnSub2;

@property (weak) IBOutlet UIView *backgroundOfImage;

@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
