//
//  XSPhotos.m
//  CShare
//
//  Created by xiaos on 16/3/23.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSPhotos.h"

#import "XSImageCell.h"
#import "ObjectiveSugar.h"

@interface XSPhotos ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *collectionView;

@end


static NSString *reuseId = @"photoCell";
@implementation XSPhotos


- (void)reloadPhotos {
    [self.collectionView reloadData];
}

- (instancetype)init{
    if (self = [super init]) {
        [self addCollectionView];
    }
    return self;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XSImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    
    cell.image.image = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSArray *imageViews = [[self.collectionView.subviews reject:^BOOL(id object) {
        return ![object isKindOfClass:[XSImageCell class]];
    }] map:^id(id object) {
        return [object image];
    }];
    
    if (self.selectedIndexOfPhoto) {
        self.selectedIndexOfPhoto(indexPath.row, imageViews);
    }
}

#pragma mark - 添加集合视图
- (void)addCollectionView {
    
    CGFloat SCREES_W = [UIApplication sharedApplication].keyWindow.frame.size.width;

    CGFloat margin = 5;
    CGFloat itemWidth = (SCREES_W - 4*margin)/3;
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    flow.itemSize = (CGSize){itemWidth,itemWidth};
    flow.minimumLineSpacing = margin;
    flow.minimumInteritemSpacing = margin;
    flow.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    UICollectionView *collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(0, 0, SCREES_W, itemWidth*3)
                           collectionViewLayout:flow];

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

@end
