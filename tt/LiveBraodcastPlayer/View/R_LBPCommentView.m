//
//  R_LBPCommentView.m
//  tt
//
//  Created by l on 2021/2/25.
//

#import "R_LBPCommentView.h"
#import "R_LBPCommentInputView.h"
#import "Masonry.h"
#import "R_LBPCommentTableViewCell.h"

@interface R_LBPCommentView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) R_LBPCommentInputView *commentInputView;
@property (nonatomic, strong) ClickSendComment clickSendComment;

@end

@implementation R_LBPCommentView

#pragma mark - public

/// 配置发布评论回调
/// @param clickSendComment 发布评论回调
-(void)configClickSendComment:(ClickSendComment)clickSendComment {
    if(clickSendComment) {
        self.clickSendComment = clickSendComment;
    }
}

/// 刷新评论
/// @param comments 新评论数组
-(void)refreshComments:(NSArray *)comments {
    
}

/// 获取列表已存在评论
-(NSArray *)readExistComments {
    return [self.comments copy];
}

#pragma mark - life cyc

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addNotification];
        [self loadCustomView];
    }
    return self;
}

#pragma mark - private

-(void)loadCustomView {
    [self addSubview:self.commentInputView];
    [self.commentInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(@200);
    }];
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.commentInputView);
        make.top.equalTo(self).offset(4);
        make.bottom.equalTo(self.commentInputView.mas_top).offset(-4);
        make.height.equalTo(@150);
    }];
}

-(void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

// 刷新列表数据 isToBottom是否定位到底部 YES-是 NO-不动
-(void)reloadTableViewToBottom:(BOOL)isToBottom {
    [self reloadTableViewToBottom:isToBottom msgs:@[]];
}

// 刷新列表数据 isToBottom是否定位到底部 YES-是 NO-不动 msgs是要合并到列表的新数据
-(void)reloadTableViewToBottom:(BOOL)isToBottom msgs:(NSArray *)msgs {
    if(msgs.count > 0) {
        self.comments = [NSMutableArray arrayWithArray:msgs];
    }
    [UIView performWithoutAnimation:^{
        [self.tableView reloadData];
    }];
    if(isToBottom) {
        [self scrollChatTableToBottom:0.1];
    }
}

-(void)keyboardWillShow:(NSNotification *)noti {
    [self scrollChatTableToBottom:0.1];
}

-(void)scrollChatTableToBottom:(CGFloat)time {
    if(self.comments.count > 0 && self.tableView.frame.size.height > 0) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf scrollToIndexPath:[NSIndexPath indexPathForRow:weakSelf.comments.count-1 inSection:0] animated:NO];
            if(self.tableView.alpha == 0) {
                self.tableView.alpha = 1;
            }
        });
    } else {
        // 无数据，不用滑动
    }
}

// 将列表滑动至指定单元格
-(void)scrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:NO];
}

#pragma mark - delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    R_LBPCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"R_LBPCommentTableViewCell"];
    if(indexPath.row < self.comments.count) {
        NSString *str = self.comments[indexPath.row];
        if(str != nil && str.length > 0) {
            [cell configContent:str userName:@"default"];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - lazy

-(UITableView *)tableView {
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#if __IPHONE_OS_VERSION_MAX_ALLOWED>=__IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            [_tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
#endif
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 50;
        [_tableView registerClass:[R_LBPCommentTableViewCell class] forCellReuseIdentifier:@"R_LBPCommentTableViewCell"];
    }
    return _tableView;
}

-(R_LBPCommentInputView *)commentInputView {
    if(_commentInputView == nil) {
        _commentInputView = [[R_LBPCommentInputView alloc] init];
        [_commentInputView configFinishInput:^(NSString * _Nonnull content) {
            if(self.clickSendComment) {
                self.clickSendComment(content);
            }
            [self.comments addObject:content];
            [self reloadTableViewToBottom:YES];
        }];
    }
    return _commentInputView;
}

-(NSMutableArray *)comments {
    if(_comments == nil) {
        _comments = [[NSMutableArray alloc] init];
    }
    return _comments;
}

@end
