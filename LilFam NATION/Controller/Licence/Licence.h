//
//  Licence.h
//  LilFam NATION
//
//  Created by Daniil Savva on 28.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Licence : UIViewController <UIWebViewDelegate> {
    IBOutlet UIWebView *mHTMLReportAll;
}

@property (nonatomic, weak) IBOutlet UIButton *btnReg;


@end

NS_ASSUME_NONNULL_END
