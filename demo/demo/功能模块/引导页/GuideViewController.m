//
//  GuideViewController.m
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/3.
//

#import "GuideViewController.h"

static NSInteger GUIDE_VERSION = 1;
static NSString *GUIDE_VERSION_KEY = @"GUIDE_VERSION_KEY";

typedef void (^GuideViewAction)(void);

@interface GuideViewController ()<UIScrollViewDelegate>

/// <#Description#>
@property (nonatomic, strong) UIScrollView *scrollView;

/// <#Description#>
@property (nonatomic, strong) UIPageControl *pageControl;

/// <#Description#>
@property (nonatomic, strong) NSArray *guideImageArray;

/// <#Description#>
@property (nonatomic, strong) UIButton *beginButton;

/// <#Description#>
@property (nonatomic) GuideViewAction confirmAction;

@end

@implementation GuideViewController

+ (instancetype)shared {
    static GuideViewController *objc;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        objc = [[GuideViewController alloc] init];
    });
    return objc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-UIApplication.bottomHeight-8);
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(SCREEN_W*(self.guideImageArray.count), 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        for (int i = 0; i < self.guideImageArray.count; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i*SCREEN_W, 0, SCREEN_W, SCREEN_H)];
            [_scrollView addSubview:view];
            
            UIImage *originGuideImage = [self.guideImageArray objectAtSafeIndex:i];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = originGuideImage;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = true;
            [view addSubview:imageView];
            
            //设置view的底部背景色，将超出部分填充为合适的颜色
            if ((SCREEN_W/SCREEN_H)>(originGuideImage.size.width/originGuideImage.size.height)) {
                //左右加颜色
                UIImage *leftImage = [UIImage catImageFromImage:originGuideImage inRect:CGRectMake(0, 0, 1, originGuideImage.size.height)];
                UIImage *rightImage = [UIImage catImageFromImage:originGuideImage inRect:CGRectMake(originGuideImage.size.width-1, 0, 1, originGuideImage.size.height)];
                
                CALayer *leftLayer = [[CALayer alloc] init];
                leftLayer.frame = CGRectMake(0, 0, SCREEN_W/2, SCREEN_H);
                leftLayer.contents = (__bridge id _Nullable)(leftImage.CGImage);
                
                [view.layer insertSublayer:leftLayer below:imageView.layer];

                CALayer *rightLayer = [[CALayer alloc] init];
                rightLayer.frame = CGRectMake(SCREEN_W/2, 0, SCREEN_W/2, SCREEN_H);
                rightLayer.contents = (__bridge id _Nullable)(rightImage.CGImage);
                [view.layer insertSublayer:rightLayer below:imageView.layer];
                
            } else if ((SCREEN_W/SCREEN_H)<(originGuideImage.size.width/originGuideImage.size.height)) {
                //上下加颜色
                UIImage *topImage = [UIImage catImageFromImage:originGuideImage inRect:CGRectMake(0, 0, originGuideImage.size.width, 1)];
                UIImage *bottomImage = [UIImage catImageFromImage:originGuideImage inRect:CGRectMake(0, originGuideImage.size.height-1, originGuideImage.size.width, 1)];
                
                CALayer *topLayer = [[CALayer alloc] init];
                topLayer.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H/2);
                topLayer.contents = (__bridge id _Nullable)(topImage.CGImage);
                
                [view.layer insertSublayer:topLayer below:imageView.layer];
                
                CALayer *bottomLayer = [[CALayer alloc] init];
                bottomLayer.frame = CGRectMake(0, SCREEN_H/2, SCREEN_W, SCREEN_H/2);
                bottomLayer.contents = (__bridge id _Nullable)(bottomImage.CGImage);
                
                [view.layer insertSublayer:bottomLayer below:imageView.layer];
            }
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(0);
            }];
            
            if (i == self.guideImageArray.count-1) {
                [view addSubview:self.beginButton];
                
                [self.beginButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-UIApplication.bottomHeight-30);
                    make.centerX.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(Auto_size(120), 40));
                }];
            }
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = colHEX(0xDDDDDD, 1);
        _pageControl.currentPageIndicatorTintColor = colHEX(0x3375FF, 1);
        _pageControl.numberOfPages = self.guideImageArray.count;
        self.pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (UIButton *)beginButton {
    if (!_beginButton) {
        _beginButton = [[UIButton alloc] init];
        [_beginButton setTitle:@"开始" forState:UIControlStateNormal];
        _beginButton.layer.backgroundColor = colHEX(0x3375FF, 1).CGColor;
        _beginButton.layer.cornerRadius = 20;
        
        [_beginButton addTarget:self action:@selector(beginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beginButton;
}

- (NSArray *)guideImageArray {
    return @[
        [UIImage imageNamed:@"guide1"],
        [UIImage imageNamed:@"guide2"],
        [UIImage imageNamed:@"guide3"],
    ];
}

- (IBAction)beginButtonClick:(UIButton *)sender {
    if (self.confirmAction) {
        self.confirmAction();
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/SCREEN_W;
    self.pageControl.currentPage = page;
}

- (void)showWithConfirmAction:(void(^)(void))confirmAction {
    NSInteger nowGuideVersion = [[NSUserDefaults standardUserDefaults] integerForKey:GUIDE_VERSION_KEY];
    if (GUIDE_VERSION>nowGuideVersion) {
        [[NSUserDefaults standardUserDefaults] setInteger:GUIDE_VERSION forKey:GUIDE_VERSION_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.confirmAction = confirmAction;
        self.view.alpha = 1;
        self.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    }
}


@end
