//
//  XSImagesView.m
//  CShare
//
//  Created by xiaos on 16/3/21.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSImagesView.h"
#import "XSImageCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface XSImagesView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@end

static NSString *reuseId = @"imageCell";
@implementation XSImagesView

- (void)awakeFromNib{
    
    //集合视图布局
    [self addCollectionView];
}

- (void)setImages:(NSArray *)images {
    _images = images;
    
    
    
    if (images.count == 0) {
        return;
    }else {
        CGFloat viewWidth = [UIApplication sharedApplication].keyWindow.frame.size.width - 16;
        CGFloat width = 128*images.count + 6*(images.count -1);
        
        if (width >= viewWidth) {
            width = viewWidth;
        }
        
        self.collectionView.frame = CGRectMake(0, 0, width, 128);
    }
    
    
    
//    if (images.count == 1) {
//        self.collectionView.frame = CGRectMake(0, 0, 128, 128);
//    }else {
//        self.collectionView.frame = CGRectMake(0, 0, width - 16, 128);
//    }
    
    [self.collectionView reloadData];
}

#pragma mark - 添加集合视图
- (void)addCollectionView {
    
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    flow.itemSize = CGSizeMake(128, 128);
    flow.minimumInteritemSpacing = 6;
    flow.minimumLineSpacing = 6;
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.scrollsToTop = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"XSImageCell" bundle:nil];
    [collectionView registerNib:cellNib forCellWithReuseIdentifier:reuseId];
    
    self.collectionView = collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XSImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:self.images[indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   NSLog(@"tapped===%ld",(long)indexPath.row);
}




#pragma mark - 手动给图片赋值
- (void)addImage {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgV = (UIImageView *)obj;
        if (idx < self.images.count)
        {//显示
            [imgV sd_setImageWithURL:[NSURL URLWithString:self.images[idx][@"image_url"]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
            imgV.hidden = NO;
        }
        else
        {//隐藏
            imgV.hidden = YES;
        }
    }];
}


#pragma mark - 手动添加imageView
- (void)addImageView {
    for (NSInteger i = 0; i < 9; i++)
    {
        UIImageView *imgV = [UIImageView new];
        imgV.contentMode = UIViewContentModeScaleAspectFill;
        imgV.userInteractionEnabled = YES;
        imgV.layer.cornerRadius  = 3.0f;
        imgV.clipsToBounds = YES;
        imgV.tag = i ;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [imgV addGestureRecognizer:tap];
        [self addSubview:imgV];
    }
}

- (void)tapped:(UITapGestureRecognizer *)tap {
    NSLog(@"tapped");
}

#pragma mark - 手动frame布局
- (void)addLayout {
    if (self.images.count == 1) {
        UIImageView *oneImgV = self.subviews.firstObject;
        oneImgV.frame = CGRectMake(0, 0, 300, 128);
        return;
    }
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat margin = 3;
    NSInteger col = 0;
    NSInteger rol = 0;
    NSInteger cols = self.images.count == 4 || self.images.count == 2 ? 2: 3;
    CGFloat w = 128;
    CGFloat h = w;
    
    // 计算显示出来的imageView
    for (NSInteger i = 0; i < self.images.count; i++) {
        col = i % cols;
        rol = i / cols;
        UIImageView *imageV = self.subviews[i];
        x = col * (w + margin);
        y = rol * (h + margin);
        imageV.frame = CGRectMake(x, y, w, h);
    }
    
}



@end
