//
//  HomeCell.m
//  CShare
//
//  Created by xiaos on 16/3/22.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "HomeCell.h"

#import "HomeCellLayout.h"
#import <Masonry.h>

@implementation HomeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setHomeLayout:(HomeCellLayout *)homeLayout {
    _homeLayout = homeLayout;
    
    //头像
    UIButton *avatarView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:avatarView];
    
    //昵称
    UILabel *nickName = [UILabel new];
    [self.contentView addSubview:nickName];
    
    //时间
    UILabel *timeLabel = [UILabel new];
    [self.contentView addSubview:timeLabel];
    
    //描述
    UILabel *descLabel = [UILabel new];
    [self.contentView addSubview:descLabel];
    
    //正文
    UILabel *contentLabel = [UILabel new];
    [self.contentView addSubview:contentLabel];
    
    //图片
    UIView *photosView = [UIView new];
    [self.contentView addSubview:photosView];
    
    //工具栏
    UIView *toolView = [UIView new];
    [self.contentView addSubview:toolView];
    
    
}



@end
