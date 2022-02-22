//
//  DAO.m
//  LilFam NATION
//
//  Created by Daniil Savva on 22.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "DAO.h"
#import "stdlib.h"

#import <CommonCrypto/CommonDigest.h>

@interface DAO ()

@end

@implementation DAO

- (void)viewDidLoad {
    [super viewDidLoad];
    
    file_manager = [NSFileManager defaultManager];
}

-(NSString *) check_registration_in_ios {
    
    // создание базы данных, проверка е, если что, создание основных таблиц для работы НАЧАЛО
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directiry
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir =dirPaths[0];
    
    
    //Build the Path to keep the database
    _datebasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"lilfamnation.sqlite"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if([filemgr fileExistsAtPath:_datebasePath] == YES){//СТРАННО, было написано NO и не работало
        const char *dbpath = [_datebasePath UTF8String];
        
        if(sqlite3_open(dbpath, &_DB) == SQLITE_OK){
            char *errorMessage;
            const char *sql_statement = "CREATE TABLE IF NOT EXISTS user_info (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, value TEXT)";
            
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK){
                //[self showUIAlertWithMessagr:@"Ошибка создания таблицы пользователя" andTitle:@"Ошибка"];
                NSLog(@"Ошибка создания базы данных: %s", sqlite3_errmsg(_DB));
            } else {
                NSLog(@"С базой данных проскочили");
            }
            
            //sqlite3_close(_DB);
        }
        else {
            //[self showUIAlertWithMessagr:@"Failed to open/create the table date_of_user" andTitle:@"Error"];
        }
    }
    else {
        NSLog(@"Не находит базу данных: %s", sqlite3_errmsg(_DB));
    }
    
    //написать местонахождение последних используемых файлов
    NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    // создание базы данных, проверка е, если что, создание основных таблиц для работы КОНЕЦ
    
    NSString *check_of_registration = @"0";
    
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [_datebasePath UTF8String];
    
    if(sqlite3_open(dbpath,&_DB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from user_info WHERE name = 'id_of_user' AND value != ''"];
        NSString *querySQL2 = [NSString stringWithFormat:@"SELECT * from user_info WHERE name = 'key_access' AND value != ''"];
        const char *query_statement = [querySQL UTF8String];
        const char *query_statement2 = [querySQL2 UTF8String];
        
        if((sqlite3_prepare_v2(_DB,query_statement,-1,&statement,NULL) == SQLITE_OK) && (sqlite3_prepare_v2(_DB,query_statement2,-1,&statement,NULL) == SQLITE_OK) ){
            if(sqlite3_step(statement) == SQLITE_ROW){
                //если запись есть, то ВОЗМОЖНО проверяем пользователя
                check_of_registration = @"1";
            }
            else {
                NSLog(@"Записи не найдены или ошибка в базе");
                check_of_registration = @"0";
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(_DB);
    
    
    return check_of_registration;
}


-(NSString *) insert_data_in_DB:(NSString *)id_of_action second:(NSString *)value {
    // создание базы данных, проверка е, если что, создание основных таблиц для работы НАЧАЛО
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directiry
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir =dirPaths[0];
    
    
    //Build the Path to keep the database
    _datebasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"lilfamnation.sqlite"]];
    
    //создаю таблицы, если их нет
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if([filemgr fileExistsAtPath:_datebasePath] == YES){//СТРАННО, было написано NO и не работало
        const char *dbpath = [_datebasePath UTF8String];
        
        if(sqlite3_open(dbpath, &_DB) == SQLITE_OK){
            char *errorMessage;
            const char *sql_statement = "CREATE TABLE IF NOT EXISTS user_info (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, value TEXT)";
            
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK){
                //[self showUIAlertWithMessagr:@"Ошибка создания таблицы пользователя" andTitle:@"Ошибка"];
                NSLog(@"РЕГИСТРАЦИЯ - таблица успешно создана");
            } else {
                NSLog(@"Ошибка создания базы данных ПРИ РЕГИСТРАЦИИ: %s", sqlite3_errmsg(_DB));
            }
            
            sqlite3_close(_DB);
        }
        else {
            //[self showUIAlertWithMessagr:@"Failed to open/create the table date_of_user" andTitle:@"Error"];
        }
    }
    else {
        NSLog(@"РЕГИСТРАЦИЯ - Не находит путь к базе данных");
    }
    
    
    
    
    sqlite3_stmt *statement;
    const char *dbpath = [_datebasePath UTF8String];
    
    //NSMutableString * answer_from_function;
    //достаем ключ 1 пользователя
    
    
    if(sqlite3_open(dbpath,&_DB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO user_info (NAME, value) VALUES (\"%@\",\"%@\")",id_of_action, value ];
        
        const char *insert_statement = [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        
        if(sqlite3_step(statement) == SQLITE_DONE){
            //[self showUIAlertWithMessagr:@"User added to the database" andTitle:@"Message"];
        }
        else {
            //[self showUIAlertWithMessagr:@"Ошибка при добавлении второго ключа доступа в базу данных" andTitle:@"Ошибка!"];
            NSLog(@"Ошибка добавлении: %s", sqlite3_errmsg(_DB));
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    
    
    return @"0";
}


-(NSString *) update_data_in_DB_value_1:(NSString *)id_of_action second:(NSString *)value {
    
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir =dirPaths[0];
    _datebasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"lilfamnation.sqlite"]];
    
    sqlite3_stmt *statement;
    const char *dbpath = [_datebasePath UTF8String];
    
    if(sqlite3_open(dbpath,&_DB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"UPDATE user_info SET value = '%@' WHERE NAME = '%@' ",value, id_of_action];
        
        const char *insert_statement = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        
        if(sqlite3_step(statement) == SQLITE_DONE){
            //NSLog(@"Запрос выполнен");
            NSLog(@"Запрос выполнен UPDATE user_info SET value = '%@' WHERE NAME = '%@' ",value, id_of_action);
        }
        else {
            NSLog(@"Ошибка выполнения запроса: %s", sqlite3_errmsg(_DB));
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
        
    }
    
    
    return @"0";
}




-(NSString *) select_value_1_from_DB:(NSString *)id_of_action {
    // создание базы данных, проверка е, если что, создание основных таблиц для работы НАЧАЛО
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directiry
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir =dirPaths[0];
    
    
    //Build the Path to keep the database
    _datebasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"lilfamnation.sqlite"]];
    
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [_datebasePath UTF8String];
    
    //NSMutableString * answer_from_function;
    //достаем ключ 1 пользователя
    
    
    if(sqlite3_open(dbpath,&_DB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT value FROM user_info WHERE name = \"%@\" ",id_of_action];
        const char *query_statement = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_DB,query_statement,-1,&statement,NULL) == SQLITE_OK){
            if(sqlite3_step(statement) == SQLITE_ROW){
                NSString *code = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,0)];
                answer_from_function = code;
                //NSLog(@"из класса ответ %@",key_access_1);
                //return id_of_action;
            }}}
    
    sqlite3_finalize(statement);
    sqlite3_close(_DB);
    return answer_from_function;
    //sqlite3_reset(statement);
}


-(void)delete_user_from_db {
    
}



-(void) clear_DB {
    // создание базы данных, проверка е, если что, создание основных таблиц для работы НАЧАЛО
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directiry
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir =dirPaths[0];
    
    
    //Build the Path to keep the database
    _datebasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"lilfamnation.sqlite"]];
    
    sqlite3_stmt *statement;
    const char *dbpath = [_datebasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK){
        //NSString  * query = @"DROP TABLE user_info";
        NSString  * query = @"UPDATE user_info set value = '' WHERE name != '' ";
        int rc = sqlite3_prepare_v2(_DB, [query UTF8String], -1, &statement, NULL);
        if(rc == SQLITE_OK){
            if(sqlite3_step(statement) == SQLITE_DONE){
                NSLog(@"Очистка базы данных прошла успешно");
            } else {
                NSLog(@"Ошибка ПРИ ОЧИСТКЕ: %s", sqlite3_errmsg(_DB));
            }
            sqlite3_finalize(statement);
            sqlite3_close(_DB);
        }
    }
}






-(void) check_exist_of_functional_strings {
    NSLog(@"Вызов функции check_exist_of_functional_strings");
    
    [self check_exist_of_functional_string:@"id_of_user"];
    [self check_exist_of_functional_string:@"key_access"];
    [self check_exist_of_functional_string:@"fio"];
    [self check_exist_of_functional_string:@"mail"];
    [self check_exist_of_functional_string:@"phone"];
    [self check_exist_of_functional_string:@"gender"];
    [self check_exist_of_functional_string:@"birth"];
    [self check_exist_of_functional_string:@"last_update_schedule"];
    [self check_exist_of_functional_string:@"minor"];
    [self check_exist_of_functional_string:@"parent_fio"];
    [self check_exist_of_functional_string:@"parent_phone"];
    
}

-(void) check_exist_of_functional_string:(NSString *)name_of_value {
    // создание базы данных, проверка е, если что, создание основных таблиц для работы НАЧАЛО
    NSString *docsDir;
    NSArray *dirPaths;
    
    //Get the directiry
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    
    //Build the Path to keep the database
    _datebasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"lilfamnation.sqlite"]];
    
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [_datebasePath UTF8String];
    
    if(sqlite3_open(dbpath,&_DB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from user_info WHERE name = '%@'",name_of_value];
        const char *query_statement = [querySQL UTF8String];
        
        if((sqlite3_prepare_v2(_DB,query_statement,-1,&statement,NULL) == SQLITE_OK)){
            if(sqlite3_step(statement) == SQLITE_ROW){
                NSLog(@"Проверка наличия строки %@ успешна, уже добавлена",name_of_value);
            } else {
                sqlite3_stmt *statement_insert = NULL;
                
                NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO user_info (NAME, value) VALUES ('%@','')",name_of_value];
                const char *insert_statement = [insertSQL UTF8String];
                sqlite3_prepare_v2(_DB, insert_statement, -1, &statement_insert, NULL);
                if(sqlite3_step(statement_insert) == SQLITE_DONE){
                    //[self showUIAlertWithMessagr:@"User added to the database" andTitle:@"Message"];
                     NSLog(@"Успешно добавили строку %@: %s",name_of_value, sqlite3_errmsg(_DB));
                }
                else {
                    //[self showUIAlertWithMessagr:@"Ошибка при добавлении второго ключа доступа в базу данных" andTitle:@"Ошибка!"];
                    NSLog(@"Ошибка ПРИ ДОБАВЛЕНИИ функиональной строки %@: %s",name_of_value, sqlite3_errmsg(_DB));
                }
                
            }
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(_DB);
    
}





-(void) delete_string_from_info_of_user:(NSString *)name_of_string {
    
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir =dirPaths[0];
    _datebasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"lilfamnation.sqlite"]];
    
    sqlite3_stmt *statement;
    const char *dbpath = [_datebasePath UTF8String];
    
    if(sqlite3_open(dbpath,&_DB) == SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"DELETE FROM user_info WHERE name = '%@' ", name_of_string];
        //NSLog(@"Выполненный запрос %@",insertSQL);
        
        const char *insert_statement = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        
        if(sqlite3_step(statement) == SQLITE_DONE){
            //NSLog(@"Запрос выполнен");
            
        }
        else {
            NSLog(@"Ошибка выполнения запроса: %s", sqlite3_errmsg(_DB));
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) check_exist_of_table_schedule {
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _datebasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"lilfamnation.sqlite"]];
    sqlite3_stmt *statement;
    const char *dbpath = [_datebasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK){
        NSString  * query = @"CREATE TABLE IF NOT EXISTS schedule (ID INTEGER PRIMARY KEY AUTOINCREMENT, id_of_group TEXT, name_of_group TEXT, time_of_group TEXT, teacher_of_group TEXT, id_of_teacher TEXT)";
        int rc = sqlite3_prepare_v2(_DB, [query UTF8String], -1, &statement, NULL);
        if(rc == SQLITE_OK){
            if(sqlite3_step(statement) == SQLITE_DONE){
                NSLog(@"Успешное добавление таблицы schedule");
            } else {
                NSLog(@"Ошибка ПРИ ПРОВЕРКЕ schedule: %s", sqlite3_errmsg(_DB));
            }
            sqlite3_finalize(statement);
            sqlite3_close(_DB);
        }
    }
}

-(void) check_exist_of_table_user_info {
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _datebasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"lilfamnation.sqlite"]];
    sqlite3_stmt *statement;
    const char *dbpath = [_datebasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK){
        NSString  * query = @"CREATE TABLE IF NOT EXISTS user_info (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, value TEXT)";
        int rc = sqlite3_prepare_v2(_DB, [query UTF8String], -1, &statement, NULL);
        if(rc == SQLITE_OK){
            if(sqlite3_step(statement) == SQLITE_DONE){
                NSLog(@"Успешное добавление таблицы user_info");
            } else {
                NSLog(@"Ошибка ПРИ ПРОВЕРКЕ schedule: %s", sqlite3_errmsg(_DB));
            }
            sqlite3_finalize(statement);
            sqlite3_close(_DB);
        }
    }
}

-(void) insert_group_of_schedule_in_DB:(NSString *)id_of_group two:(NSString *)name_of_group three:(NSString *)time_of_group four:(NSString *)teacher_of_group five:(NSString *)id_of_teacher {
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    _datebasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"lilfamnation.sqlite"]];
    sqlite3_stmt *statement;
    const char *dbpath = [_datebasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK){
        NSString  * query = [NSString stringWithFormat:@"INSERT INTO schedule (id_of_group, name_of_group, time_of_group, teacher_of_group, id_of_teacher) VALUES ('%@','%@','%@','%@','%@')", id_of_group, name_of_group, time_of_group, teacher_of_group, id_of_teacher];
        int rc = sqlite3_prepare_v2(_DB, [query UTF8String], -1, &statement, NULL);
        if(rc == SQLITE_OK){
            if(sqlite3_step(statement) == SQLITE_DONE){
                NSLog(@"Очистка базы данных прошла успешно");
            } else {
                NSLog(@"Ошибка ПРИ ОЧИСТКЕ: %s", sqlite3_errmsg(_DB));
            }
            sqlite3_finalize(statement);
            sqlite3_close(_DB);
        }
    }
}




@end
