//
//  WorkWithPaymentRobokassa.h
//  LilFam NATION
//
//  Created by Daniil Savva on 16.12.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WorkWithPaymentRobokassa : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *mHTMLReportAll;
}
@property(retain, nonatomic) UIWebView *mHTMLReportAll;


@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
