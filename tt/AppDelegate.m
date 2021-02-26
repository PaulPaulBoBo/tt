//
//  AppDelegate.m
//  tt
//
//  Created by l on 2021/2/23.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "TXLiveBase.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSString * const licenceURL = @"http://license.vod2.myqcloud.com/license/v1/9bc310a9bf82c8d3b34bb816dc73ac6b/TXLiveSDK.licence";
    NSString * const licenceKey = @"d9dfe593060ac073956b77443fe09228";
    //TXLiveBase 位于 "TXLiveBase.h" 头文件中
    [TXLiveBase setLicenceURL:licenceURL key:licenceKey];
    NSLog(@"SDK Version = %@", [TXLiveBase getSDKVersionStr]);
    
    ViewController *vc = [ViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    
    return YES;
}


- (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation == 1) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return (UIInterfaceOrientationMaskPortrait);
    }
}
@end
