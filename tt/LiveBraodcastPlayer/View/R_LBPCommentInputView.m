//
//  R_LBPCommentInputView.m
//  tt
//
//  Created by l on 2021/2/25.
//

#import "R_LBPCommentInputView.h"
#import "Masonry.h"

@interface R_LBPCommentInputView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputTextField; // 输入框
@property (nonatomic, strong) FinishInput finishInput; // 结束回调

@end

static BOOL isSureSend = NO; // 是否点击键盘上的send按钮

@implementation R_LBPCommentInputView

#pragma mark - life cyc

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 20;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        [self loadCustomView];
    }
    return self;
}

#pragma mark - public

-(void)configFinishInput:(FinishInput)finishInput {
    if(finishInput) {
        self.finishInput = finishInput;
    }
}

#pragma mark - private

-(void)loadCustomView {
    [self addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(3);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-3);
        make.height.equalTo(@40);
    }];
}

#pragma mark - delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    isSureSend = NO;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if(isSureSend) {
        NSString *str = self.inputTextField.text;
        if(self.finishInput && str.length > 0) {
            self.finishInput(str);
            self.inputTextField.text = @"";
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    isSureSend = YES;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - lazy

-(UITextField *)inputTextField {
    if(_inputTextField == nil) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.delegate = self;
        _inputTextField.keyboardType = UIKeyboardTypeDefault;
        _inputTextField.returnKeyType = UIReturnKeySend;
        _inputTextField.font = [UIFont systemFontOfSize:15 weight:(UIFontWeightRegular)];
        _inputTextField.placeholder = @"请输入";
    }
    return _inputTextField;
}

@end
