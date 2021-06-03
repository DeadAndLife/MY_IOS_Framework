//
//  PrivacyAlertController.m
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/2.
//

#import "PrivacyAlertController.h"
#import <WebKit/WebKit.h>
#import "BaseWKWebViewController.h"

static NSInteger PRIVACY_VERSION = 1;
static NSString *PRIVACY_VERSION_KEY = @"PRIVACY_VERSION_KEY";

typedef void (^PrivacyAlertViewAction)(void);

@interface PrivacyAlertController ()<UITextViewDelegate>

/// <#Description#>
@property (nonatomic, strong) UIButton *cancelButton;

/// <#Description#>
@property (nonatomic, strong) UIButton *agreeButton;

/// <#Description#>
@property (nonatomic, strong) UIView *superContentView;

/// <#Description#>
@property (nonatomic, strong) UILabel *titleLabel;

/// <#Description#>
@property (nonatomic, strong) WKWebView *webView;

/// <#Description#>
@property (nonatomic, strong) UITextView *textView;

/// <#Description#>
@property (nonatomic) PrivacyAlertViewAction cancelAction;

/// <#Description#>
@property (nonatomic) PrivacyAlertViewAction confirmAction;

@end

@implementation PrivacyAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewInit];
    self.view.backgroundColor = colHEX(0x111111, 0.1);
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

+ (instancetype)shared {
    static PrivacyAlertController *objc;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        objc = [[PrivacyAlertController alloc] init];
    });
    return objc;
}

- (instancetype)init {
    if (self = [super init]) {
        [self viewInit];
    }
    return self;
}

- (void)viewInit {
    [self.view addSubview:self.superContentView];
    [self.superContentView addSubview:self.titleLabel];
    [self.superContentView addSubview:self.webView];
    [self.superContentView addSubview:self.textView];
    [self.superContentView addSubview:self.cancelButton];
    [self.superContentView addSubview:self.agreeButton];
    
    CALayer *yellowLayer = [CALayer layer];
    yellowLayer.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame)+Auto_size(3), CGRectGetMinY(self.titleLabel.frame)+Auto_size(13), CGRectGetWidth(self.titleLabel.frame)-Auto_size(6), Auto_size(10));
    yellowLayer.backgroundColor = colHEX(0xffd300, 1).CGColor;
    yellowLayer.cornerRadius = 2;
    [self.superContentView.layer insertSublayer:yellowLayer below:self.titleLabel.layer];
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(0, CGRectGetMaxY(self.webView.frame), CGRectGetWidth(self.superContentView.bounds), 0.5);
    lineLayer.backgroundColor = colHEX(0xDADBDA, 1).CGColor;
    [self.superContentView.layer addSublayer:lineLayer];
}

- (UIView *)superContentView {
    if (!_superContentView) {
        _superContentView = [[UIView alloc] initWithFrame:CGRectMake(Auto_size(40), (SCREEN_H-Auto_size(509))/2, Auto_size(295), Auto_size(509))];
        _superContentView.backgroundColor = [UIColor whiteColor];
        _superContentView.layer.cornerRadius = 8;
    }
    return _superContentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Auto_size(71), Auto_size(31), Auto_size(153), Auto_size(22))];
        
        NSMutableAttributedString *string =
        [[NSMutableAttributedString alloc]
         initWithString:@"服务协议与隐私政策"
         attributes: @{
             NSFontAttributeName:[UIFont systemFontOfSize:Auto_size(16)],
             NSForegroundColorAttributeName:colHEX(0x404040, 1),
         }];
        _titleLabel.attributedText = string;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
        _titleLabel.frame = CGRectMake((Auto_size(295)-CGRectGetWidth(_titleLabel.frame))/2, Auto_size(31), CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_titleLabel.frame));
    }
    return _titleLabel;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+Auto_size(10), Auto_size(295), CGRectGetMinY(self.textView.frame)-Auto_size(16)-CGRectGetMaxY(self.titleLabel.frame)-Auto_size(10))];
        _webView.backgroundColor = colHEX(0xf8f8f8, 1);
    }
    return _webView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(Auto_size(20), CGRectGetHeight(self.superContentView.frame)-Auto_size(40)-Auto_size(16), Auto_size(253), Auto_size(25))];
        _textView.font = [UIFont fontWithName:PFR size:Auto_size(14)];
        _textView.textColor = colHEX(0x454545, 1);
        _textView.contentMode = UIViewContentModeLeft;
        _textView.editable = false;
        _textView.scrollEnabled = false;
        _textView.exclusiveTouch = true;
        _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [self labelAddTagert];
        _textView.delegate = self;
        [_textView sizeToFit];
        _textView.frame = CGRectMake(Auto_size(20), CGRectGetMinY(self.cancelButton.frame)-Auto_size(15)-CGRectGetHeight(_textView.frame), CGRectGetWidth(_textView.frame), CGRectGetHeight(_textView.frame));
    }
    return _textView;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(Auto_size(20), CGRectGetHeight(self.superContentView.frame)-Auto_size(40)-Auto_size(16), Auto_size(123), Auto_size(40))];
        _cancelButton.layer.borderColor = colHEX(0xBFBFBF, 1).CGColor;
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.layer.cornerRadius = 5;
        [_cancelButton setTitle:@"不同意并退出" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:colHEX(0x868686, 1) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:PFR size:Auto_size(16)];
        
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame)+Auto_size(9), CGRectGetHeight(self.superContentView.frame)-Auto_size(40)-Auto_size(16), Auto_size(123), Auto_size(40))];
        _agreeButton.backgroundColor = colHEX(0xFFD300, 1);
        _agreeButton.layer.cornerRadius = 5;
        [_agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        [_agreeButton setTitleColor:colHEX(0x494949, 1) forState:UIControlStateNormal];
        _agreeButton.titleLabel.font = [UIFont fontWithName:PFR size:Auto_size(16)];
        
        [_agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}

- (void)labelAddTagert {
    NSString *textStr = @"点击查看《服务协议》，《隐私政策》。";
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:textStr attributes:@{
        NSFontAttributeName:self.textView.font,
        NSForegroundColorAttributeName:self.textView.textColor
    }];
    
    NSString *tagOne = @"《服务协议》";
    [attributedString addAttributes:@{
        NSLinkAttributeName:@"login://",
        NSForegroundColorAttributeName:colHEX(0xFFD300, 1),
        NSUnderlineStyleAttributeName:@0,
        NSBackgroundColorDocumentAttribute:colHEX(0xff0000, 1),
    } range:[textStr rangeOfString:tagOne]];
    
    NSString *tagTwo = @"《隐私政策》";
    [attributedString addAttributes:@{
        NSLinkAttributeName:@"yingsi://",
        NSForegroundColorAttributeName:colHEX(0xFFD300, 1),
        NSUnderlineStyleAttributeName:@0,
    } range:[textStr rangeOfString:tagTwo]];
    
    self.textView.linkTextAttributes = @{
        NSForegroundColorAttributeName:colHEX(0xFFD300, 1)
    };
    self.textView.attributedText = attributedString;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    if ([[URL scheme] isEqualToString:@"login"]) {
        BaseWKWebViewController *webVC = [[BaseWKWebViewController alloc] init];
        webVC.requestURLString = @"https://www.baidu.com";
        
        BaseNavigationController *navc = [[BaseNavigationController alloc] initWithRootViewController:webVC];
        
        [self presentViewController:navc animated:true completion:^{
        }];
        
        return NO;
    } else if ([[URL scheme] isEqualToString:@"yingsi"]) {
        BaseWKWebViewController *webVC = [[BaseWKWebViewController alloc] init];
        webVC.requestURLString = @"https://www.baidu.com";

        BaseNavigationController *navc = [[BaseNavigationController alloc] initWithRootViewController:webVC];
        
        [self presentViewController:navc animated:true completion:^{
        }];
        
        return NO;
    }
    return YES;
}

- (void)showWithCancelAction:(void(^)(void))cancelAction confirmAction:(void(^)(void))confirmAction {
    NSInteger nowPrivacyVersion = [[NSUserDefaults standardUserDefaults] integerForKey:PRIVACY_VERSION_KEY];
    if (PRIVACY_VERSION>nowPrivacyVersion) {
        [[NSUserDefaults standardUserDefaults] setInteger:PRIVACY_VERSION forKey:PRIVACY_VERSION_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.cancelAction = cancelAction;
        self.confirmAction = confirmAction;
        self.view.alpha = 1;
        self.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    }
}

- (IBAction)agreeButtonClick:(UIButton *)sender {
    if (self.confirmAction) {
        self.confirmAction();
    }
    [self hiddenWithAnimation:true];
}

- (IBAction)cancelButtonClick:(UIButton *)sender {
    if (self.cancelAction) {
        self.cancelAction();
    }
    [self hiddenWithAnimation:true];
}

- (void)hiddenWithAnimation:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:0.18 animations:^{
            self.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
        }];
    } else {
        [self.view removeFromSuperview];
    }
}


@end
