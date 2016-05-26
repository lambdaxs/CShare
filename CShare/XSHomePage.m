//
//  XSHomePage.m
//  CShare
//
//  Created by xiaos on 16/3/22.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSHomePage.h"

@interface XSHomePage ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;   ///<头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;    ///<昵称
@property (weak, nonatomic) IBOutlet UILabel *descLabel;        ///<描述
@property (weak, nonatomic) IBOutlet UILabel *titlesNumLabel;   ///<微博数量
@property (weak, nonatomic) IBOutlet UILabel *followsNumLabel;  ///<关注数量
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;     ///<粉丝数量

@end

@implementation XSHomePage

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"XSHomePage" owner:nil options:nil].firstObject;
        self.avatarView.clipsToBounds = YES;
    }
    return self;
}

@end
