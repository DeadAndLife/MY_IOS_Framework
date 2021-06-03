//
//  BaseNavigationController.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate, UINavigationControllerDelegate>
{
    NSDictionary* dic;
}
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WeakSelf(weakSelf, self);
    self.delegate = weakSelf;
    
    [self configureNavBarTheme];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    // Do any additional setup after loading the view.
}

- (void)configureNavBarTheme {
    self.navigationBar.tintColor = colHEX(0x666666, 1);//[UIColor whiteColor];
    // 设置导航栏的标题颜色，字体
    NSDictionary* textAttrs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:18],
        NSForegroundColorAttributeName:[UIColor blackColor]
    };
    [self.navigationBar setTitleTextAttributes:textAttrs];
    //设置导航栏的背景图片
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x7ff5f5f5"]]];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    /*>1防止在rootViewController上右滑导致界面无法跳转问题*/
    if (self.childViewControllers.count>0) {
        // 隐藏导航栏

        //返回按钮自定义
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;

        UIButton *button = [[UIButton alloc] init];
        [button setImage:[[UIImage imageNamed:@"back_grey"] imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
        [button setImage:[[UIImage imageNamed:@"back_grey"] imageWithTintColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        button.frame = CGRectMake(0, 0, 45, 44);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);

//        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
        viewController.navigationItem.leftBarButtonItems = @[backButton];
        viewController.hidesBottomBarWhenPushed = true;

        // 如果自定义返回按钮后, 滑动返回可能失效, 需要添加下面的代码
        __weak typeof(viewController)Weakself = viewController;
        self.interactivePopGestureRecognizer.delegate = (id)Weakself;
  
    }
    [super pushViewController:viewController animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    /**
     导航颜色为深色的控制器包括
     
     @param @"" 页
     */
//    if ([self.visibleViewController isKindOfClass:NSClassFromString(@"RAPreviewPickerViewController")]
//        ) {
//        return UIStatusBarStyleLightContent;
//    }
    return UIStatusBarStyleDefault;
}

- (void)back {
    // 判断两种情况: push 和 present
    if ((self.presentedViewController || self.presentingViewController) && self.childViewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
        [self popViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //处理navigationBar的显隐问题
/**
 隐藏导航的控制器包括
 
 @param @"PrivacyAlertController" 首页
 @param @"LoginViewController" 注册登录页
*/
    if ([viewController isKindOfClass:NSClassFromString(@"PrivacyAlertController")]
        || [viewController isKindOfClass:NSClassFromString(@"LoginViewController")]
        ) {
        [navigationController setNavigationBarHidden:true animated:animated];
    } else {
        [navigationController setNavigationBarHidden:false animated:animated];
    }
    
    if (navigationController.viewControllers.count > 1 && !viewController.navigationItem.leftBarButtonItem) {
        if (navigationController.navigationBarHidden) {
            //当导航被隐藏时直接返回不需要
            return;
        }
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setImage:[UIImage imageNamed:@"back_grey"] forState:UIControlStateNormal];
        [leftButton setImage:[UIImage imageNamed:@"back_grey"] forState:UIControlStateHighlighted];
        leftButton.frame = CGRectMake(0, 0, 44, 19);
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftButton addTarget:self action:@selector(leftBarClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 5;
        
        viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil];
    }
    
    if (navigationController.viewControllers.count == 1) {
        /**
         增加关闭按钮的导航的控制器包括
         
         @param @""
         @param @"" 页
         */
        if ([viewController isKindOfClass:NSClassFromString(@"BaseWKWebViewController")]) {
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [leftButton setTitle:@"关闭" forState:UIControlStateNormal];
            [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            leftButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:Auto_size(15)];
//            leftButton.frame = CGRectMake(0, 0, 44, 19);
            [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            negativeSpacer.width = 5;

            viewController.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil];
        }
    }
}

- (void)leftBarClick {
    //    if ([self.viewControllers.lastObject isKindOfClass:[WaitToSeriveViewController class]]) {
    //        [self popToRootViewControllerAnimated:YES];
    //    }
    [self popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
