//
//  ViewController.m
//  Demo_UIAlertViewController
//
//  Created by JR_Rafael on 15/11/10.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIAlertController *AlertVc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)alertAction:(id)sender {
    /** 创建一个UIAlertController */
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"标题" message:@"UIAlertController默认样式" preferredStyle:UIAlertControllerStyleAlert];
    
    // 获取当前创建的UIAlertController地址
    self.AlertVc = alert;
    
    // FIXME: 默认样式
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    // FIXME: 取消按键通常情况下取消是放在左边的，注意一点，每一个AlertController只有一个取消按钮，否则系统崩溃
    // FIXME: reason: 'UIAlertController can only have one action with a style of UIAlertActionStyleCancel'
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"hahaha");
    }];
    // FIXME: 警示样式的按钮是用在可能会对数据进行删除或者更改的操作上的，用红色给用户带来醒目的效果。
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"警示" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

    }];
    // 测试
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"测试" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    // readonly
    NSLog(@"%@", action0.title);
    NSLog(@"%ld", action1.style);
    // 是否可以点击
    action0.enabled = NO;

    // TODO: 给Alert添加按钮
    [alert addAction:action0];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    
    // TODO: 添加文本框
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"账号";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"密码";
    }];
    
    // 获取到当前类的对象地址，用__block进行修饰到block中才可正常使用
    __block ViewController *vc = self;
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"姓名";
        textField.delegate = vc;
        [[NSNotificationCenter defaultCenter] addObserver:vc
                                                 selector:@selector(alertTextFieldDidChange:)
                                                     name:@"UITextFieldTextDidChangeNotification"
                                                   object:textField];
    }];
    
    alert.preferredAction = action0;
    
    /** 显示UIAlertController */
    [self presentViewController:alert animated:YES completion:^{}];
}



#pragma mark -  UITextField Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"return");
    return YES;
}



/**
 *  监听textField的改变状况
 *
 *  @param notification UITextFieldTextDidChangeNotification
 */
- (void)alertTextFieldDidChange:(NSNotification *)notification {
    // FIXME: 输入三个字符以上才允许点击
    UITextField *nameField = _AlertVc.textFields[2];
    UIAlertAction *nameAction = _AlertVc.actions[0];
    nameAction.enabled = nameField.text.length > 2;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
