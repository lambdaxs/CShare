//
//  XSTextView.m
//  发微博界面1
//
//  Created by xiaos on 15/11/1.
//  Copyright © 2015年 com.xsdota. All rights reserved.
//

#import "XSTextView.h"

@interface XSTextView ()


@end

@implementation XSTextView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"输入视图销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - content
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    self.placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [self setNeedsDisplay];
}

#pragma mark - layout

#pragma mark - private methods
-(void)textViewDidChange
{
    [self setNeedsDisplay];
}

#pragma mark - getter & setter
- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.frame = CGRectMake(5, 8, 0, 0);
        [_placeholderLabel setTextColor:[UIColor grayColor]];
        _placeholderLabel.hidden = YES;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

#pragma mark - darw
- (void)drawRect:(CGRect)rect
{
    if (self.canScrollText) {
        if (self.hasText) {
            self.placeholderLabel.hidden = YES;
            return;
        }
        self.placeholderLabel.hidden = NO;
        return;
    }
    
    if (self.hasText)return;
    CGFloat x = 5;
    CGFloat y = 8;
    CGFloat w = rect.size.width - 2*x;
    CGFloat h = rect.size.height - 2*y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = self.font;
    attrDict[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    
    [self.placeholder drawInRect:placeholderRect withAttributes:attrDict];
}
@end
