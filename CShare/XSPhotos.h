//
//  XSPhotos.h
//  CShare
//
//  Created by xiaos on 16/3/23.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedIndexOfPhoto)(NSInteger index, NSArray *imageViews);

@interface XSPhotos : UIView

@property (nonatomic,strong) NSArray *dataSource;

- (void)reloadPhotos;

@property (nonatomic,copy) selectedIndexOfPhoto selectedIndexOfPhoto;

@end
