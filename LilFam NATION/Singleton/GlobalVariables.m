//
//  GlobalVariables.m
//  LilFam NATION
//
//  Created by Daniil Savva on 16.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "GlobalVariables.h"

@implementation GlobalVariables
@synthesize global_url, status_of_registration, global_id_of_group, global_date_of_action, global_name_of_group, global_dayweak_month_date, global_time_of_group, global_name_of_teacher, global_name_of_branch, global_description_of_branch, global_coordinates_of_branch, global_description, global_img_of_teacher, global_schedule_of_group, global_status_of_group, already_load_from_server, g_reg_password, Global_scheduleDate, Global_scheduleDict, Global_DBSchedule, Global_scheduleSchetchikId, profileNotFill, global_id_of_teacher, g_fio, g_mail, g_minor, g_phone, g_gender, g_birthday, g_parent_fio, g_parent_phone, g_already_load_profile, global_check_in_id_of_notes, g_r_name_of_group, g_r_time_of_group, g_r_name_of_branch, g_r_name_of_teacher, g_r_id_of_reservation, g_r_name_of_abonement, g_r_dayweak_month_date, g_r_status_of_resevation, g_r_coordinates_of_branch, g_r_date_of_action, g_id_base_of_abonement, g_new_ab_cost, g_new_ab_name, g_status_of_admin, admin_id_of_group_with_date_of_action, lesson_id_of_notes, lesson_date_of_buy, lesson_about_abonement, history_id_of_notes;

static GlobalVariables *_sharedInstance;

+ (GlobalVariables *) sharedInstance
{
    if(!_sharedInstance)
    {
        _sharedInstance = [[GlobalVariables alloc] init];
    }
    return _sharedInstance;
}


@end
