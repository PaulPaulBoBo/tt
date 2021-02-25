//
//  R_LBPCommentTableViewCell.m
//  tt
//
//  Created by l on 2021/2/25.
//

#import "R_LBPCommentTableViewCell.h"
#import "Masonry.h"

@interface R_LBPCommentTableViewCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation R_LBPCommentTableViewCell

#pragma mark - life cyc

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self loadCustomView];
    }
    return self;
}

#pragma mark - public

-(void)loadCustomView {
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(3);
        make.right.bottom.equalTo(self.contentView).offset(-3);
    }];
}

-(void)configContent:(NSString *)content userName:(NSString *)userName {
    self.contentLabel.text = [NSString stringWithFormat:@"%@:%@", userName, content];
}

#pragma mark - lazy

-(UILabel *)contentLabel {
    if(_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
        _contentLabel.numberOfLines = 5;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _contentLabel;
}

@end
