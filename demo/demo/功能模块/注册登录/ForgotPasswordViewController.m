//
//  ForgotPasswordViewController.m
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/3.
//

#import "ForgotPasswordViewController.h"
#import "HttpManager+Login.h"

@interface ForgotPasswordViewController ()

/// 手机号
@property (nonatomic, strong) UITextField *phoneField;

/// 验证码
@property (nonatomic, strong) UITextField *codeField;

/// 密码1
@property (nonatomic, strong) UITextField *password1Field;

/// 密码确认
@property (nonatomic, strong) UITextField *password2Field;

/// <#Description#>
@property (nonatomic, strong) UIButton *sendCodeButton;

/// <#Description#>
@property (nonatomic, strong) UIImageView *phoneImage;

/// <#Description#>
@property (nonatomic, strong) UIImageView *codeImage;

/// <#Description#>
@property (nonatomic, strong) UIImageView *password1Image;

/// <#Description#>
@property (nonatomic, strong) UIImageView *password2Image;

/// 确认修改按钮
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    [self viewInit];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.phoneField.text = self.phone;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewInit {
    [self.view addSubview:self.phoneImage];
    [self.view addSubview:self.codeImage];
    [self.view addSubview:self.password1Image];
    [self.view addSubview:self.password2Image];
    [self.view addSubview:self.phoneField];
    [self.view addSubview:self.codeField];
    [self.view addSubview:self.password1Field];
    [self.view addSubview:self.password2Field];
    [self.view addSubview:self.sendCodeButton];
    [self.view addSubview:self.confirmButton];
    
    [self.phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Auto_size(15));
        make.top.mas_equalTo(Auto_size(14));
        make.size.mas_equalTo(CGSizeMake(Auto_size(20), Auto_size(20)));
    }];
    [self.codeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Auto_size(15));
        make.top.mas_equalTo(_phoneImage.mas_bottom).mas_offset(Auto_size(28));
        make.size.mas_equalTo(CGSizeMake(Auto_size(20), Auto_size(20)));
    }];
    [self.password1Image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Auto_size(15));
        make.top.mas_equalTo(_codeImage.mas_bottom).mas_offset(Auto_size(28));
        make.size.mas_equalTo(CGSizeMake(Auto_size(20), Auto_size(20)));
    }];
    [self.password2Image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Auto_size(15));
        make.top.mas_equalTo(_password1Image.mas_bottom).mas_offset(Auto_size(28));
        make.size.mas_equalTo(CGSizeMake(Auto_size(20), Auto_size(20)));
    }];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_phoneImage.mas_right).mas_offset(Auto_size(12));
        make.centerY.mas_equalTo(_phoneImage);
        make.right.mas_equalTo(-Auto_size(15));
    }];
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_codeImage.mas_right).mas_offset(Auto_size(12));
        make.centerY.mas_equalTo(_codeImage);
        make.right.mas_equalTo(-Auto_size(15));
    }];
    [self.password1Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_password1Image.mas_right).mas_offset(Auto_size(12));
        make.centerY.mas_equalTo(_password1Image);
        make.right.mas_equalTo(-Auto_size(15));
    }];
    [self.password2Field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_password2Image.mas_right).mas_offset(Auto_size(12));
        make.centerY.mas_equalTo(_password2Image);
        make.right.mas_equalTo(-Auto_size(15));
    }];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_codeImage);
        make.right.mas_equalTo(-Auto_size(15));
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    //后面换成frame方式后使用layer添加下划线
}

- (UITextField *)phoneField {
    if (!_phoneField) {
        _phoneField = [[UITextField alloc] init];
        _phoneField.placeholder = @"请输入手机号";
        _phoneField.font = [UIFont fontWithName:PFR size:14];
        _phoneField.textColor = colHEX(0x333333, 1);
        _codeField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _phoneField;
}

- (UITextField *)codeField {
    if (!_codeField) {
        _codeField = [[UITextField alloc] init];
        _codeField.placeholder = @"请输入验证码";
        _codeField.font = [UIFont fontWithName:PFR size:14];
        _codeField.textColor = colHEX(0x333333, 1);
        _codeField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _codeField;
}

- (UITextField *)password1Field {
    if (!_password1Field) {
        _password1Field = [[UITextField alloc] init];
        _password1Field.placeholder = @"请输入新密码";
        _password1Field.font = [UIFont fontWithName:PFR size:14];
        _password1Field.textColor = colHEX(0x333333, 1);
        _password1Field.keyboardType = UIKeyboardTypeASCIICapable;
        _password1Field.secureTextEntry = true;
    }
    return _password1Field;
}

- (UITextField *)password2Field {
    if (!_password2Field) {
        _password2Field = [[UITextField alloc] init];
        _password2Field.placeholder = @"请再次输入新密码";
        _password2Field.font = [UIFont fontWithName:PFR size:14];
        _password2Field.textColor = colHEX(0x333333, 1);
        _password2Field.keyboardType = UIKeyboardTypeASCIICapable;
        _password2Field.secureTextEntry = true;
    }
    return _password2Field;
}

- (UIImageView *)phoneImage {
    if (!_phoneImage) {
        _phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yonghu"]];
    }
    return _phoneImage;
}

- (UIImageView *)codeImage {
    if (!_codeImage) {
        _codeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yanzhnegma"]];
    }
    return _codeImage;
}

- (UIImageView *)password1Image {
    if (!_password1Image) {
        _password1Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mima"]];
    }
    return _password1Image;
}

- (UIImageView *)password2Image {
    if (!_password2Image) {
        _password2Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mima"]];
    }
    return _password2Image;
}

- (UIButton *)sendCodeButton {
    if (!_sendCodeButton) {
        _sendCodeButton = [[UIButton alloc] init];
        [_sendCodeButton setTitle:@"点击获取验证码" forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:colHEX(0xE72B2B, 1) forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = [UIFont fontWithName:PFR size:Auto_size(12)];
        
        [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sendCodeButton expandResponseAreaBounds:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _sendCodeButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.layer.backgroundColor = colHEX(0x3375FF, 1).CGColor;
        _confirmButton.titleLabel.font = [UIFont fontWithName:PFR size:15];
        
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton expandResponseAreaBounds:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _confirmButton;
}

#pragma mark - buttonClick
- (IBAction)sendCodeButtonClick:(UIButton *)sender {
    if (![self.phoneField.text isPhoneNumber]) {
        [ShowAlertTipHelper showInView:self.view text:@"请正确输入手机号后再发送验证码" time:0.6 completeBlock:^{
        }];
        return;
    }
    //请求接口后start
    [[HttpManager share] sendCodeWithPhone:self.phoneField.text event:@"重置密码" block:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (responseObject) {
#ifdef DEBUG
            NSLog(@"%@", responseObject);
#endif
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSString *message = [responseDict safeValueForKey:@"message"];
            NSInteger code = [[responseDict safeValueForKey:@"code"] integerValue];
            
            switch (code) {
                case CODE_SUCCESS:{
                    NSDictionary *dataDict = [responseDict safeValueForKey:@"data"];
                    
                    [self startVerifyTimer];
                    
                    [self.codeField becomeFirstResponder];
                    if (@available(iOS 12.0, *)) {
                        self.codeField.textContentType = UITextContentTypeOneTimeCode;
                    }
#ifdef DEBUG
                    [ShowAlertTipHelper showInView:self.view text:message time:0.5 completeBlock:^{}];
#endif
                }
                    break;
                default:{
                    [ShowAlertTipHelper showInView:self.view text:message time:0.5 completeBlock:^{}];
                }
                    break;
            }
        } else {
            NSString *tipString;
            NSTimeInterval delayTime;
#ifdef DEBUG
            tipString = error.description;
            delayTime = 1.5f;
#else
            tipString = @"网络错误，请稍后重试";
            delayTime = 0.8f;
#endif
            [ShowAlertTipHelper showInView:self.view text:tipString time:delayTime completeBlock:^{}];
        }
    }];
}

- (IBAction)confirmButtonClick:(UIButton *)sender {
    if ([self.password1Field.text isEqualToString:self.password2Field.text]) {
        [ShowAlertTipHelper showInView:self.view text:@"请保持两次密码输入一致" time:0.5 completeBlock:^{
        }];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[HttpManager share] resetPasswordWithPhone:self.phoneField.text code:self.codeField.text password:self.password1Field.text passwordAgain:self.password2Field.text block:^(id responseObject, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if (responseObject) {
#ifdef DEBUG
            NSLog(@"%@", responseObject);
#endif
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSString *message = [responseDict safeValueForKey:@"message"];
            NSInteger code = [[responseDict safeValueForKey:@"code"] integerValue];
            
            switch (code) {
                case CODE_SUCCESS:{
                    NSDictionary *dataDict = [responseDict safeValueForKey:@"data"];
                    
                    //自动登录?或返回登录
                    
#ifdef DEBUG
                    [ShowAlertTipHelper showInView:self.view text:message time:0.5 completeBlock:^{}];
#endif
                }
                    break;
                default:{
                    [ShowAlertTipHelper showInView:self.view text:message time:0.5 completeBlock:^{}];
                }
                    break;
            }
        } else {
            NSString *tipString;
            NSTimeInterval delayTime;
#ifdef DEBUG
            tipString = error.description;
            delayTime = 1.5f;
#else
            tipString = @"网络错误，请稍后重试";
            delayTime = 0.8f;
#endif
            [ShowAlertTipHelper showInView:self.view text:tipString time:delayTime completeBlock:^{}];
        }
    }];
}

#pragma mark - timer
- (void)startVerifyTimer {
    __block NSInteger seconds = 60;
    self.sendCodeButton.enabled = false;
    [self.sendCodeButton setTitle:[NSString stringWithFormat:@"重新发送（%ld）",(long)seconds] forState:UIControlStateDisabled];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, start, interval, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        seconds--;
        [self.sendCodeButton setTitle:[NSString stringWithFormat:@"重新发送（%ld）",(long)seconds] forState:UIControlStateDisabled];
        if (seconds == 0) {
            self.sendCodeButton.enabled = YES;
            [self.sendCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
            
            dispatch_cancel(timer);
        }
    });
    dispatch_resume(timer);
}

@end
