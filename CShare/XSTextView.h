//
//  XSTextView.h
//  发微博界面1
//
//  Created by xiaos on 15/11/1.
//  Copyright © 2015年 com.xsdota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSTextView : UITextView

/** 占位符 */
@property (nonatomic,strong) NSString *placeholder;
/** 占位符颜色 */
@property (nonatomic,strong) UIColor *placeholderColor;
/** 占位符能否跟随滑动 默认不能滑动用drawRect实现  滑动用UILabel实现 */
@property (nonatomic,assign) BOOL canScrollText;

@property (nonatomic,strong) UILabel *placeholderLabel;

@end
