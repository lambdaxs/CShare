//
//  XSMineViewController.h
//  CShare
//
//  Created by xiaos on 16/3/21.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSMineViewController : UIViewController

@property (nonatomic,copy)  NSString *userId;

- (instancetype)initWithUserId:(NSString *)userId;

@end
