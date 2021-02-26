//
//  R_LBPCommentTableViewCell.h
//  tt
//
//  Created by l on 2021/2/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface R_LBPCommentTableViewCell : UITableViewCell

/// 配置评论内容和发送人
/// @param content 内容
/// @param userName 发送人
-(void)configContent:(NSString *)content userName:(NSString *)userName;

@end

NS_ASSUME_NONNULL_END
