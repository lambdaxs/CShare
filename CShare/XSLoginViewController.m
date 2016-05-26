//
//  XSLoginViewController.m
//  CShare
//
//  Created by xiaos on 16/3/21.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSLoginViewController.h"
#import "XSRegisterViewController.h"
#import "XSTabBarController.h"

@interface XSLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *accoutTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextfield;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end

@implementation XSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.accoutTextfield.delegate = self;
    self.pwdTextfield.delegate = self;
    self.accoutTextfield.tag = 1;
    self.pwdTextfield.tag = 2;
}

#pragma mark - 响应键盘return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.pwdTextfield becomeFirstResponder];
    }else{
        [self login:nil];
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.accoutTextfield resignFirstResponder];
    [self.pwdTextfield resignFirstResponder];
}

- (IBAction)login:(id)sender {
    [UIApplication sharedApplication].keyWindow.rootViewController = [XSTabBarController new];
}


- (IBAction)registerAccout:(id)sender {
    XSRegisterViewController *registerVC = [XSRegisterViewController new];
    
    [self presentViewController:registerVC animated:YES completion:nil];
}

- (IBAction)forgetPwd:(id)sender {
}


@end
