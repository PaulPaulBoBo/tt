//
//  R_LBPCommentView.h
//  tt
//
//  Created by l on 2021/2/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickSendComment)(NSString *commentStr);

@interface R_LBPCommentView : UIView

/// 配置发布评论回调
/// @param clickSendComment 发布评论回调
-(void)configClickSendComment:(ClickSendComment)clickSendComment;

/// 刷新评论
/// @param comments 新评论数组
-(void)refreshComments:(NSArray *)comments;

/// 获取列表已存在评论
-(NSArray *)readExistComments;

@end

NS_ASSUME_NONNULL_END
