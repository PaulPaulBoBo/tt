//
//  R_LBPCommentInputView.h
//  tt
//
//  Created by l on 2021/2/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FinishInput)(NSString *content); // 结束回调

@interface R_LBPCommentInputView : UIView

/// 配置结束回调
/// @param finishInput 结束回调
-(void)configFinishInput:(FinishInput)finishInput;

@end

NS_ASSUME_NONNULL_END
