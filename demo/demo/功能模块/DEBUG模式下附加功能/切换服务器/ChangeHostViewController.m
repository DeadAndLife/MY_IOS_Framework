//
//  ChangeHostViewController.m
//  zhibo
//
//  Created by iOSzhang Inc on 21/6/8.
//

#import "ChangeHostViewController.h"

#ifdef DEBUG

static NSString *cellReuseIdentifier = @"changeHost";

typedef void (^ChangeHostAction)(void);

@interface ChangeHostViewController ()<UITableViewDelegate, UITableViewDataSource>

/// <#Description#>
@property (nonatomic, strong) UITableView *tableView;

/// <#Description#>
@property (nonatomic) ChangeHostAction cancelAction;

/// <#Description#>
@property (nonatomic) ChangeHostAction confirmAction;

@end

@implementation ChangeHostViewController

+ (instancetype)shared {
    static ChangeHostViewController *objc;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        objc = [[ChangeHostViewController alloc] init];
    });
    return objc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:cellReuseIdentifier];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[APPSettingManager shared] hostList].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *hostDict = [[[APPSettingManager shared] hostList] objectAtSafeIndex:indexPath.row];
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
//    if (!cell) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuseIdentifier];
//    }
    cell.textLabel.text = [hostDict safeValueForKey:@"host"];
    cell.detailTextLabel.text = [hostDict safeValueForKey:@"desc"];
    NSDictionary *nowHost = [[APPSettingManager shared] nowHost];
    if ([[hostDict safeValueForKey:@"host"] isEqual:[nowHost safeValueForKey:@"host"]]) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        if (@available(iOS 13.0, *)) {
            cell.textLabel.textColor = [UIColor labelColor];
        } else {
            cell.textLabel.textColor = [UIColor darkGrayColor];
            // Fallback on earlier versions
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *hostDict = [[[APPSettingManager shared] hostList] objectAtSafeIndex:indexPath.row];
    if (![[hostDict safeValueForKey:@"host"] isEqual:[[[APPSettingManager shared] nowHost] safeValueForKey:@"host"]]) {
        [[APPSettingManager shared] setNowHost:hostDict];
        [self back:true completion:^{
            if (self.confirmAction) {
                self.confirmAction();
            }
        }];
    } else {
        [self back:true completion:^{
            if (self.cancelAction) {
                self.cancelAction();
            }
        }];
    }
}

- (void)showWithCancelAction:(void(^)(void))cancelAction confirmAction:(void(^)(void))confirmAction {
    self.cancelAction = cancelAction;
    self.confirmAction = confirmAction;
    
    [[UIViewController MY_visibleViewController] presentViewController:self animated:true completion:^{
    }];
}

@end

#endif
