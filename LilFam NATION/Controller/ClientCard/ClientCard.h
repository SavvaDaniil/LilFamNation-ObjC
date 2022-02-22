//
//  ClientCard.h
//  LilFam NATION
//
//  Created by Daniil Savva on 27.11.2019.
//  Copyright © 2019 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClientCard : UIViewController <UIWebViewDelegate>{
    IBOutlet UIImageView *imageUserCard;
    IBOutlet UIWebView *mHTMLReportAll;
}

@property (strong, nonatomic) UIImageView * imageUserCard;

@end


@interface NSString (MyAdditions)
- (NSString *)md5;
@end
@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
