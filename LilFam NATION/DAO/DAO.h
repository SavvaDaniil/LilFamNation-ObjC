//
//  DAO.h
//  LilFam NATION
//
//  Created by Daniil Savva on 22.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

NS_ASSUME_NONNULL_BEGIN

@interface DAO : UIViewController{
    NSString *code;
    NSString *answer_from_function;
    NSFileManager *file_manager;
}

-(NSString *) check_registration_in_ios;
-(NSString *) insert_data_in_DB:(NSString *)id_of_action second:(NSString *)value;
-(NSString *) update_data_in_DB_value_1:(NSString *)id_of_action second:(NSString *)value;
-(void) clear_DB;
-(void) check_exist_of_functional_strings;
-(void) check_exist_of_functional_string:(NSString *)name_of_value;
-(void) delete_string_from_info_of_user:(NSString *) name_of_string;
-(NSString *) select_value_1_from_DB:(NSString *)id_of_action;

-(void)check_exist_of_table_schedule;
-(void)check_exist_of_table_user_info;


//для работы с базой данных
@property (strong,nonatomic) NSString *datebasePath;
@property (nonatomic) sqlite3 *DB;

@end

NS_ASSUME_NONNULL_END
