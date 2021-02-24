//
//  UIDevice+RLiteDevice.m
//  tt
//
//  Created by l on 2021/2/24.
//

#import "UIDevice+RLiteDevice.h"

@implementation UIDevice (RLiteDevice)

//调用私有方法实现
+ (void)setOrientation:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[self currentDevice]];
    int val = orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}

@end
