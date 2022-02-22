//
//  Reservation.h
//  LilFam NATION
//
//  Created by Daniil Savva on 02.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Reservation : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;


@end

NS_ASSUME_NONNULL_END
