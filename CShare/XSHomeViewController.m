//
//  XSHomeViewController.m
//  CShare
//
//  Created by xiaos on 16/3/21.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSHomeViewController.h"
#import "XSHomeCell.h"
#import "XSHttpClient.h"

#import "XSTitleModel.h"

#import "MJExtension.h"

#import "XSPostController.h"
#import "XSMineViewController.h"



@interface XSHomeViewController ()<UITableViewDataSource, UITableViewDelegate, HomeCellDelegate>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;

@end


static NSString *reuseId = @"homeCell";
@implementation XSHomeViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    
    [self addNaviView];
    
    [self initTableView];
    
    [self loadNetData:^{
        [self.tableView reloadData];
    }];
}


- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUI) name:postSuccessNotificationName object:nil];
}

- (void)reloadUI {
    [self loadNetData:^{
        [self.tableView reloadData];
    }];
}

- (void)loadNetData:(void(^)())success {
    [HttpClient GET:@"https://www.xsdota.com/weibo/v1/title/GetAll.json?token=e0323a9039add2978bf5b49550572c7c" params:nil success:^(id data) {
        self.dataSource = [XSTitleModel objectArrayWithKeyValuesArray:data[@"data"]];
        success();
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(NSProgress *progress) {
        NSLog(@"%f",progress.fractionCompleted);
    }];
}

- (void)avatarViewTap:(NSString *)userId {
    
    [self.navigationController pushViewController:[[XSMineViewController alloc] initWithUserId:userId] animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)postMessage:(UIBarButtonItem *)sender {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[XSPostController new]] animated:YES completion:nil];
}

- (void)addNaviView {
    self.title = @"首页";
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(postMessage:)];
    self.navigationItem.rightBarButtonItem = postButton;
}


- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.estimatedRowHeight = 44;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *cellNib = [UINib nibWithNibName:@"XSHomeCell" bundle:nil];
    [tableView registerNib:cellNib forCellReuseIdentifier:reuseId];
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
    
    cell.delegate = self;
    cell.titleModel = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
