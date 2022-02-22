//
//  GlobalVariables.h
//  LilFam NATION
//
//  Created by Daniil Savva on 16.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlobalVariables : NSObject
{
    NSMutableString *global_url;
    
    NSMutableString *status_of_registration;
    
    NSMutableString *already_load_from_server;
    
    //Для работы с группой
    NSMutableString *global_id_of_group;
    NSMutableString *global_date_of_action;
    NSMutableString *global_name_of_group;
    NSMutableString *global_dayweak_month_date;
    NSMutableString *global_time_of_group;
    NSMutableString *global_name_of_teacher;
    NSMutableString *global_id_of_teacher;
    NSMutableString *global_name_of_branch;
    NSMutableString *global_description_of_branch;
    NSMutableString *global_coordinates_of_branch;
    NSMutableString *global_description;
    NSMutableString *global_img_of_teahcer;
    NSMutableString *global_schedule_of_group;
    NSMutableString *global_status_of_group;
    
    //Главная расписание
    NSMutableArray *Global_dayWeak;//дни недели и числа к ним, количество секций
    NSMutableDictionary *Global_scheduleDict;//по индексу элемента в массиве какие занятия в день
    NSMutableDictionary *Global_scheduleSchetchikId;//id,даты и статусы занятий в неделе
    NSMutableDictionary *Global_DBSchedule;//расписание из базы данных

    //Если незаполнен профиль
    NSMutableString *profileNotFill;
    
    //Профиль
    NSMutableString *g_fio;
    NSMutableString *g_phone;
    NSMutableString *g_mail;
    NSMutableString *g_minor;
    NSMutableString *g_gender;
    NSMutableString *g_birthday;
    NSMutableString *g_parent_fio;
    NSMutableString *g_parent_phone;
    NSMutableString *g_reg_password;
    
    //Процесс отмечания на занятие
    NSMutableString *global_check_in_id_of_notes;
    
    //Для работы бронью
    NSMutableString *g_r_id_of_reservation;
    NSMutableString *g_r_name_of_group;
    NSMutableString *g_r_dayweak_month_date;
    NSMutableString *g_r_time_of_group;
    NSMutableString *g_r_name_of_teacher;
    NSMutableString *g_r_name_of_abonement;
    NSMutableString *g_r_name_of_branch;
    NSMutableString *g_r_coordinates_of_branch;
    NSMutableString *g_r_status_of_resevation;
    NSMutableString *g_r_date_of_action;
    
    //Для работы с новой покупкой
    NSMutableString *g_r_id_base_of_abonement;
    NSMutableString *g_new_ab_cost;
    NSMutableString *g_new_ab_name;

    //Для работы админа
    NSMutableString *g_status_of_admin;
    NSMutableString *admin_id_of_group_with_date_of_action;
    
    //Для работы с уроками
    NSMutableString *lesson_id_of_notes;
    NSMutableString *lesson_date_of_buy;
    NSMutableString *lesson_about_abonement;
    
    //Для работы с историей абонемента
    NSMutableString *history_id_of_notes;
}
@property (nonatomic, retain) NSMutableString *global_url;

@property (nonatomic, retain) NSMutableString *status_of_registration;

@property (nonatomic, retain) NSMutableString *already_load_from_server;

//Для работы с группой
@property (nonatomic, retain) NSMutableString *global_id_of_group;
@property (nonatomic, retain) NSMutableString *global_date_of_action;
@property (nonatomic, retain) NSMutableString *global_name_of_group;
@property (nonatomic, retain) NSMutableString *global_dayweak_month_date;
@property (nonatomic, retain) NSMutableString *global_time_of_group;
@property (nonatomic, retain) NSMutableString *global_name_of_teacher;
@property (nonatomic, retain) NSMutableString *global_id_of_teacher;
@property (nonatomic, retain) NSMutableString *global_name_of_branch;
@property (nonatomic, retain) NSMutableString *global_description_of_branch;
@property (nonatomic, retain) NSMutableString *global_coordinates_of_branch;
@property (nonatomic, retain) NSMutableString *global_description;
@property (nonatomic, retain) NSMutableString *global_img_of_teacher;
@property (nonatomic, retain) NSMutableString *global_schedule_of_group;
@property (nonatomic, retain) NSMutableString *global_status_of_group;


//Главная расписание
@property (nonatomic, retain) NSMutableDictionary *Global_scheduleSchetchikId;
@property (nonatomic, retain) NSMutableDictionary *Global_DBSchedule;
@property (nonatomic, retain) NSMutableDictionary *Global_scheduleDict;
@property (nonatomic, retain) NSMutableArray *Global_scheduleDate;

//Если незаполнен профиль
@property (nonatomic, retain) NSMutableString *profileNotFill;

//Профиль
@property (nonatomic, retain) NSMutableString *g_fio;
@property (nonatomic, retain) NSMutableString *g_mail;
@property (nonatomic, retain) NSMutableString *g_phone;
@property (nonatomic, retain) NSMutableString *g_gender;
@property (nonatomic, retain) NSMutableString *g_birthday;
@property (nonatomic, retain) NSMutableString *g_parent_fio;
@property (nonatomic, retain) NSMutableString *g_parent_phone;
@property (nonatomic, retain) NSMutableString *g_minor;
@property (nonatomic, retain) NSMutableString *g_already_load_profile;
@property (nonatomic, retain) NSMutableString *g_reg_password;

//Процесс отмечания на занятие
@property (nonatomic, retain) NSMutableString *global_check_in_id_of_notes;

//Для работы бронью
@property (nonatomic, retain) NSMutableString *g_r_id_of_reservation;
@property (nonatomic, retain) NSMutableString *g_r_name_of_group;
@property (nonatomic, retain) NSMutableString *g_r_dayweak_month_date;
@property (nonatomic, retain) NSMutableString *g_r_time_of_group;
@property (nonatomic, retain) NSMutableString *g_r_name_of_teacher;
@property (nonatomic, retain) NSMutableString *g_r_name_of_abonement;
@property (nonatomic, retain) NSMutableString *g_r_name_of_branch;
@property (nonatomic, retain) NSMutableString *g_r_coordinates_of_branch;
@property (nonatomic, retain) NSMutableString *g_r_status_of_resevation;
@property (nonatomic, retain) NSMutableString *g_r_date_of_action;

//Для работы с новой покупкой
@property (nonatomic, retain) NSMutableString *g_id_base_of_abonement;
@property (nonatomic, retain) NSMutableString *g_new_ab_cost;
@property (nonatomic, retain) NSMutableString *g_new_ab_name;

//Для работы админа
@property (nonatomic, retain) NSMutableString *g_status_of_admin;
@property (nonatomic, retain) NSMutableString *admin_id_of_group_with_date_of_action;

//Для работы с уроками
@property (nonatomic, retain) NSMutableString *lesson_id_of_notes;
@property (nonatomic, retain) NSMutableString *lesson_date_of_buy;
@property (nonatomic, retain) NSMutableString *lesson_about_abonement;


//Для работы с историей абонемента
@property (nonatomic, retain) NSMutableString *history_id_of_notes;


+ (GlobalVariables *) sharedInstance;


@end

NS_ASSUME_NONNULL_END
