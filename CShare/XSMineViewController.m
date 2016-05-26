//
//  XSMineViewController.m
//  CShare
//
//  Created by xiaos on 16/3/21.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSMineViewController.h"

//头视图
#import "XSHomePage.h"
#import "HFStretchableTableHeaderView.h"
//cell
#import "XSHomeCell.h"

//模型
#import "XSTitleModel.h"
#import "MJExtension.h"

//网络数据 视图布局
#import "XSHttpClient.h"
#import <Masonry.h>

@interface XSMineViewController ()<UITableViewDataSource, UITableViewDelegate, HomeCellDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;

@property (nonatomic,strong) HFStretchableTableHeaderView *stretchHeaderView;

@end


static NSString *reuseId = @"homePageCell";
@implementation XSMineViewController

- (instancetype)initWithUserId:(NSString *)userId {
    if (self = [super init]) {
        self.userId = userId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNaviView];
    [self initTableView];
    
    NSDictionary *param = @{@"userId":self.userId};
    
    [HttpClient GET:@"http://www.xsdota.com/weibo/v1/title/getTitleList.json" params:param success:^(id data) {
        self.dataSource = [XSTitleModel objectArrayWithKeyValuesArray:data[@"data"]];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(NSProgress *progress) {
        NSLog(@"%f",progress.fractionCompleted);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)avatarViewTap:(NSString *)userId {
    [self.navigationController pushViewController:[[XSMineViewController alloc] initWithUserId:userId] animated:YES];
}

- (void)showPhotos:(UIBarButtonItem *)sender {
    
}


- (void)initNaviView {
    
    self.title = @"你怎么又胖了";
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(showPhotos:)];
    self.navigationItem.rightBarButtonItem = right;
    
    //去掉tableView的自适应下滑
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置初始的导航栏颜色为透明
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0]] forBarMetrics:UIBarMetricsDefault];
//    //去掉系统自己加的阴影图片
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    
//   
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:0]}];//导航栏字体颜色
}

- (void)initTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.estimatedRowHeight = 44;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *cellNib = [UINib nibWithNibName:@"XSHomeCell" bundle:nil];
    [tableView registerNib:cellNib forCellReuseIdentifier:reuseId];
    
    
    //拉伸头部
    self.stretchHeaderView = [HFStretchableTableHeaderView new];
    [self.stretchHeaderView stretchHeaderForTableView:tableView withView:[[XSHomePage alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 150)] subViews:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XSHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId forIndexPath:indexPath];
    
    cell.titleModel = self.dataSource[indexPath.row];
    cell.delegate = self;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"全部微博";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28.0f;
}

#pragma mark - stretchableTable delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self.stretchHeaderView scrollViewDidScroll:scrollView];
    
    
//    if (self.tableView.contentOffset.y < 150) {
//        [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:self.tableView.contentOffset.y / 100]] forBarMetrics:UIBarMetricsDefault];
//        
//        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1 green:1 blue:1 alpha:self.tableView.contentOffset.y / 100]}];//导航栏字体颜色
//        
//    }
    
}

- (void)viewDidLayoutSubviews
{
    [self.stretchHeaderView resizeView];
}

-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
