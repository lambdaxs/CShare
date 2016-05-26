//
//  XSImageCell.m
//  CShare
//
//  Created by xiaos on 16/3/22.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSImageCell.h"

@implementation XSImageCell

- (void)awakeFromNib {
    
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    self.image.userInteractionEnabled = YES;
    
    self.image.layer.borderWidth = 1;
    self.image.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    self.image.layer.cornerRadius = 3;
    self.image.clipsToBounds = YES;
    
}

@end
