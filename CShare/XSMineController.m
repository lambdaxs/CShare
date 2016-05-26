//
//  XSMineController.m
//  CShare
//
//  Created by xiaos on 16/3/23.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSMineController.h"

#import <Masonry.h>

#import "XSMineViewController.h"

@interface XSMineController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation XSMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我";
    [self initTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.estimatedRowHeight = 44;
    tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section == 1 ? 4: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:reuseID];
    }
    
    if (indexPath.section == 0) {
        
        UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"100"]];
        avatarView.layer.cornerRadius = 5;
        avatarView.clipsToBounds = YES;
        [cell.contentView addSubview:avatarView];
        [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(8);
            make.left.equalTo(cell.contentView).offset(8);
            make.width.and.height.equalTo(@60);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-8);
        }];
        
        UILabel *nickNameLabel = [UILabel new];
        nickNameLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:17.0f];
        [cell.contentView addSubview:nickNameLabel];
        nickNameLabel.text = @"你怎么又胖了";
        [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(avatarView.mas_right).offset(8);
            make.top.equalTo(avatarView);
        }];
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"MoreMyFavorites"];
            cell.textLabel.text = @"微博";
        }else if (indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"MoreMyAlbum"];
            cell.textLabel.text = @"相册";
        }else if(indexPath.row == 2) {
            cell.imageView.image = [UIImage imageNamed:@"MoreExpressionShops"];
            cell.textLabel.text = @"我的赞";
        }else {
            cell.imageView.image = [UIImage imageNamed:@"MyCardPackageIcon"];
            cell.textLabel.text = @"我的收藏";
        }
    }else {
        cell.imageView.image = [UIImage imageNamed:@"MoreSetting"];
        cell.textLabel.text = @"设置";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {//修改资料
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {//查看全部微博
            [self.navigationController pushViewController:[[XSMineViewController alloc] initWithUserId:@"102"] animated:YES];
        }else if(indexPath.row == 1) {//查看全部相册
            
        }else if (indexPath.row == 2){//我的赞
            
        }else if (indexPath.row == 3) {//我的收藏
            
        }else{
            
        }
        
    }else {//修改设置
        
    }
    
    
}

@end
