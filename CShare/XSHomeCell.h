//
//  XSHomeCell.h
//  CShare
//
//  Created by xiaos on 16/3/21.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XSTitleModel,XSImagesView;
@protocol HomeCellDelegate <NSObject>

- (void)avatarViewTap:(NSString *)userId;

@end

@interface XSHomeCell : UITableViewCell

@property (nonatomic,strong) XSTitleModel *titleModel;
@property (weak, nonatomic) IBOutlet XSImagesView *imagesView;        //图片

@property (nonatomic,weak) id<HomeCellDelegate> delegate;


@end
