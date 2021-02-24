//
//  R_LBPCoverOperationView.h
//  tt
//
//  Created by l on 2021/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickBackAction)(void);
typedef void(^ClickShareAction)(void);
typedef void(^SubmiteCommentAction)(NSString *commentStr);

@interface R_LBPCoverOperationView : UIView

-(void)configClickBackAction:(ClickBackAction)clickBackAction;
-(void)configClickShareAction:(ClickShareAction)clickShareAction;
-(void)configSubmiteCommentAction:(SubmiteCommentAction)submiteCommentAction;

@end

NS_ASSUME_NONNULL_END
