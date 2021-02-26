//
//  R_LBPCoverOperationView.m
//  tt
//
//  Created by l on 2021/2/24.
//

#import "R_LBPCoverOperationView.h"
#import "Masonry.h"
#import "R_LBPCommentView.h"

@interface R_LBPCoverOperationView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *topOPView; // 顶部操作背景视图
@property (nonatomic, strong) UIView *bottomOPView; // 底部操作背景视图

@property (nonatomic, strong) UIView *backView; // 返回视图
@property (nonatomic, strong) UIView *shareView; // 分享视图
@property (nonatomic, strong) R_LBPCommentView *commentView; // 评论视图

@property (nonatomic, strong) ClickBackAction clickBackAction; // 点击返回按钮回调
@property (nonatomic, strong) ClickShareAction clickShareAction; // 提交评论事件回调
@property (nonatomic, strong) SubmiteCommentAction submiteCommentAction; // 提交评论事件回调

@end

static BOOL OperationViewIsAppear = NO; // 操作视图是否可见
static BOOL OperationViewIsAnimation = NO; // 操作视图是否正在进行动画
static CGFloat OperationBgHeight = 44; // 操作视图默认高度
static CGFloat OperationViewAnimationDuration = 0.3; // 操作视图消失或显现动画时长
static CGFloat OperationViewStayDuration = 5; // 操作视图停留时间

@implementation R_LBPCoverOperationView

#pragma mark - life cyc

- (instancetype)init {
    self = [super init];
    if (self) {
        OperationViewIsAppear = NO;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView:)];
        [self addGestureRecognizer:tap];
        [self loadCustomView];
    }
    return self;
}

#pragma mark - public

-(void)configClickBackAction:(ClickBackAction)clickBackAction {
    if(clickBackAction) {
        self.clickBackAction = clickBackAction;
    }
}

-(void)configClickShareAction:(ClickShareAction)clickShareAction {
    if(clickShareAction) {
        self.clickShareAction = clickShareAction;
    }
}

-(void)configSubmiteCommentAction:(SubmiteCommentAction)submiteCommentAction {
    if(submiteCommentAction) {
        self.submiteCommentAction = submiteCommentAction;
    }
}

#pragma mark - private

-(void)loadCustomView {
    [self addSubview:self.topOPView];
    [self.topOPView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@(OperationBgHeight));
    }];
    
    [self.topOPView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.topOPView);
        make.width.height.equalTo(self.topOPView.mas_height);
    }];
    
    [self addSubview:self.bottomOPView];
    [self.bottomOPView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@(OperationBgHeight));
    }];
    
    [self.bottomOPView addSubview:self.shareView];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.bottomOPView);
        make.width.height.equalTo(self.bottomOPView.mas_height);
    }];
    [self showOP];
    
    [self addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.top.greaterThanOrEqualTo(self);
        make.right.lessThanOrEqualTo(self);
    }];
    
    [self.commentView refreshComments:@[@"1skjhdaljshdf", @"2cwiehfwe", @"3cmsoiehlbseurvsdfasdfhsef", @"4nsclaiuehnfiluaefeibid", @"5vnsdlisueirbglubucbybsdkjfalkjshdfkagsdkhf98734972638746283658egruwgefkugeufygasudfgs"]];
}

-(UIView *)createActionView:(UIImage *)image action:(SEL)action {
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    if(image) {
        imageView.image = image;
    }
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(view).offset(5);
        make.right.bottom.equalTo(view).offset(-5);
    }];
    
    UIButton *coverBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [coverBtn addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    coverBtn.backgroundColor = [UIColor clearColor];
    [view addSubview:coverBtn];
    [coverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    return view;
}

-(void)backAction:(UIButton *)btn {
    if(self.clickBackAction) {
        self.clickBackAction();
    }
}

-(void)shareAction:(UIButton *)btn {
    if(self.clickShareAction) {
        self.clickShareAction();
    }
}

-(void)tapBgView:(UIGestureRecognizer *)ges {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)to:nil from:nil forEvent:nil];
    if(!OperationViewIsAnimation) {
        if(OperationViewIsAppear) {
            [self hideOP];
        } else {
            [self showOP];
        }
    }
}

-(void)showOP {
    OperationViewIsAnimation = YES;
    __weak typeof(self) wkSelf = self;
    [UIView animateWithDuration:OperationViewAnimationDuration animations:^{
        if(self.topOPView.superview != nil) {
            self.topOPView.alpha = 1;
            [self.topOPView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
            }];
        }
        if(self.bottomOPView.superview != nil) {
            self.bottomOPView.alpha = 1;
            [self.bottomOPView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
            }];
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        __strong typeof(wkSelf) sSelf = wkSelf;
        OperationViewIsAnimation = NO;
        if(!OperationViewIsAppear) {
            OperationViewIsAppear = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(OperationViewStayDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(OperationViewIsAppear) {
                    [sSelf hideOP];
                }
            });
        }
    }];
}

-(void)hideOP {
    OperationViewIsAnimation = YES;
    [UIView animateWithDuration:OperationViewAnimationDuration animations:^{
        if(self.topOPView.superview != nil) {
            self.topOPView.alpha = 0;
            [self.topOPView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(-OperationBgHeight);
            }];
        }
        if(self.bottomOPView.superview != nil) {
            self.bottomOPView.alpha = 0;
            [self.bottomOPView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).offset(OperationBgHeight);
            }];
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        OperationViewIsAppear = NO;
        OperationViewIsAnimation = NO;
    }];
}

#pragma mark - lazy

-(UIView *)topOPView {
    if(_topOPView == nil) {
        _topOPView = [[UIView alloc] init];
        _topOPView.userInteractionEnabled = YES;
        _topOPView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    return _topOPView;
}

-(UIView *)bottomOPView {
    if(_bottomOPView == nil) {
        _bottomOPView = [[UIView alloc] init];
        _bottomOPView.userInteractionEnabled = YES;
        _bottomOPView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }
    return _bottomOPView;
}

-(UIView *)backView {
    if(_backView == nil) {
        _backView = [self createActionView:[UIImage imageNamed:@"close"] action:@selector(backAction:)];
    }
    return _backView;
}

-(UIView *)shareView {
    if(_shareView == nil) {
        _shareView = [self createActionView:[UIImage imageNamed:@"log2"] action:@selector(shareAction:)];
    }
    return _shareView;
}

-(R_LBPCommentView *)commentView {
    if(_commentView == nil) {
        _commentView = [[R_LBPCommentView alloc] init];
        __weak typeof(self) weakSelf = self;
        [_commentView configClickSendComment:^(NSString * _Nonnull commentStr) {
            __weak typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.commentView refreshSelfComment:commentStr];
        }];
    }
    return _commentView;
}

@end
