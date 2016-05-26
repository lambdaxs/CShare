//
//  XSToolView.m
//  CShare
//
//  Created by xiaos on 16/3/22.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSToolView.h"
#import <Masonry.h>
#import "XSTitleModel.h"

//static NSTimeInterval animaTime = 0.2;
//static CGFloat subMargin = 3.0f;
//static CGFloat viewMargin = 20.0f;

//子控件数量
#define subViewsNumber 4

@interface XSToolView ()

@property (nonatomic,strong) UIButton *reSendButton;    ///< 转发按钮
@property (nonatomic,strong) UIButton *commentButton;   ///< 评论按钮
@property (nonatomic,strong) UIButton *praiseButton;    ///< 点赞按钮
@property (nonatomic,strong) UIButton *shareButton;     ///< 分享按钮

@end

@implementation XSToolView

- (void)awakeFromNib{
    
    //转发
    self.reSendButton = [self setUpToolButtonWithImage:[UIImage imageNamed:@"reply"] selImage:[UIImage imageNamed:@"reply_tapped"]  type:ToolButtonTypeReSend];
    
    
    //评论
    self.commentButton = [self setUpToolButtonWithImage:[UIImage imageNamed:@"message"] selImage:[UIImage imageNamed:@"message_tapped"]  type:ToolButtonTypeComment];
    
//    [self.commentButton setTitle:@"100" forState:0];
    
    //点赞
    self.praiseButton = [self setUpToolButtonWithImage:[UIImage imageNamed:@"favorites"] selImage:[UIImage imageNamed:@"favorites_tapped"]  type:ToolButtonTypePraises];
    
    //分享
    self.shareButton = [self setUpToolButtonWithImage:[UIImage imageNamed:@"share"] selImage:[UIImage imageNamed:@"share_tapped"]  type:ToolButtonTypeShare];
    
    //自动布局
    [self makeLayout];
}


- (void)makeLayout {
    
    [self.reSendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self);
        make.height.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.25);
    }];
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reSendButton.mas_right);
        make.top.and.width.width.height.equalTo(self.reSendButton);
    }];
    
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commentButton.mas_right);
        make.top.and.width.width.height.equalTo(self.reSendButton);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.praiseButton.mas_right);
        make.top.and.width.width.height.equalTo(self.reSendButton);
    }];
}

- (UIButton *)setUpToolButtonWithImage:(UIImage *)image
                              selImage:(UIImage *)selImage
                                  type:(ToolButtonType)type{
    
    CGFloat toolWidth = self.frame.size.width;
    CGFloat imageWidth = (toolWidth/subViewsNumber - 15);
    
    UIButton *toolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    toolButton.tag = type;
    [toolButton addTarget:self action:@selector(toolButtonTapped:) forControlEvents:64];
    [self addSubview:toolButton];
    
    //设置图片偏移
    [toolButton setImage:image forState:0];
    [toolButton setImage:selImage forState:UIControlStateHighlighted];
    [toolButton setImageEdgeInsets:UIEdgeInsetsMake(10, 0, 10, imageWidth)];
    
    //设置文字偏移
    [toolButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -65, 0, 0)];
    [toolButton setTitleColor:[UIColor blackColor] forState:0];
    
    //设置文字对齐方式 大小 颜色
    toolButton.titleLabel.contentMode = UIViewContentModeLeft;
    toolButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [toolButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    return toolButton;
}

- (void)setTitleModel:(XSTitleModel *)titleModel {
    _titleModel = titleModel;
    
    //评论数量
    [self.commentButton setTitle:titleModel.commentStr forState:UIControlStateNormal];
    
    //点赞数量
    [self.praiseButton setTitle:titleModel.praisesStr forState:UIControlStateNormal];
    
}

- (void)toolButtonTapped:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self reSendMessage];
            break;
        case 1:
            [self commentMessage];
            break;
        case 2:
            [self praisesMessage];
            break;
        case 3:
            [self shareMessage];
            break;
        default:
            break;
    }
}

- (void)reSendMessage{
    NSLog(@"转发");
}

- (void)praisesMessage {
    NSLog(@"点赞");
}

- (void)commentMessage {
     NSLog(@"评论");
}

- (void)shareMessage {
     NSLog(@"分享");
}




@end
