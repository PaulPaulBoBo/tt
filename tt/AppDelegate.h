//
//  AppDelegate.h
//  tt
//
//  Created by l on 2021/2/23.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic,assign) BOOL allowRotation;

@end

typedef enum : NSUInteger {
    Help_MLVBLiveRoom,
    Help_录屏直播,
    Help_超级播放器,
    Help_视频录制,
    Help_特效编辑,
    Help_视频拼接,
    Help_图片转场,
    Help_视频上传,
    Help_双人音视频,
    Help_多人音视频,
    Help_rtmp推流,
    Help_直播播放器,
    Help_点播播放器,
    Help_webrtc,
    Help_TRTC,
} HelpTitle;

#define  HelpBtnUI(NAME) \
UIButton *helpbtn = [UIButton buttonWithType:UIButtonTypeCustom]; \
helpbtn.tag = Help_##NAME; \
[helpbtn setFrame:CGRectMake(0, 0, 60, 25)]; \
[helpbtn setBackgroundImage:[UIImage imageNamed:@"help_small"] forState:UIControlStateNormal]; \
[helpbtn addTarget:[[UIApplication sharedApplication] delegate] action:@selector(clickHelp:) forControlEvents:UIControlEventTouchUpInside]; \
[helpbtn sizeToFit]; \
UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:helpbtn]; \
self.navigationItem.rightBarButtonItems = @[rightItem];

#define HelpBtnConfig(helpbtn, x) \
helpbtn.tag = Help_##x; \
[helpbtn addTarget:[[UIApplication sharedApplication] delegate] action:@selector(clickHelp:) forControlEvents:UIControlEventTouchUpInside];

