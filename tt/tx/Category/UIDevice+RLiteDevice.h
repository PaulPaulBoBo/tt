//
//  UIDevice+RLiteDevice.h
//  tt
//
//  Created by l on 2021/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (RLiteDevice)

/// 强制旋转设备
/// @param orientation 旋转方向
+ (void)setOrientation:(UIInterfaceOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
