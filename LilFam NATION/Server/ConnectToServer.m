//
//  ConnectToServer.m
//  LilFam NATION
//
//  Created by Daniil Savva on 24.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "ConnectToServer.h"

@interface ConnectToServer ()

@end

@implementation ConnectToServer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(NSString *)getRandomString{
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"r",@"s",@"t",@"u",@"v",@"x",@"y",@"z",nil];
    NSMutableString *random_string = [NSMutableString stringWithString:@""];
    for(int i = 0;i< 32;i++){
        [random_string appendString:arr[arc4random_uniform(sizeof arr)]];
    }
    return random_string;
}

-(NSDictionary *)connect_to_server{
    
    return 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
