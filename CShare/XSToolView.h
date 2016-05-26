//
//  XSToolView.h
//  CShare
//
//  Created by xiaos on 16/3/22.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XSTitleModel;

//子控件枚举类型 转发 评论 点赞 分享
typedef NS_ENUM(NSUInteger, ToolButtonType) {
    ToolButtonTypeReSend,
    ToolButtonTypeComment,
    ToolButtonTypePraises,
    ToolButtonTypeShare
};

typedef void(^toolBtnTappedBlock)();

@interface XSToolView : UIView

@property (nonatomic,strong) XSTitleModel *titleModel;

@property (nonatomic,copy) toolBtnTappedBlock reSendBlock;
@property (nonatomic,copy) toolBtnTappedBlock commentBlock;
@property (nonatomic,copy) toolBtnTappedBlock praisesBlock;
@property (nonatomic,copy) toolBtnTappedBlock shareBlock;

@end
