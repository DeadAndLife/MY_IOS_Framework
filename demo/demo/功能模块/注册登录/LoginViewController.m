//
//  LoginViewController.m
//  zhibo
//
//  Created by iOSzhang Inc on 21/5/31.
//

#import "LoginViewController.h"
#import "HttpManager+Login.h"
#import "ForgotPasswordViewController.h"

@interface LoginViewController ()

/// <#Description#>
@property (nonatomic, strong) UIImageView *backgroundImageView;

/// <#Description#>
@property (nonatomic, strong) UILabel *bigTitleLabel;

/// <#Description#>
@property (nonatomic, strong) UILabel *big2TitleLabel;

/// <#Description#>
@property (nonatomic, strong) UIImageView *phoneImage;

/// <#Description#>
@property (nonatomic, strong) UITextField *phoneTextField;

/// 可变
@property (nonatomic, strong) UIImageView *passwordImage;

/// 可变
@property (nonatomic, strong) UITextField *passwordTextField;

/// 改变登录方式
@property (nonatomic, strong) UIButton *changeButton;

/// <#Description#>
@property (nonatomic, strong) UIButton *forgotPassButton;

/// <#Description#>
@property (nonatomic, strong) UIButton *confirmButton;

/// <#Description#>
@property (nonatomic, strong) UILabel *tipLabel;

/// <#Description#>
@property (nonatomic, strong) UIButton *sendCodeButton;

/// 是否发送过验证码
@property (nonatomic) BOOL sendedCode;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sendedCode = false;
    [self viewInit];
    // Do any additional setup after loading the view.
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
    [self.view addSubview:self.bigTitleLabel];
    [self.view addSubview:self.big2TitleLabel];
    [self.view addSubview:self.phoneImage];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.passwordImage];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.changeButton];
    [self.view addSubview:self.forgotPassButton];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.sendCodeButton];
    
    [self.bigTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Auto_size(14));
        make.top.mas_equalTo(UIApplication.statusBarHeight+Auto_size(69));
    }];
    [self.big2TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Auto_size(14));
        make.top.mas_equalTo(_bigTitleLabel.mas_bottom).mas_offset(Auto_size(19.5));
    }];
    [self.phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Auto_size(40));
        make.top.mas_equalTo(_big2TitleLabel.mas_bottom).mas_offset(Auto_size(60));
        make.size.mas_equalTo(CGSizeMake(Auto_size(20), Auto_size(20)));
    }];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_phoneImage);
        make.left.mas_equalTo(_phoneImage.mas_right).mas_offset(Auto_size(12));
        make.right.mas_equalTo(-40);
    }];
    [self.passwordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Auto_size(40));
        make.top.mas_equalTo(_phoneImage.mas_bottom).mas_offset(Auto_size(40));
        make.size.mas_equalTo(CGSizeMake(Auto_size(20), Auto_size(20)));
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_passwordImage);
        make.left.mas_equalTo(_passwordImage.mas_right).mas_offset(Auto_size(12));
        make.right.mas_equalTo(-Auto_size(40));
    }];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_passwordImage);
        make.right.mas_equalTo(-Auto_size(40));
    }];
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_passwordImage.mas_bottom).mas_offset(Auto_size(20));
        make.left.mas_equalTo(Auto_size(40));
    }];
    [self.forgotPassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_passwordImage.mas_bottom).mas_offset(Auto_size(20));
        make.right.mas_equalTo(-Auto_size(40));
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_changeButton.mas_bottom).mas_offset(Auto_size(35));
        make.left.mas_equalTo(Auto_size(30));
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(Auto_size(43));
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_confirmButton.mas_bottom).mas_offset(Auto_size(20));
        make.left.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    //后面换成frame方式后使用layer添加下划线
}

- (UILabel *)bigTitleLabel {
    if (!_bigTitleLabel) {
        _bigTitleLabel = [[UILabel alloc] init];
        
        _bigTitleLabel.text = @"Hello";
        _bigTitleLabel.textColor = colHEX(0x222222, 1);
        _bigTitleLabel.font = [UIFont fontWithName:PFB size:Auto_size(30)];
    }
    return _bigTitleLabel;
}
- (UILabel *)big2TitleLabel {
    if (!_big2TitleLabel) {
        _big2TitleLabel = [[UILabel alloc] init];
        
        _big2TitleLabel.text = @"欢迎登录教育培训";
        _big2TitleLabel.textColor = colHEX(0x222222, 1);
        _big2TitleLabel.font = [UIFont fontWithName:PFB size:Auto_size(18)];
    }
    return _big2TitleLabel;
}
- (UIImageView *)phoneImage {
    if (!_phoneImage) {
        _phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yonghu"]];
//        _phoneImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _phoneImage;
}
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
        _phoneTextField.placeholder = @"请输入手机号";
        _phoneTextField.font = [UIFont fontWithName:PFR size:14];
        _phoneTextField.textColor = colHEX(0x333333, 1);
    }
    return _phoneTextField;
}
- (UIImageView *)passwordImage {
    if (!_passwordImage) {
        _passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mima"] highlightedImage:[UIImage imageNamed:@"yanzhnegma"]];
//        _phoneImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _passwordImage;
}
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.font = [UIFont fontWithName:PFR size:14];
        _passwordTextField.textColor = colHEX(0x333333, 1);
        _passwordTextField.secureTextEntry = true;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _passwordTextField;
}

- (UIButton *)changeButton {
    if (!_changeButton) {
        _changeButton = [[UIButton alloc] init];
        [_changeButton setTitle:@"验证码登录" forState:UIControlStateNormal];
        [_changeButton setTitle:@"账号密码登录" forState:UIControlStateSelected];
        [_changeButton setTitleColor:colHEX(0x3375FF, 1) forState:UIControlStateNormal];
        _changeButton.titleLabel.font = [UIFont fontWithName:PFR size:Auto_size(12)];
        
        [_changeButton addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_changeButton expandResponseAreaBounds:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _changeButton;
}

- (UIButton *)forgotPassButton {
    if (!_forgotPassButton) {
        _forgotPassButton = [[UIButton alloc] init];
        [_forgotPassButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgotPassButton setTitleColor:colHEX(0x555555, 1) forState:UIControlStateNormal];
        _forgotPassButton.titleLabel.font = [UIFont fontWithName:PFR size:Auto_size(12)];
        
        [_forgotPassButton addTarget:self action:@selector(forgotPassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_forgotPassButton expandResponseAreaBounds:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _forgotPassButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton setTitle:@"立即登录" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:PFR size:Auto_size(18)];
        _confirmButton.layer.backgroundColor = colHEX(0x3375FF, 1).CGColor;
        _confirmButton.layer.cornerRadius = Auto_size(43.f)/2;
        _confirmButton.layer.shadowOffset = CGSizeMake(4, 0);
        _confirmButton.layer.shadowColor = colHEX(0x1657C5, 0.35).CGColor;
        _confirmButton.layer.shadowRadius = 13.5;
        _confirmButton.layer.shadowOpacity = 1;
        
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton expandResponseAreaBounds:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _confirmButton;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"新用户请使用验证码登录，登录后自动创建账号";
        _tipLabel.font = [UIFont fontWithName:PFR size:Auto_size(12)];
        _tipLabel.textColor = colHEX(0x333333, 1);
        _tipLabel.numberOfLines = 0;
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}

- (UIButton *)sendCodeButton {
    if (!_sendCodeButton) {
        _sendCodeButton = [[UIButton alloc] init];
        _sendCodeButton.hidden = true;
        [_sendCodeButton setTitle:@"点击获取验证码" forState:UIControlStateNormal];
        [_sendCodeButton setTitleColor:colHEX(0xE72B2B, 1) forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = [UIFont fontWithName:PFR size:Auto_size(12)];
        
        [_sendCodeButton addTarget:self action:@selector(sendCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_sendCodeButton expandResponseAreaBounds:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    return _sendCodeButton;
}

#pragma mark - buttonClick
- (IBAction)changeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTextField.text = @"";
    self.sendCodeButton.hidden = !sender.selected;
    self.forgotPassButton.hidden = sender.selected;
    self.passwordImage.highlighted = sender.selected;
    [self.passwordTextField resignFirstResponder];
    if (sender.selected) {
        if (self.sendedCode) {
            [self.sendCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
        } else {
            [self.sendCodeButton setTitle:@"点击获取验证码" forState:UIControlStateNormal];
        }
        self.tipLabel.text = @"新用户登录后自动创建账号";
        self.passwordTextField.placeholder = @"请输入验证码";
        self.passwordTextField.secureTextEntry = false;
        self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        self.tipLabel.text = @"新用户请使用验证码登录，登录后自动创建账号";
        self.passwordTextField.placeholder = @"请输入密码";
        self.passwordTextField.secureTextEntry = true;
        self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    }
}

- (IBAction)forgotPassButtonClick:(UIButton *)sender {
    ForgotPasswordViewController *forgotVC = [[ForgotPasswordViewController alloc] init];
    if ([self.phoneTextField.text isPhoneNumber]) {
        forgotVC.phone = self.phoneTextField.text;
    }
    
    [self.navigationController pushViewController:forgotVC animated:true];
}

- (IBAction)confirmButtonClick:(UIButton *)sender {
    if (self.changeButton.selected) {
        [self passwordLogin];
    } else {
        [self codeLogin];
    }
}

- (IBAction)sendCodeButtonClick:(UIButton *)sender {
    if (![self.phoneTextField.text isPhoneNumber]) {
        [ShowAlertTipHelper showInView:self.view text:@"请正确输入手机号后再发送验证码" time:0.6 completeBlock:^{
        }];
        return;
    }
    
    //请求接口后start
    [[HttpManager share] sendCodeWithPhone:self.phoneTextField.text event:@"登录" block:^(id responseObject, NSError *error) {
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
                    
                    self.sendedCode = true;
                    [self startVerifyTimer];
                    
                    [self.passwordTextField becomeFirstResponder];
                    if (@available(iOS 12.0, *)) {
                        self.passwordTextField.textContentType = UITextContentTypeOneTimeCode;
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

- (void)passwordLogin {
    self.confirmButton.enabled = false;
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[HttpManager share] loginWithPhone:self.phoneTextField.text password:self.passwordTextField.text block:^(id responseObject, NSError *error) {
        self.confirmButton.enabled = true;
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

- (void)codeLogin {
    self.confirmButton.enabled = false;
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[HttpManager share] loginWithPhone:self.phoneTextField.text code:self.passwordTextField.text block:^(id responseObject, NSError *error) {
        self.confirmButton.enabled = true;
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
