//
//  BNNetDispatch.h
//  StockManagement
//
//  Created by xiaos on 16/3/8.
//  Copyright © 2016年 BONC. All rights reserved.
//

/**
 这个类的主要职责就是获取网络数据
 然后通过MJExtension将网络json数据转换成模型
 再对模型根据业务逻辑加工处理 传出最终数据
 保证控制器拿到的是最需要 最直接的数据
 */

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XSHttpClient.h"
#import "MJExtension.h"
//#import "MBProgressHUD+Extend.h"
//#import <UIView+Toast.h>
//#import "BNParamModel.h"

//#define XSNet [NetDispatch sharedNetDispatch]       ///< 将单例定义为宏 在外层简化调用

typedef void(^anyCompletion)(id result);                   ///< 返回任意对象的闭包
typedef void(^dictCompletion)(NSDictionary *result);      ///< 返回字典类型的闭包
typedef void(^arrayCompletion)(NSArray *results);          ///< 返回数组类型的闭包

@interface BNNetDispatch : NSObject
//singleton_interface(NetDispatch)


@end
