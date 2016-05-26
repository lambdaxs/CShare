//
//  XSPostController.m
//  CShare
//
//  Created by xiaos on 16/3/22.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSPostController.h"

#import "XSTextView.h"

#import <Masonry.h>

#import "XSHttpClient.h"

#import "XSPhotos.h"

#import "JFImagePickerController.h"

#import "YYPhotoGroupView.h"

#import "ObjectiveSugar.h"

@interface XSPostController ()<UITableViewDataSource, UITableViewDelegate, JFImagePickerDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,weak) XSTextView *textView;

@property (nonatomic,weak) XSPhotos *photoView;

@property (nonatomic,weak) UIToolbar *toolbar;

@property (nonatomic,strong) NSArray *thumbPhotos;  //保存缩略图数组

@property (nonatomic,strong) NSArray *originalPhotos;   //保存原始图数组

@end

@implementation XSPostController

- (void)dealloc {
    NSLog(@"发送视图释放");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addObservers];
    [self initNaviView];
    [self initTableView];
    [self initPhotoView];
    [self initToolbar];
}

- (void)viewDidAppear:(BOOL)animated {
    //选中输入框
    if ([self.textView canBecomeFirstResponder]) {
        [self.textView becomeFirstResponder];
    }
}

- (void)addObservers {
    //键盘出现通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //键盘消失通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)postMessage {
    
    if (!self.textView.hasText) {
       NSLog(@"请输入内容");
        return;
    }
    
    NSDictionary *paramDict = @{
                                @"token":@"372c59c03547dd50f0fe2c30e400ed52",
                                @"text":self.textView.text,
                                @"source":@"iPhone"
                                };
    
    __weak typeof(self) weakSelf = self;
    [HttpClient POST:@"https://www.xsdota.com/weibo/v1/title/post.json" params:paramDict success:^(id data) {
        NSLog(@"%@",data);
        [weakSelf closePostView];
        [[NSNotificationCenter defaultCenter] postNotificationName:postSuccessNotificationName object:nil];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    } progress:^(NSProgress *progress) {
        NSLog(@"%f",progress.fractionCompleted);
    }];
}

- (void)closePostView {
    [self resignResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//注销输入框
- (void)resignResponder {
    if ([self.textView canResignFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

- (void)keyboardWillShow:(NSNotification *)showInfo {
    
    //动画时间
    CGFloat durationTime = [[showInfo.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //键盘高度
    CGFloat keyboardHeight = ({
        [[showInfo.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    });
    
    [UIView animateWithDuration:durationTime animations:^{
        self.toolbar.transform = CGAffineTransformMakeTranslation(0,  -keyboardHeight);
    }];
    
    
}

- (void)keyboardWillHide:(NSNotification *)hideInfo {
    //动画时间
    CGFloat durationTime = [[hideInfo.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:durationTime animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
    }];
}


//设置导航栏
- (void)initNaviView {
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(closePostView)];
    self.navigationItem.leftBarButtonItem = left;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(postMessage)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 44;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@160);
    }];
}

- (void)initPhotoView {
    //相册视图
    XSPhotos *photosView = [XSPhotos new];
    self.photoView = photosView;
    [self.view addSubview:photosView];
    
    __weak typeof(self) weakSelf = self;
    photosView.selectedIndexOfPhoto = ^(NSInteger index, NSArray *imageViews){
        [weakSelf resignResponder];
        [weakSelf showPhotos:imageViews
               imagesURL:@[[NSURL URLWithString:@"http://www.xsdota.com/images/icons/a.png"],
                           [NSURL URLWithString:@"http://www.xsdota.com/images/icons/b.png"],
                           [NSURL URLWithString:@"http://www.xsdota.com/images/icons/c.png"],
                           [NSURL URLWithString:@"http://www.xsdota.com/images/icons/d.png"],
                           [NSURL URLWithString:@"http://www.xsdota.com/images/icons/a.png"],
                           [NSURL URLWithString:@"http://www.xsdota.com/images/icons/b.png"],
                           [NSURL URLWithString:@"http://www.xsdota.com/images/icons/c.png"],
                           [NSURL URLWithString:@"http://www.xsdota.com/images/icons/d.png"],
                           [NSURL URLWithString:@"http://www.xsdota.com/images/icons/d.png"]
                           ] index:index];
    };
    
    [photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(3);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)initToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 35, self.view.frame.size.width, 35)];
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *photoItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openPhotos)];
    [toolbar setItems:@[spaceItem,photoItem]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:reuseID];
    }
    
    if (indexPath.row == 0) {
        //输入框
        XSTextView *inputView = [XSTextView new];
        self.textView = inputView;
        inputView.placeholder = @"说点什么";
        inputView.font = [UIFont fontWithName:@".SFUIText-Light" size:17.0f];
        [cell.contentView addSubview:inputView];
        
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).offset(8);
            make.left.equalTo(cell.contentView).offset(8);
            make.right.equalTo(cell.contentView.mas_right).offset(-8);
            make.height.equalTo(@140);
            make.bottom.equalTo(cell.contentView.mas_bottom);
        }];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)openPhotos {
    JFImagePickerController *picker = [[JFImagePickerController alloc] initWithRootViewController:self];
    picker.pickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerDidCancel:(JFImagePickerController *)picker {
    [JFImagePickerController clear];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerDidFinished:(JFImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
        
    self.originalPhotos = [picker imagesWithType:2];
    self.photoView.dataSource = self.originalPhotos;
    [self.photoView reloadPhotos];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textView resignFirstResponder];
}

- (void)showPhotos:(NSArray *)imageViews imagesURL:(NSArray *)urls index:(NSInteger)index {
    
    __block UIImageView *fromView = nil;

    NSArray *items = [imageViews mapWithIndex:^id(id object, NSInteger idx) {
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = object;
        item.largeImageURL = urls[idx];
        if (idx == index) {
            fromView = object;
        }
        return item;
    }];
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
}




@end
