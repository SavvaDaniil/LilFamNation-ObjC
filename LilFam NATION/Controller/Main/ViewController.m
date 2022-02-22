//
//  ViewController.m
//  LilFam NATION
//
//  Created by Daniil Savva on 15.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "ViewController.h"


#import "LeftMenu.h"
#import "SceneDelegate.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"


#import "Schedule.h"
#import "GlobalVariables.h"

#import "DAO.h"
#import "ConnectToServer.h"


@interface ViewController ()

@end

@implementation ViewController {
    NSArray *catalogTable_h;
    NSArray *catalogTable_g;
    NSArray *catalogTable_d;
    NSArray *scheduleDate;
    NSMutableString *name_of_image_for_btn_of_catalogTable;
    
    NSDictionary *scheduleDict;
    NSDictionary *scheduleSchetchikId;
    NSDictionary *DBSchedule;
    
    NSMutableArray *scheduleDate2;//дни недели и числа к ним, количество секций
    
    NSMutableDictionary *scheduleDict2;//по индексу элемента в массиве какие занятия в день
    NSDictionary *scheduleSchetchikId2;//id,даты и статусы занятий в неделе
    NSDictionary *DBSchedule2;//расписание из базы данных
    
    NSDictionary *fullAnswer;
    NSMutableArray *array_with_zanyatiya_in_day;
    NSMutableDictionary *dict_with_zanyatiya_in_day;
    
    NSMutableArray *day0;
    NSMutableArray *day1;
    NSMutableArray *day2;
    NSMutableArray *day3;
    NSMutableArray *day4;
    NSMutableArray *day5;
    NSMutableArray *day6;
    
    NSMutableArray *day7;
    NSMutableArray *day8;
    NSMutableArray *day9;
    NSMutableArray *day10;
    NSMutableArray *day11;
    NSMutableArray *day12;
    NSMutableArray *day13;
    NSMutableArray *day14;
    NSMutableArray *day15;
    NSMutableArray *day16;
    NSMutableArray *day17;
    NSMutableArray *day18;
    NSMutableArray *day19;
    NSMutableArray *day20;
    NSMutableArray *day21;
    NSMutableArray *day22;
    NSMutableArray *day23;
    NSMutableArray *day24;
    NSMutableArray *day25;
    NSMutableArray *day26;
    NSMutableArray *day27;
    NSMutableArray *day28;
    NSMutableArray *day29;
    NSMutableArray *day30;
    
    
    NSMutableArray *day_iteration;
    NSMutableDictionary *schetchik_group_and_data_of_group;
    NSMutableArray *schetchik_group_and_data_of_group2;
    NSInteger id_of_notes_of_group;
    NSMutableDictionary *data_of_group_iteration;
}
@synthesize catalogTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Основной адрес сайта
    //[GlobalVariables sharedInstance].global_url = [NSMutableString stringWithString:@"https://deadboyshow.info/application"];
    [GlobalVariables sharedInstance].global_url = [NSMutableString stringWithString:@"https://lilfam.com/application"];
    
    
    //NSLog(@" Проверка шифрования %@",[AES128Encrypt AES128Decrypt:@"example" key:@"A262B453cE794b0E"]);
    /*
    ConnectToServer *cts = [ConnectToServer alloc];
    cts = [cts init];
    NSString *randomString = [cts getRandomString];
    */
    
    
    /*
    NSString *plainText = @"IAmThePlainText";
    NSString *key = @"a16byteslongkey!a16byteslongkey!";
     
    NSString *encrypt = [self AES128Encrypt:plainText key:key];
    NSLog(@"Результат %@", encrypt);
    
    
    NSLog(@"Проверка правильного %@", [self AES128Decrypt:encrypt key:key]);
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSData* key_data = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Новый вриант %@",[[NSString alloc] initWithData:[self aesCBCEncrypt:data key:key_data] encoding:NSUTF8StringEncoding]);
     
    NSString *encryptedData = [AESCrypt encrypt:plainText password:key];
    NSLog(@"Новый %@",encryptedData);
    NSString *message = [AESCrypt decrypt:@"mDEPCbx/jxOLu2ojD/mPmw==" password:key];
    NSLog(@"Расшифрованный %@",message);
    */
    
    
    
    
    
    
    
    DAO *code = [DAO alloc];
    code = [code init];
    NSString *check_of_registration = [code check_registration_in_ios];
    [code check_exist_of_table_schedule];
    [code check_exist_of_table_user_info];
    [code check_exist_of_functional_strings];
    //[code clear_DB];
    /*
    DAO *code2 = [DAO alloc];
    code2 = [code2 init];
    [code2 clear_DB];
    */
    
    if([check_of_registration isEqualToString:@"0"]){
        [GlobalVariables sharedInstance].status_of_registration = [NSMutableString stringWithString:@"0"];
        NSLog(@"ПРОВЕРКА НА РЕГИСТРАЦИЮ ПРОВАЛИЛАСЬ");
    }
    if([check_of_registration isEqualToString:@"1"]){
        NSLog(@"ПРОВЕРКА НА РЕГИСТРАЦИЮ ПРОШЛА УСПЕШНО");
        [GlobalVariables sharedInstance].status_of_registration = [NSMutableString stringWithString:@"1"];
    }
    
    
    catalogTable_g = [NSArray arrayWithObjects:@"Группа 1",@"Группа 2", nil];
    scheduleDate = [NSArray arrayWithObjects:@"СУББОТА / НОЯБРЬ 16",@"ВОСКРЕСЕНЬЕ / НОЯБРЬ 17",nil];

    //catalogTable.hidden = TRUE;
    catalogTable.alwaysBounceVertical = NO;
    
    array_with_zanyatiya_in_day = [[NSMutableArray alloc] init];
    scheduleDict2 = [[NSMutableDictionary alloc] init];
    scheduleDate2 = [[NSMutableArray alloc] init];
    dict_with_zanyatiya_in_day = [[NSMutableDictionary alloc] init];
    data_of_group_iteration = [[NSMutableDictionary alloc] init];
    schetchik_group_and_data_of_group = [[NSMutableDictionary alloc] init];
    schetchik_group_and_data_of_group2 = [[NSMutableArray alloc] init];
    
    //один раз будет грузиться
    DBSchedule = @{
        @"3" : @{
            @"name_of_group":@"Группа 2",
            @"time_of_group":@"10:00",
            @"teacher_of_group":@"Преподаватель группы 2"
        },
        @"12" : @{
            @"name_of_group":@"Группа 1",
            @"time_of_group":@"9:00",
            @"teacher_of_group":@"Преподаватель группы 1"
        },
        @"15" : @{
            @"name_of_group":@"Группа 3",
            @"time_of_group":@"9:00",
            @"teacher_of_group":@"Преподаватель группы 3"
        }
    };
    
    
    //ниже грузится с сервера
    scheduleSchetchikId = @{
        @"3":@{
            @"id_of_group":@"3",
            @"date_of_action":@"2019-11-16",
            @"status":@"1",
            @"id_of_day_of_weak":@"0"
        },
        @"4":@{
            @"id_of_group":@"12",
            @"date_of_action":@"2019-11-16",
            @"status":@"1",
            @"id_of_day_of_weak":@"0"
        },
        @"5":@{
            @"id_of_group":@"15",
            @"date_of_action":@"2019-11-16",
            @"status":@"1",
            @"id_of_day_of_weak":@"1"
        }
    };
    
    scheduleDict = @{
        @"0": @[@"4",@"3"],
        @"1": @[@"5"]
        
    };
    //NSLog(@"%@",[[scheduleSchetchikId valueForKey:@"3"] valueForKey:@"name_of_group"]);
    
    

   if(![[GlobalVariables sharedInstance].already_load_from_server isEqual: @"1"]){
       id_of_notes_of_group = 0;
       [self reload_schedule];
   } else {
       NSLog(@"УЖЕ ЗАГРУЖЕНО");
       scheduleDate2 = [GlobalVariables sharedInstance].Global_scheduleDate;
       DBSchedule2 = [GlobalVariables sharedInstance].Global_DBSchedule;
       scheduleSchetchikId2 = [GlobalVariables sharedInstance].Global_scheduleSchetchikId;
       scheduleDict2 = [GlobalVariables sharedInstance].Global_scheduleDict;
       //catalogTable.hidden = FALSE;
   }
    
}
- (IBAction)openLeftMenuButton:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}




/*
- (NSData *)aesCBCEncrypt:(NSData *)data key:(NSData *)key{
    CCCryptorStatus ccStatus   = kCCSuccess;
    int             ivLength   = kCCBlockSizeAES128;
    size_t          cryptBytes = 0;
    NSMutableData  *dataOut    = [NSMutableData dataWithLength:ivLength + data.length + kCCBlockSizeAES128];

    SecRandomCopyBytes(kSecRandomDefault, ivLength, dataOut.mutableBytes);

    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithmAES,
                       kCCOptionPKCS7Padding,
                       key.bytes, key.length,
                       dataOut.bytes,
                       data.bytes, data.length,
                       dataOut.mutableBytes + ivLength, dataOut.length,
                       &cryptBytes);
    
    
    if (ccStatus == kCCSuccess) {
        dataOut.length = cryptBytes + ivLength;
    }
    else {
        dataOut = nil;
    }

    return dataOut;
}

-(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    NSData *resultData = nil;
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        // resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        resultData = [[NSData alloc] initWithBytes:buffer length:numBytesEncrypted];
    }
    free(buffer);
    // return [Base64 stringByEncodingData:resultData];
    return [self hexStringFromData:resultData];
}

-(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
{
    NSData *resultData = nil;
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // NSData *data = [Base64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    // encryptText = [self stringFromHexString:encryptText];
    NSData *data = [NSData dataFromBase64String:encryptText];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        // resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        resultData = [[NSData alloc] initWithBytes:buffer length:numBytesCrypted];
        
    }
    free(buffer);
    return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
}

// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
    
    
}

// 普通字符串转换为十六进

- (NSString *)hexStringFromData:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    // 下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff]; //16进制数
        newHexStr = [newHexStr uppercaseString];
        
        if([newHexStr length] == 1) {
            newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
        }
        
        hexStr = [hexStr stringByAppendingString:newHexStr];
       
    }
    return hexStr;
}
*/






-(void)reload_schedule {
    NSLog(@"Выполнение запроса на сервер");
    
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/schedule.php",[GlobalVariables sharedInstance].global_url]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
      if (error) {
          //NSLog(@"Error,%@", [error localizedDescription]);
          UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Не удалось установить соединение с сервером" preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:NULL];
          [alert addAction:okAction];
          dispatch_async(dispatch_get_main_queue(), ^(void){
               [self presentViewController:alert animated:true completion:nil];
          });
      } else {
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
          

        NSError *jsonError;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError != nil) {
            NSLog(@"JSON isn't right:%@",jsonError);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка сети" message:@"Ошибка на стороне сервера" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            }];
            UIAlertAction *tryAganin = [UIAlertAction actionWithTitle:@"Попробовать снова" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self reload_schedule];
            }];
            [alert addAction:tryAganin];
            [alert addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                 [self presentViewController:alert animated:true completion:nil];
            });
        } else {
            NSLog(@"%@",jsonDict);
            self->fullAnswer = jsonDict;
            self->scheduleDate2 = [jsonDict objectForKey:@"scheduledate"];
            self->scheduleSchetchikId2 = [jsonDict objectForKey:@"scheduleschetchikid"];
            self->DBSchedule2 = [jsonDict objectForKey:@"dbschedule"];
            
            self->day0 = [jsonDict objectForKey:@"day0"];
            self->day1 = [jsonDict objectForKey:@"day1"];
            self->day2 = [jsonDict objectForKey:@"day2"];
            self->day3 = [jsonDict objectForKey:@"day3"];
            self->day4 = [jsonDict objectForKey:@"day4"];
            self->day5 = [jsonDict objectForKey:@"day5"];
            self->day6 = [jsonDict objectForKey:@"day6"];
    
            self->day7 = [jsonDict objectForKey:@"day7"]; self->day8 = [jsonDict objectForKey:@"day8"]; self->day9 = [jsonDict objectForKey:@"day9"]; self->day10 = [jsonDict objectForKey:@"day10"]; self->day11 = [jsonDict objectForKey:@"day11"]; self->day12 = [jsonDict objectForKey:@"day12"]; self->day13 = [jsonDict objectForKey:@"day13"]; self->day14 = [jsonDict objectForKey:@"day14"]; self->day15 = [jsonDict objectForKey:@"day15"]; self->day16 = [jsonDict objectForKey:@"day16"]; self->day17 = [jsonDict objectForKey:@"day17"]; self->day18 = [jsonDict objectForKey:@"day18"]; self->day19 = [jsonDict objectForKey:@"day19"]; self->day20 = [jsonDict objectForKey:@"day20"]; self->day21 = [jsonDict objectForKey:@"day21"]; self->day22 = [jsonDict objectForKey:@"day22"]; self->day23 = [jsonDict objectForKey:@"day23"]; self->day24 = [jsonDict objectForKey:@"day24"]; self->day25 = [jsonDict objectForKey:@"day25"]; self->day26 = [jsonDict objectForKey:@"day26"]; self->day27 = [jsonDict objectForKey:@"day27"]; self->day28 = [jsonDict objectForKey:@"day28"]; self->day29 = [jsonDict objectForKey:@"day29"]; self->day30 = [jsonDict objectForKey:@"day30"];
                
            //вставляем временный словарь в общий массив с группами по ключу
            //[schetchik_group_and_data_of_group setObject:data_of_group_iteration forKey:[NSString stringWithFormat:@"%ld",(long)id_of_notes_of_group]];
            
            //[self->schetchik_group_and_data_of_group2 addObject:self->data_of_group_iteration];
            
            self->id_of_notes_of_group = 1;
            for(int i=0; i < self->day0.count; i++){
                NSDictionary *myDict = [self write_to_dict:self->day0 number_of_lesson:i number_of_day:0];
                [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]];
                self->id_of_notes_of_group = self->id_of_notes_of_group + 1;
                [self->data_of_group_iteration removeAllObjects];
            }
            for(int i=0; i < self->day1.count; i++){
                NSDictionary *myDict = [self write_to_dict:self->day1 number_of_lesson:i number_of_day:1];
                [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]];
                self->id_of_notes_of_group = self->id_of_notes_of_group + 1;
                [self->data_of_group_iteration removeAllObjects];
            }
            for(int i=0; i < self->day2.count; i++){
                NSDictionary *myDict = [self write_to_dict:self->day2 number_of_lesson:i number_of_day:2];
                [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]];
                self->id_of_notes_of_group = self->id_of_notes_of_group + 1;
                [self->data_of_group_iteration removeAllObjects];
            }
            for(int i=0; i < self->day3.count; i++){
                NSDictionary *myDict = [self write_to_dict:self->day3 number_of_lesson:i number_of_day:3];
                [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]];
                self->id_of_notes_of_group = self->id_of_notes_of_group + 1;
                [self->data_of_group_iteration removeAllObjects];
            }
            for(int i=0; i < self->day4.count; i++){
                NSDictionary *myDict = [self write_to_dict:self->day4 number_of_lesson:i number_of_day:4];
                [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]];
                self->id_of_notes_of_group = self->id_of_notes_of_group + 1;
                [self->data_of_group_iteration removeAllObjects];
            }
            for(int i=0; i < self->day5.count; i++){
                NSDictionary *myDict = [self write_to_dict:self->day5 number_of_lesson:i number_of_day:5];
                [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]];
                self->id_of_notes_of_group = self->id_of_notes_of_group + 1;
                [self->data_of_group_iteration removeAllObjects];
            }
            for(int i=0; i < self->day6.count; i++){
                NSDictionary *myDict = [self write_to_dict:self->day6 number_of_lesson:i number_of_day:6];
                [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]];
                self->id_of_notes_of_group = self->id_of_notes_of_group + 1;
                [self->data_of_group_iteration removeAllObjects];
            }
            
            for(int i=0; i < self->day7.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day7 number_of_lesson:i number_of_day:7]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day8.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day8 number_of_lesson:i number_of_day:8]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day9.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day9 number_of_lesson:i number_of_day:9]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day10.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day10 number_of_lesson:i number_of_day:10]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day11.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day11 number_of_lesson:i number_of_day:11]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day12.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day12 number_of_lesson:i number_of_day:12]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day13.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day13 number_of_lesson:i number_of_day:13]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day14.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day14 number_of_lesson:i number_of_day:14]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day15.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day15 number_of_lesson:i number_of_day:15]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day16.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day16 number_of_lesson:i number_of_day:16]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day17.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day17 number_of_lesson:i number_of_day:17]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]];self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day18.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day18 number_of_lesson:i number_of_day:18]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day19.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day19 number_of_lesson:i number_of_day:19]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day20.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day20 number_of_lesson:i number_of_day:20]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day21.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day21 number_of_lesson:i number_of_day:21]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day22.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day22 number_of_lesson:i number_of_day:22]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day23.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day23 number_of_lesson:i number_of_day:23]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day24.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day24 number_of_lesson:i number_of_day:24]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day25.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day25 number_of_lesson:i number_of_day:25]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day26.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day26 number_of_lesson:i number_of_day:26]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day27.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day27 number_of_lesson:i number_of_day:27]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day28.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day28 number_of_lesson:i number_of_day:28]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day29.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day29 number_of_lesson:i number_of_day:29]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; } for(int i=0; i < self->day30.count; i++){ NSDictionary *myDict = [self write_to_dict:self->day30 number_of_lesson:i number_of_day:30]; [self->schetchik_group_and_data_of_group setValue:myDict forKey:[NSString stringWithFormat:@"%ld",(long)self->id_of_notes_of_group]]; self->id_of_notes_of_group = self->id_of_notes_of_group + 1; [self->data_of_group_iteration removeAllObjects]; }
            /*
            //это массив
            //NSLog(@"%@",[jsonDict objectForKey:@"array_schedule"][0]);
            
            //заполняем массив по дням
            for(int day = 0; day <= 6; day++){
                NSInteger chislo_zanyatiy = [[jsonDict objectForKey:@"array_schedule"][day][0] integerValue];
                NSLog(@"ЗАГРУЗКА полученное в день %d число занятий %ld",day,(long)chislo_zanyatiy);
                
                for(int zanyatie = 1; zanyatie <= chislo_zanyatiy; zanyatie++){
                    NSLog(@"%@",[jsonDict objectForKey:@"array_schedule"][day][zanyatie]);
                    [self->array_with_zanyatiya_in_day addObject:[jsonDict objectForKey:@"array_schedule"][day][zanyatie]];
                   
                }
                NSLog(@"Добавляем %@",self->array_with_zanyatiya_in_day);
                //[self->scheduleDict2 addObject:self->array_with_zanyatiya_in_day];
                //[self->scheduleDict2 setObject:self->array_with_zanyatiya_in_day forKey:[NSString stringWithFormat:@"%d",day]];
                
                NSArray *myArray = [[NSArray alloc] initWithArray:self->array_with_zanyatiya_in_day];
                [self->scheduleDict2 setObject:myArray forKey:[NSString stringWithFormat:@"%d",day]];
                
                [self->array_with_zanyatiya_in_day removeAllObjects];
            }
            
            NSLog(@"scheduleDict2 = %@",self->scheduleDict2);
            
            
            //ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ - НАЧАЛО
            [GlobalVariables sharedInstance].Global_scheduleDate = self->scheduleDate2;
            [GlobalVariables sharedInstance].Global_DBSchedule = [NSMutableDictionary dictionaryWithDictionary:self->DBSchedule2];
            [GlobalVariables sharedInstance].Global_scheduleSchetchikId = [NSMutableDictionary dictionaryWithDictionary:self->scheduleSchetchikId2];
            [GlobalVariables sharedInstance].Global_scheduleDict = [NSMutableDictionary dictionaryWithDictionary:self->scheduleDict2];
            //ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ - КОНЕЦ
            
            
            [GlobalVariables sharedInstance].already_load_from_server = [NSMutableString stringWithString:@"1"];
            //self->catalogTable.hidden = FALSE;
            */
            
            dispatch_async(dispatch_get_main_queue(),^{
                NSLog(@"Асинхронное обновление");
                self->id_of_notes_of_group = 0;
                [self.catalogTable reloadData];
            });
        }
          
      }
    }];
}

-(NSDictionary *)write_to_dict:(NSMutableArray *)day_parametr number_of_lesson:(NSInteger)number_of_lesson number_of_day:(int)number_of_day {
    
    NSDictionary *myDict = @{
        @"id_of_group":[[day_parametr objectAtIndex:number_of_lesson] valueForKey:@"id_of_group"],
        @"name_of_group":[[day_parametr objectAtIndex:number_of_lesson] valueForKey:@"name_of_group"],
        @"date_of_action":[[day_parametr objectAtIndex:number_of_lesson] valueForKey:@"date_of_action"],
        @"time_of_group":[[day_parametr objectAtIndex:number_of_lesson] valueForKey:@"time_of_group"],
        @"teacher_of_group":[[day_parametr objectAtIndex:number_of_lesson] valueForKey:@"teacher_of_group"],
        @"name_of_branch":[[day_parametr objectAtIndex:number_of_lesson] valueForKey:@"name_of_branch"],
        @"description_of_branch":[[day_parametr objectAtIndex:number_of_lesson] valueForKey:@"description_of_branch"],
        @"coordinates_of_branch":[[day_parametr objectAtIndex:number_of_lesson] valueForKey:@"coordinates_of_branch"],
        @"id_of_teacher":[[day_parametr objectAtIndex:number_of_lesson] valueForKey:@"id_of_teacher"],
        @"dayweak_month_date":[scheduleDate2 objectAtIndex:number_of_day]
    };
    /*,
     @"dayweak_month_date":[[day_parametr objectAtIndex:number_of_lesson] valueForKey:@"dayweak_month_date"]
     */
    return myDict;
}

-(IBAction)refreshTable {
    [self reload_schedule];
    
    /*
  NSString *SchetchikId = [NSString stringWithFormat:@"%@", [[[JSON objectForKey:@"array_schedule"] valueForKey:@"0"] objectAtIndex:0]];
  NSLog(@"scheduleSchetchikId = %@",SchetchikId);
  
  NSLog(@"Прочитал %@",[[[JSON objectForKey:@"scheduleschetchikid"] valueForKey:SchetchikId] valueForKey:@"id_of_group"]);
  */
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 2;
    return [scheduleDate2 count];
}

//количество записей в каждой секции. Количество занятий в день
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [catalogTable_g count];
    
    if(section == 0){
        day_iteration = day0;
    }
    if(section == 1){
        day_iteration = day1;
    }
    if(section == 2){
        day_iteration = day2;
    }
    if(section == 3){
        day_iteration = day3;
    }
    if(section == 4){
        day_iteration = day4;
    }
    if(section == 5){
        day_iteration = day5;
    }
    if(section == 6){
        day_iteration = day6;
    }
    
    if(section == 7){ day_iteration = day7; } if(section == 8){ day_iteration = day8; } if(section == 9){ day_iteration = day9; } if(section == 10){ day_iteration = day10; } if(section == 11){ day_iteration = day11; } if(section == 12){ day_iteration = day12; } if(section == 13){ day_iteration = day13; } if(section == 14){ day_iteration = day14; } if(section == 15){ day_iteration = day15; } if(section == 16){ day_iteration = day16; } if(section == 17){ day_iteration = day17; } if(section == 18){ day_iteration = day18; } if(section == 19){ day_iteration = day19; } if(section == 20){ day_iteration = day20; } if(section == 21){ day_iteration = day21; } if(section == 22){ day_iteration = day22; } if(section == 23){ day_iteration = day23; } if(section == 24){ day_iteration = day24; } if(section == 25){ day_iteration = day25; } if(section == 26){ day_iteration = day26; } if(section == 27){ day_iteration = day27; } if(section == 28){ day_iteration = day28; } if(section == 29){ day_iteration = day29; } if(section == 30){ day_iteration = day30; }
    
    //NSLog(@"Проверяем день с занятиями %@ то есть секция %ld",day_iteration,(long)section);
    
    //return [[scheduleDict2 valueForKey:[NSString stringWithFormat:@"%ld",(long)section]] count];
    return [day_iteration count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"Обновляем таблицу");
    static NSString *simpleTableIdentifier = @"catalogTable";
 
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    Schedule *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    //UITableViewCellStyleSubtitle - с кратким описанием
    
    
    if((long)indexPath.section == 0){
        day_iteration = day0;
    }
    if((long)indexPath.section == 1){
        day_iteration = day1;
    }
    if((long)indexPath.section == 2){
        day_iteration = day2;
    }
    if((long)indexPath.section == 3){
        day_iteration = day3;
    }
    if((long)indexPath.section == 4){
        day_iteration = day4;
    }
    if((long)indexPath.section == 5){
        day_iteration = day5;
    }
    if((long)indexPath.section == 6){
        day_iteration = day6;
    }
    
    if((long)indexPath.section == 7){ day_iteration = day7; } if((long)indexPath.section == 8){ day_iteration = day8; } if((long)indexPath.section == 9){ day_iteration = day9; } if((long)indexPath.section == 10){ day_iteration = day10; } if((long)indexPath.section == 11){ day_iteration = day11; } if((long)indexPath.section == 12){ day_iteration = day12; } if((long)indexPath.section == 13){ day_iteration = day13; } if((long)indexPath.section == 14){ day_iteration = day14; } if((long)indexPath.section == 15){ day_iteration = day15; } if((long)indexPath.section == 16){ day_iteration = day16; } if((long)indexPath.section == 17){ day_iteration = day17; } if((long)indexPath.section == 18){ day_iteration = day18; } if((long)indexPath.section == 19){ day_iteration = day19; } if((long)indexPath.section == 20){ day_iteration = day20; } if((long)indexPath.section == 21){ day_iteration = day21; } if((long)indexPath.section == 22){ day_iteration = day22; } if((long)indexPath.section == 23){ day_iteration = day23; } if((long)indexPath.section == 24){ day_iteration = day24; } if((long)indexPath.section == 25){ day_iteration = day25; } if((long)indexPath.section == 26){ day_iteration = day26; } if((long)indexPath.section == 27){ day_iteration = day27; } if((long)indexPath.section == 28){ day_iteration = day28; } if((long)indexPath.section == 29){ day_iteration = day29; } if((long)indexPath.section == 30){ day_iteration = day30; }

    
    id_of_notes_of_group = id_of_notes_of_group + 1;
    //NSLog(@"id_of_notes_of_group = %ld",(long)id_of_notes_of_group);
    
    //NSLog(@"Проверяем номер ячейки %ld для секции %ld",(long)indexPath.row,(long)indexPath.section);
    
    cell.groupTime.text = [[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"time_of_group"];
    cell.groupName.text = [[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"name_of_group"];
    cell.groupTeacher.text = [[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"name_of_branch"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if([[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"status_of_group"] isEqualToString:@"0"]){
        cell.groupTime.textColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
        cell.groupName.textColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
        cell.groupTeacher.textColor = [UIColor colorWithRed:192.0f/255.0f green:192.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
        cell.groupTeacher.text = [NSString stringWithFormat:@"%@ - ОТМЕНА",[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"name_of_branch"]];
    } else if([[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"status_of_group"] isEqualToString:@"3"]){
        
        cell.groupTime.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        cell.groupName.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
        cell.groupTeacher.textColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    } else {
        /*
        cell.groupTime.textColor = [UIColor blackColor];
        cell.groupName.textColor = [UIColor blackColor];
        cell.groupTeacher.textColor = [UIColor blackColor];
         */
        if (@available(iOS 13.0, *)) {
            if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
                cell.groupTime.textColor = [UIColor whiteColor];
                cell.groupName.textColor = [UIColor whiteColor];
                cell.groupTeacher.textColor = [UIColor whiteColor];
            } else {
                cell.groupTime.textColor = [UIColor blackColor];
                cell.groupName.textColor = [UIColor blackColor];
                cell.groupTeacher.textColor = [UIColor blackColor];
            }
        } else {
            cell.groupTime.textColor = [UIColor blackColor];
            cell.groupName.textColor = [UIColor blackColor];
            cell.groupTeacher.textColor = [UIColor blackColor];
        }
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)id_of_notes_of_group];
    
    //очищаем временный словарь
    //[data_of_group_iteration removeAllObjects];
    /*
    //заполняем словарь по ключам данными
    [data_of_group_iteration setObject:[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"id_of_group"] forKey:@"id_of_group"];
    [data_of_group_iteration setObject:[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"name_of_group"] forKey:@"name_of_group"];
    [data_of_group_iteration setObject:[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"date_of_action"] forKey:@"date_of_action"];
    [data_of_group_iteration setObject:[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"time_of_group"] forKey:@"time_of_group"];
    [data_of_group_iteration setObject:[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"teacher_of_group"] forKey:@"teacher_of_group"];
    [data_of_group_iteration setObject:[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"name_of_branch"] forKey:@"name_of_branch"];
    [data_of_group_iteration setObject:[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"description_of_branch"] forKey:@"description_of_branch"];
    [data_of_group_iteration setObject:[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"coordinates_of_branch"] forKey:@"coordinates_of_branch"];
    [data_of_group_iteration setObject:[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"id_of_teacher"] forKey:@"id_of_teacher"];
    [data_of_group_iteration setObject:[NSMutableString stringWithString:[scheduleDate2 objectAtIndex:(long)indexPath.section]] forKey:@"dayweak_month_date"];
    
    //вставляем временный словарь в общий массив с группами по ключу
    //[schetchik_group_and_data_of_group setObject:data_of_group_iteration forKey:[NSString stringWithFormat:@"%ld",(long)id_of_notes_of_group]];
    [schetchik_group_and_data_of_group setValue:data_of_group_iteration forKey:[NSString stringWithFormat:@"%ld",(long)id_of_notes_of_group]];
    [schetchik_group_and_data_of_group2 addObject:data_of_group_iteration];
    */
    //NSLog(@"Записанный ключ %ld группы %@",(long)id_of_notes_of_group, data_of_group_iteration);
    
    
    
    
    
    //[id_of_group_and_date_of_group setObject:nextValue forKey:(long)id_of_notes_of_group]];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)id_of_notes_of_group];
    
    //cell.textLabel.text = [NSString stringWithFormat:@"%@_%@",[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"id_of_group"], [[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"date_of_action"]];
    cell.textLabel.text = [NSString stringWithString:[[day_iteration objectAtIndex:(long)indexPath.row] valueForKey:@"id_of_group_and_date_of_action"]];
    cell.textLabel.hidden = true;
    
    
    /*
    NSLog(@"Проверяем номер ячейки %ld",(long)indexPath.row);
    
    
    //NSLog(@"Рисуются назянтия из секции %ld",(long)indexPath.section);
    //cell.groupTime.text = [scheduleSchetchikId valueForKey:[scheduleDict valueForKey:]];
    NSString *dayId = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
    NSLog(@"Проверяем день по счету %@",dayId);
    NSString *SchetchikId = [NSString stringWithFormat:@"%@", [[scheduleDict2 valueForKey:dayId] objectAtIndex:indexPath.row]];
    NSLog(@"Получаем временный индекс группы scheduleSchetchikId = %@",SchetchikId);
    
    NSLog(@"Прочитал id_of_group %@ ищем данные о ней в базе данных расписания полученной",[[scheduleSchetchikId2 valueForKey:SchetchikId] valueForKey:@"id_of_group"]);
    
    NSString *id_of_group = [[scheduleSchetchikId2 valueForKey:SchetchikId] valueForKey:@"id_of_group"];
    
    cell.groupTime.text = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"time_of_group"];
    cell.groupName.text = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"name_of_group"];
    //cell.groupTeacher.text = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"teacher_of_group"];
    cell.groupTeacher.text = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"name_of_branch"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if([[[DBSchedule2 valueForKey:id_of_group] valueForKey:@"status"] isEqualToString:@"0"]){
        cell.groupTime.textColor = [UIColor redColor];
        cell.groupName.textColor = [UIColor redColor];
        cell.groupTeacher.textColor = [UIColor redColor];
        cell.groupTeacher.text = [NSString stringWithFormat:@"%@ - ОТМЕНА",[[DBSchedule2 valueForKey:id_of_group] valueForKey:@"name_of_branch"]];
    }
    
    cell.textLabel.text = SchetchikId;
    cell.textLabel.hidden = true;
    */
    
    
    return cell;
}

 -(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    [label setTextColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    
    NSString *string = [scheduleDate2 objectAtIndex:section];
    //NSString *string = @"СУББОТА / НОЯБРЬ 16";
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"Был выбран пункт %ld",(long)indexPath.row);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    NSLog(@"Был выбран пункт %@",cellText);
    
    //NSInteger cellTextInt = [cellText integerValue];
    
    if(indexPath.row != 0){
        
    }
    
    /*
    //узнаем данные о группе
    NSString *id_of_group = [[scheduleSchetchikId2 valueForKey:cellText] valueForKey:@"id_of_group"];
    
    [GlobalVariables sharedInstance].global_id_of_group = [NSMutableString stringWithString:id_of_group];
    [GlobalVariables sharedInstance].global_date_of_action = [[scheduleSchetchikId2 valueForKey:cellText] valueForKey:@"date_of_action"];
    
    [GlobalVariables sharedInstance].global_name_of_group = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"name_of_group"];
    [GlobalVariables sharedInstance].global_time_of_group = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"time_of_group"];
    [GlobalVariables sharedInstance].global_name_of_teacher = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"teacher_of_group"];
    [GlobalVariables sharedInstance].global_name_of_branch = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"name_of_branch"];
    [GlobalVariables sharedInstance].global_description_of_branch = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"description_of_branch"];
    NSLog(@"[GlobalVariables sharedInstance].global_description_of_branch = %@",[GlobalVariables sharedInstance].global_description_of_branch);
    [GlobalVariables sharedInstance].global_coordinates_of_branch = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"coordinates_of_branch"];
    [GlobalVariables sharedInstance].global_id_of_teacher = [[DBSchedule2 valueForKey:id_of_group] valueForKey:@"id_of_teacher"];
    
    //день занятия
    NSInteger b = [[[scheduleSchetchikId2 valueForKey:cellText] valueForKey:@"id_of_day_of_weak"] integerValue];
    [GlobalVariables sharedInstance].global_dayweak_month_date = [NSMutableString stringWithString:[scheduleDate2 objectAtIndex:b]];
    */
    //NSLog(@"schetchik_group_and_data_of_group = %@",schetchik_group_and_data_of_group);
    //NSLog(@"schetchik_group_and_data_of_group2 = %@",schetchik_group_and_data_of_group2);
    
    /*
    [GlobalVariables sharedInstance].global_id_of_group = [[schetchik_group_and_data_of_group valueForKey:cellText] objectForKey:@"id_of_group"];
    [GlobalVariables sharedInstance].global_date_of_action = [[schetchik_group_and_data_of_group valueForKey:cellText] objectForKey:@"date_of_action"];
    [GlobalVariables sharedInstance].global_name_of_group = [[schetchik_group_and_data_of_group valueForKey:cellText] objectForKey:@"name_of_group"];
    [GlobalVariables sharedInstance].global_time_of_group = [[schetchik_group_and_data_of_group valueForKey:cellText] objectForKey:@"time_of_group"];
    [GlobalVariables sharedInstance].global_name_of_teacher = [[schetchik_group_and_data_of_group valueForKey:cellText] objectForKey:@"teacher_of_group"];
    [GlobalVariables sharedInstance].global_name_of_branch = [[schetchik_group_and_data_of_group valueForKey:cellText] objectForKey:@"name_of_branch"];
    [GlobalVariables sharedInstance].global_description_of_branch = [[schetchik_group_and_data_of_group valueForKey:cellText] objectForKey:@"description_of_branch"];
    [GlobalVariables sharedInstance].global_coordinates_of_branch = [[schetchik_group_and_data_of_group valueForKey:cellText] objectForKey:@"coordinates_of_branch"];
    [GlobalVariables sharedInstance].global_id_of_teacher = [[schetchik_group_and_data_of_group valueForKey:cellText] objectForKey:@"id_of_teacher"];
    [GlobalVariables sharedInstance].global_dayweak_month_date = [[schetchik_group_and_data_of_group valueForKey:cellText] objectForKey:@"dayweak_month_date"];
    */
    
    
    
    NSURL *url_profile = [NSURL URLWithString:[NSString stringWithFormat:@"%@/script_for_work_with_group.php",[GlobalVariables sharedInstance].global_url]];
    NSMutableURLRequest *urlRequest_profile = [NSMutableURLRequest requestWithURL:url_profile];
    NSString *userUpdate_profile = [NSString stringWithFormat:@"a=%@",cellText];
    NSData *data_userUpdate_profile = [userUpdate_profile dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest_profile setHTTPBody:data_userUpdate_profile];
    [urlRequest_profile setHTTPMethod:@"POST"];

    NSError *error_profile = nil;
    NSHTTPURLResponse *responceCode_profile = nil;
    NSData *responseData_profile = [NSURLConnection sendSynchronousRequest:urlRequest_profile returningResponse:&responceCode_profile error:&error_profile];
    if (error_profile) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        }];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^(void){
             [self presentViewController:alert animated:true completion:nil];
        });
    } else {
        NSLog(@"%@", [[NSString alloc] initWithData:responseData_profile encoding:NSASCIIStringEncoding]);
        
        NSError *jsonError;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseData_profile options:NSJSONReadingMutableContainers error:&jsonError];
        if (jsonError != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Ошибка связи с сервером" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            }];
            [alert addAction:okAction];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                 [self presentViewController:alert animated:true completion:nil];
            });
        } else {
            NSLog(@"script_for_work_with_group = %@",jsonDict);
            //[jsonDict objectForKey:@"a"]

            [GlobalVariables sharedInstance].global_id_of_group = [jsonDict objectForKey:@"id_of_group"];
            [GlobalVariables sharedInstance].global_date_of_action = [jsonDict objectForKey:@"date_of_action"];
            [GlobalVariables sharedInstance].global_name_of_group = [jsonDict objectForKey:@"name_of_group"];
            [GlobalVariables sharedInstance].global_time_of_group = [jsonDict objectForKey:@"time_of_group"];
            [GlobalVariables sharedInstance].global_name_of_teacher = [jsonDict objectForKey:@"teacher_of_group"];
            [GlobalVariables sharedInstance].global_name_of_branch = [jsonDict objectForKey:@"name_of_branch"];
            [GlobalVariables sharedInstance].global_description_of_branch = [jsonDict objectForKey:@"description_of_branch"];
            [GlobalVariables sharedInstance].global_coordinates_of_branch = [jsonDict objectForKey:@"coordinates_of_branch"];
            [GlobalVariables sharedInstance].global_id_of_teacher = [jsonDict objectForKey:@"id_of_teacher"];
            [GlobalVariables sharedInstance].global_dayweak_month_date = [jsonDict objectForKey:@"dayweek_month_date"];
            [GlobalVariables sharedInstance].global_description = [jsonDict objectForKey:@"description"];
            [GlobalVariables sharedInstance].global_img_of_teacher = [jsonDict objectForKey:@"img_of_teacher"];
            [GlobalVariables sharedInstance].global_schedule_of_group = [jsonDict objectForKey:@"schedule_of_group"];
            [GlobalVariables sharedInstance].global_status_of_group = [jsonDict objectForKey:@"status_of_group"];
            
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Group"];
            //[self presentModalViewController:vc animated:YES];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentModalViewController:vc animated:NO];
            
        }
    }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return CGFLOAT_MIN;
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
              withRowAnimation:(UITableViewRowAnimation)animation {
    NSLog(@"Обновление таблицы");
}




@end
