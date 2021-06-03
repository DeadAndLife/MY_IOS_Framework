//
//  BaseWKWebViewController.m
//  rabbit
//
//  Created by admin on 2020/1/9.
//  Copyright © 2020 jixiultd. All rights reserved.
//

#import "BaseWKWebViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWKWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (strong, nonatomic) UIProgressView *progressView;

@property (nonatomic, strong) NSMutableURLRequest *baseRequest;

@end

@implementation BaseWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.navigationController.viewControllers.count == 1 && [self.navigationController.viewControllers.firstObject isEqual:self]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    }
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.view insertSubview:_webView belowSubview:self.progressView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.requestURLString) {
        [self loadRequestURLString:self.requestURLString];
    } else if (self.htmlString) {
        [self loadHtmlString:self.htmlString baseURLString:@""];
    } else if (self.filePath) {
        [self loadFileURLString:self.filePath];
    }
}

#pragma mark 懒加载webView
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
        webConfig.preferences.minimumFontSize = 9.0;
        webConfig.suppressesIncrementalRendering = YES; // 是否支持记忆读取
        [webConfig.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];//支持跨域
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:webConfig];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2)];
        _progressView.tintColor = [UIColor orangeColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (NSMutableURLRequest *)baseRequest {
    if (!_baseRequest) {
        _baseRequest = [[NSMutableURLRequest alloc] init];
        [_baseRequest addValue:[[UserManger share] getUserToken] forHTTPHeaderField:@"token"];
        
        //        NSString *jsonSysUA = [CMTHTTPNetworking share].sessionManager.requestSerializer.HTTPRequestHeaders[@"User-Agent"];
        //        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":jsonSysUA}];
        //        [self.webView setCustomUserAgent:jsonSysUA];
        //        [_baseRequest addValue:@"iOS" forHTTPHeaderField:@"Client-Type"];
        //        NSLog(@"jsonSysUA%@", jsonSysUA);
    }
    return _baseRequest;
}

- (void)loadFileURLString:(NSString *)URLString {
    if (![self.filePath isEqualToString:URLString]) {
        self.filePath = URLString;
    }
    [self.webView loadFileURL:[NSURL fileURLWithPath:URLString] allowingReadAccessToURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
}

- (void)loadRequestURLString:(NSString *)URLString {
    if (![self.requestURLString isEqualToString:URLString]) {
        self.requestURLString = URLString;
    }
    self.baseRequest.URL = [NSURL URLWithString:URLString];
    [self.webView loadRequest:self.baseRequest];
}

- (void)loadHtmlString:(NSString *)HtmlString baseURLString:(NSString *)baseURLString {
    if (![self.htmlString isEqualToString:HtmlString]) {
        self.htmlString = HtmlString;
    }
    [self.webView loadHTMLString:HtmlString baseURL:[NSURL URLWithString:baseURLString]];
}

#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [webView reload];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webURL:%@", webView.URL.absoluteString);
    if (webView.title && ![webView.title isEqualToString:@""]) {
        self.title = webView.title;
    } else if (self.titleString && ![self.titleString isEqualToString:@""]) {
        self.title = self.titleString;
    } else {
        self.title = @"加载中";
    }
    
    if (self.htmlString) {
        // 适当增大字体大小
        NSString *textSizeJSString;
        if (SCREEN_H<668) {
            textSizeJSString = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '200%'";
        } else {
            textSizeJSString = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'";
        }
        [webView evaluateJavaScript:textSizeJSString completionHandler:nil];
        
        NSString *imageSizeJSString = [NSString stringWithFormat:@"var script = document.createElement('script');"
                                       "script.type = 'text/javascript';"
                                       "script.text = \"function ResizeImages() { "
                                       "var myimg,oldwidth;"
                                       "var maxwidth = %.1lf;"
                                       "for(i=1;i <document.images.length;i++){"
                                       "myimg = document.images[i];"
                                       "oldwidth = myimg.width;"
                                       "myimg.width = maxwidth;"
                                       "}"
                                       "}\";"
                                       "document.getElementsByTagName('head')[0].appendChild(script);ResizeImages();", SCREEN_W];
        [_webView evaluateJavaScript:imageSizeJSString completionHandler:nil];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    if ([self isBlankView:webView]) {
//        //置nil前先移除监听
//        [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
//        self.webView = nil;
//        if (self.requestURLString) {
//            [self loadRequestURLString:self.requestURLString];
//        } else if (self.htmlString) {
//            [self loadHtmlString:self.htmlString baseURLString:@""];
//        } else if (self.filePath) {
//            [self loadFileURLString:self.filePath];
//        }
//        return;
//    }
    if (webView.title && ![webView.title isEqualToString:@""]) {
        self.title = webView.title;
    }
}

// 如果不添加这个，那么wkwebview跳转不了AppStore
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"webView.URL:%@", webView.URL.absoluteURL);
    if ([webView.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:^(BOOL success) {
            
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        //    } else if ([webView.URL.absoluteString hasPrefix:[[CMTHTTPNetworking share] requestURLString:@"member/login/wap_login"]]) {
        //        CMTLoginOrRegisterViewController *loginVC = [[CMTLoginOrRegisterViewController alloc] init];
        //        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:loginVC];
        //        loginVC.loginMode = CMTLoginModeLogin;
        //
        //        [self presentViewController:nav animated:YES completion:nil];
        //        decisionHandler(WKNavigationActionPolicyCancel);
        //    } else {
        //        WeakSelf(weakSelf, self);
        //        BOOL isIntercepted = [[AlipaySDK defaultService] payInterceptorWithUrl:[webView.URL absoluteString] fromScheme:@"CarProduct" callback:^(NSDictionary *result) {
        //            // 处理支付结果
        //            NSLog(@"%@", result);
        //            // isProcessUrlPay 代表 支付宝已经处理该URL
        //            if ([result[@"isProcessUrlPay"] boolValue]) {
        //                // returnUrl 代表 第三方App需要跳转的成功页URL
        //                NSString* urlStr = result[@"returnUrl"];
        //                [weakSelf loadRequestURLString:urlStr];
        //            }
        //        }];
        //        if (isIntercepted) {
        //            decisionHandler(WKNavigationActionPolicyCancel);
        //        } else {
        //            decisionHandler(WKNavigationActionPolicyAllow);
        //        }
    } else {
        //允许其他请求
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

// 记得取消监听
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 判断是否白屏
- (BOOL)isBlankView:(UIView*)view { // YES：blank
    //用WKCompositingView判断白屏并不完美，不含这个的时候也不一定就是白屏
    if ([view isKindOfClass:NSClassFromString(@"WKCompositingView")]) {
        return NO;
    }
    for (UIView *subView in view.subviews) {
        NSLog(@"subView:%@", subView);
        if (![self isBlankView:subView]) {
            return NO;
        }
    }
    return YES;
}

//#pragma mark - 监听事件处理
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//
//    if ([keyPath isEqual:@"title"]){
//        if (object == self.webView) {
//            //添加导航栏标题
////            self.title = self.webView.title;
//        } else {
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        }
//
//    }else{
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
//
//
//#pragma mark - dealloc销毁
//-(void)dealloc{
////    [self.webView removeObserver:self forKeyPath:@"title"];
////    [self.webView setUIDelegate:nil];
//}
//
//#pragma mark - 在发送之前 决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    NSString *urlString = [[navigationAction.request URL] absoluteString];
//    urlString = [urlString stringByRemovingPercentEncoding];
//    //截获电话请求
//    if ([urlString hasPrefix:@"tel"]){
//        //取消WKWebView 打电话请求
//        decisionHandler(WKNavigationActionPolicyCancel);
//        //用openURL 这个API打电话
//        //解决10.0以后拨打电话延时
//        if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//            /// 10及其以上系统
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
//        } else {
//            /// 10以下系统
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//        }
//        //        [[UIApplication sharedApplication]  openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
//    }else{
//        //允许其他请求
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//}
//
//#pragma mark - 加载URL
//// 加载网络URL
//- (void)loadNetworkHTML:(NSString *)htmlString {
//    NSLog(@"%@", htmlString);
//    //对htmlString进行编码
//    [htmlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
//    // 加载URL
//    NSURL *url =[NSURL URLWithString:htmlString];
//    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
//
//    [self.webView loadRequest:mutableRequest];
//
//}
//
//
//// 加载本地URL
//- (void)loadLocalHTML:(NSString *)htmlString {
//    // 取得本地html文件名
//    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:htmlString ofType:@"html"];
//    NSString *htmlStr = [[NSString alloc] initWithContentsOfFile:resourcePath encoding:NSUTF8StringEncoding error:nil];
////    [self.webView loadHTMLString:htmlStr baseURL:[NSURL URLWithString:resourcePath]];
//
//}
//
//#pragma mark - webDelegate
///** 页面开始加载时调用 */
//- (void)webViewDidStartLoad:(RAWebView *)webView {
//
//}
//
///** 内容开始返回时调用 */
//- (void)webView:(RAWebView *)webView didCommitWithURL:(NSURL *)url {
//    NSLog(@"Commiturl:%@", url);
//}
//
///** 页面加载失败时调用 */
//- (void)webView:(RAWebView *)webView didFinishLoadWithURL:(NSURL *)url {
//    NSLog(@"Finishurl:%@", url);
//}
//
///** 页面加载完成之后调用 */
//- (void)webView:(RAWebView *)webView didFailLoadWithError:(NSError *)error {
//    if (error) {
//        NSLog(@"error:%@", error);
//    }
//}

- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:true completion:^{     
    }];
}

@end
