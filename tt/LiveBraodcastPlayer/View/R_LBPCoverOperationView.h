//
//  R_LBPCoverOperationView.h
//  tt
//
//  Created by l on 2021/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickBackAction)(void); // 点击返回按钮回调
typedef void(^ClickShareAction)(void); // 提交评论事件回调
typedef void(^SubmiteCommentAction)(NSString *commentStr); // 提交评论事件回调

@interface R_LBPCoverOperationView : UIView

/// 配置点击返回按钮回调
/// @param clickBackAction 点击返回按钮回调
-(void)configClickBackAction:(ClickBackAction)clickBackAction;

/// 配置点击分享按钮回调
/// @param clickShareAction 点击分享按钮回调
-(void)configClickShareAction:(ClickShareAction)clickShareAction;

/// 配置提交评论事件回调
/// @param submiteCommentAction 提交评论事件回调
-(void)configSubmiteCommentAction:(SubmiteCommentAction)submiteCommentAction;

@end

NS_ASSUME_NONNULL_END
