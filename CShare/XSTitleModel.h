//
//  XSTitleModel.h
//  CShare
//
//  Created by xiaos on 16/3/21.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XSUserModel;
@interface XSTitleModel : NSObject


@property (nonatomic, copy) NSString *source;   ///< 发布来源
@property (nonatomic, strong) NSNumber *comments;///< 评论数量
@property (nonatomic, strong) NSArray *images;  ///< 图片数组
@property (nonatomic, copy) NSString *id;       ///< 微博ID
@property (nonatomic, copy) NSString *text;     ///< 微博正文
@property (nonatomic, copy) NSString *user_id;  ///< 发布用户ID
@property (nonatomic, copy) NSString *create_time;  ///< 发布时间
@property (nonatomic, strong) NSArray *praises; ///< 点赞用户列表
@property (nonatomic, strong) XSUserModel *user;    ///< 发布用户信息


@property (nonatomic,assign) BOOL isPraised;    ///< 当前用户是否点赞
@property (nonatomic,strong) NSNumber *praisesNumber; ///< 点赞数量

@property (nonatomic,copy) NSString  *commentStr;
@property (nonatomic,copy) NSString  *praisesStr;
@end

@interface XSUserModel : NSObject

@property (nonatomic, copy) NSString *nick_name;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *friends;

@property (nonatomic, copy) NSString *icon_url;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *descInfo;

@property (nonatomic, copy) NSString *statuses;

@property (nonatomic, copy) NSString *favourites;

@property (nonatomic, copy) NSString *follows;

@end

