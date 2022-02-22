//
//  ViewController.h
//  LilFam NATION
//
//  Created by Daniil Savva on 15.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *catalogTable;
}

@property (strong, nonatomic) UITableView * catalogTable;

/*
@property (weak, nonatomic) IBOutlet UILabel *groupTime;
@property (weak, nonatomic) IBOutlet UILabel *groupName;
@property (weak, nonatomic) IBOutlet UILabel *groupTeacher;
*/


@end

