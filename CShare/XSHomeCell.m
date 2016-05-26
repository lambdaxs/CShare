//
//  XSHomeCell.m
//  CShare
//
//  Created by xiaos on 16/3/21.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSHomeCell.h"
#import "XSTitleModel.h"
#import "XSImagesView.h"
#import "XSToolView.h"
#import <Masonry.h>

#import <UIImageView+WebCache.h>

@interface XSHomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarView;   //头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameView;     //昵称
@property (weak, nonatomic) IBOutlet UILabel *descView;         //描述
@property (weak, nonatomic) IBOutlet UILabel *timeView;         //时间戳
@property (weak, nonatomic) IBOutlet UILabel *ContentTextView;  //正文
@property (weak, nonatomic) IBOutlet XSToolView *toolView;          //工具条

@end

@implementation XSHomeCell

- (void)awakeFromNib {
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped:)];
    self.avatarView.userInteractionEnabled = YES;
    [self.avatarView addGestureRecognizer:tap];
}

- (void)avatarTapped:(UIImageView *)sender {
    
    if ([self.delegate respondsToSelector:@selector(avatarViewTap:)]) {
        [self.delegate avatarViewTap:self.titleModel.user_id];
    }
}

- (void)setTitleModel:(XSTitleModel *)titleModel {
    _titleModel = titleModel;
        
    XSUserModel *userModel = titleModel.user;
    
    
    //头像
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:userModel.icon_url]
                       placeholderImage:[UIImage imageNamed:@"people"]];
    
    //昵称
    self.nickNameView.text = userModel.nick_name;
    
    //描述
    self.descView.text = userModel.descInfo;
    
    //时间戳
    self.timeView.text = titleModel.create_time;
    
    //正文
    self.ContentTextView.text = titleModel.text;
    
    //图片
    
    if(titleModel.images.count == 0){
        self.imagesView.hidden = YES;
        [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0).priorityHigh();
            make.height.equalTo(@128).priorityLow();
        }];
        
    }else{
        self.imagesView.hidden = NO;
        self.imagesView.images = titleModel.images;
        [self.imagesView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0).priorityLow();
            make.height.equalTo(@128).priorityHigh();
        }];
    }
    
    //工具条
    self.toolView.titleModel = self.titleModel;
}


@end
