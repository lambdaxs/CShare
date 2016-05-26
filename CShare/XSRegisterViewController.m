//
//  XSRegisterViewController.m
//  CShare
//
//  Created by xiaos on 16/3/21.
//  Copyright © 2016年 com.xsdota. All rights reserved.
//

#import "XSRegisterViewController.h"

@interface XSRegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accoutTextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextfield;
@property (weak, nonatomic) IBOutlet UITextField *rePwdTextfield;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation XSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.accoutTextfield.tag = 1;
    self.emailTextfield.tag = 2;
    self.pwdTextfield.tag = 3;
    self.rePwdTextfield.tag = 4;
    
    self.accoutTextfield.delegate = self;
    self.emailTextfield.delegate = self;
    self.pwdTextfield.delegate = self;
    self.rePwdTextfield.delegate = self;

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSInteger tfTag = textField.tag;
    switch (tfTag) {
        case 1:
            [self.emailTextfield becomeFirstResponder];
            break;
        case 2:
            [self.pwdTextfield becomeFirstResponder];
            break;
        case 3:
            [self.rePwdTextfield becomeFirstResponder];
            break;
        case 4:
            [self registerTapped:nil];
            break;
        default:
            break;
    }
    
    
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITextField class]]) {
            [obj resignFirstResponder];
        }
    }];
}

- (IBAction)registerTapped:(id)sender {
    
}
- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
