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

@property (nonatomic, strong) NSMutableArray *comments; // 评论数组
@property (nonatomic, strong) UITableView *tableView; // 评论列表
@property (nonatomic, strong) R_LBPCommentInputView *commentInputView; // 评论输入视图
@property (nonatomic, strong) ClickSendComment clickSendComment; // 点击发送评论回调

@property (nonatomic, strong) NSMutableArray *queryComments; // 新评论队列数组

@end

@implementation R_LBPCommentView

#pragma mark - public

// 配置发布评论回调
-(void)configClickSendComment:(ClickSendComment)clickSendComment {
    if(clickSendComment) {
        self.clickSendComment = clickSendComment;
    }
}

// 刷新评论
-(void)refreshComments:(NSArray *)comments {
    [self refreshQueryComments:comments];
}

// 将自己发送的评论展示出来
-(void)refreshSelfComment:(NSString *)comment {
    if(comment != nil && comment.length > 0) {
        [self.comments addObject:comment];
        [self reloadTableViewToBottom:YES];
    }
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

-(void)refreshQueryComments:(NSArray *)comments {
    for (int i = 0; i < comments.count; i++) {
        NSString *comment = comments[i];
        if(comment != nil && comment.length > 0) {
            [self.queryComments insertObject:comment atIndex:0];
        }
    }
    
    if(self.queryComments.count > 0) {
        NSString *str = [NSString stringWithFormat:@"%@", self.queryComments.lastObject];
        [self refreshSingleComment:str];
        [self.queryComments removeLastObject];
    }
}

-(void)refreshSingleComment:(NSString *)commentStr {
    if(commentStr != nil && commentStr.length > 0) {
        [self.comments addObject:commentStr];
        BOOL isBottom = self.tableView.contentOffset.y + self.tableView.frame.size.height + 20 >= self.tableView.contentSize.height;
        [self reloadTableViewToBottom:isBottom];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([self getRandomNumFrom:5 toNum:30]/10. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __weak typeof(weakSelf) strongSelf = weakSelf;
            NSString *randomStr = [NSString stringWithFormat:@"%ldlshjdfkjshfoiwelhfiauebfabubcuebvksry", [self getRandomNumFrom:10 toNum:999999]];
            [strongSelf refreshQueryComments:@[randomStr]];
        });
    }
}

// 生成从fromNum到toNum之间的随机数字,包括fromNum,不包括toNum
-(NSInteger)getRandomNumFrom:(CGFloat)fromNum toNum:(CGFloat)toNum {
    NSInteger intFromNum = (NSInteger)fromNum;
    NSInteger intToNum = (NSInteger)toNum;
    NSInteger randomNum = (intFromNum + (arc4random() % ((intToNum - intFromNum))));
    return randomNum;
}

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

-(NSMutableArray *)queryComments {
    if(_queryComments == nil) {
        _queryComments = [[NSMutableArray alloc] init];
    }
    return _queryComments;
}

@end
