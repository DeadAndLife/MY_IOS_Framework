//
//  BaseTabBarController.m
//  qukanjs
//
//  Created by iOSzhang Inc on 21/1/14.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
//#import "QKHomeViewController.h"
//#import "QKNovelViewController.h"
//#import "QKTaskViewController.h"
//#import "QKMineViewController.h"
#import "AppDelegate.h"

@interface BaseTabBarController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabBarController

+ (instancetype)instance{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[BaseTabBarController class]]) {
        return (BaseTabBarController *)vc;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.tabBar.translucent = NO;
    
    [self setup];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //会话界面发送拍摄的视频，拍摄结束后点击发送后可能顶部会有红条，导致的界面错位。
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//修改tabbar的高度
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    CGRect tabFrame = self.tabBar.frame;
//    tabFrame.size.height = 104+UIApplication.bottomHeight;
//    tabFrame.origin.y = SCREEN_H - tabFrame.size.height;
//    self.tabBar.frame = tabFrame;
//    NSLog(@"tabbarFrame:%@", NSStringFromCGRect(self.tabBar.frame));
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setup {
    for (UIViewController *subVC in self.childViewControllers) {
        [subVC removeFromParentViewController];
    }
    
//    [self addChildViewController:[[QKHomeViewController alloc] init] title:@"首页" normalImageNamed:@"tab_home_nor" selectedImageName:@"tab_home_sel"];
//
//    [self addChildViewController:[[QKNovelViewController alloc] init] title:@"小说" normalImageNamed:@"tab_play_nor" selectedImageName:@"tab_play_sel"];
//
//    [self addChildViewController:[[QKTaskViewController alloc] init] title:@"任务" normalImageNamed:@"tab_task_nor" selectedImageName:@"tab_task_sel"];
//
//    [self addChildViewController:[[QKMineViewController alloc]init] title:@"我的" normalImageNamed:@"tab_mine_nor" selectedImageName:@"tab_mine_sel"];
}

- (void)addChildViewController:(UIViewController *)childController
                         title:(NSString*)title
              normalImageNamed:(NSString *)imageName
             selectedImageName:(NSString*)selectedImageName {
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:childController];
    childController.title = title;
    childController.tabBarItem.title = title;
    //声明显示图片的原始式样 不要渲染
    childController.tabBarItem.image = [[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]
                                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    childController.tabBarItem.imageInsets = UIEdgeInsetsZero;
    [childController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateSelected];
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:colHEX(0x171f24, 1)} forState:UIControlStateSelected];

    [self addChildViewController:nav];
}

@end
