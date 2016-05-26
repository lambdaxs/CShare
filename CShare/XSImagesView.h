//
//  XSImagesView.h
//  CShare
//
//  Created by xiaos on 16/3/21.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSImagesView : UIView

@property (nonatomic,strong) NSArray *images;
@property (nonatomic,weak) UICollectionView *collectionView;

@end
