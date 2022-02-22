//
//  AdminScanner.h
//  LilFam NATION
//
//  Created by Daniil Savva on 15.01.2020.
//  Copyright © 2020 Daniil Savva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdminScanner : UIViewController <AVCaptureMetadataOutputObjectsDelegate>


@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, assign) BOOL isReading;
@property (strong, nonatomic) IBOutlet UIView *viewforCamera;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;


@end

//для шифрования md5
@interface NSString (MyAdditions)
- (NSString *)md5;
@end

@interface NSData (MyAdditions)
- (NSString*)md5;
@end

NS_ASSUME_NONNULL_END
