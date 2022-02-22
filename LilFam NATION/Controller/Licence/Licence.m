//
//  Licence.m
//  LilFam NATION
//
//  Created by Daniil Savva on 28.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import "Licence.h"

@interface Licence ()

@end

@implementation Licence
@synthesize btnReg;

- (void)viewDidLoad {
    [super viewDidLoad];
    btnReg.layer.cornerRadius = 10;
    
    mHTMLReportAll.scrollView.bounces = NO;
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"];
    NSString* html = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [mHTMLReportAll loadHTMLString:html baseURL:baseURL];
    
    //для отлова закрытия других окно
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successReg:)  name:@"successReg" object:nil];
}
-(IBAction) closeBtn:(id) sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (void) successReg:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"successReg"]){
        //[self dismissViewControllerAnimated:YES completion:Nil];
        [self dismissViewControllerAnimated:NO completion:^{ [[NSNotificationCenter defaultCenter] postNotificationName:@"successRegistration" object:self];
        }];
    }
}
-(IBAction)btnReg:(UIButton *)btnReg {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Licence *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Registration"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentModalViewController:vc animated:NO];
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
