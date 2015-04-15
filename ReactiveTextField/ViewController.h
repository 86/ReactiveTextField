//
//  ViewController.h
//  ReactiveTextField
//
//  Created by daisuke yamanaka on 2015/04/14.
//  Copyright (c) 2015年 triaedz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UILabel *userNameMsg;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmField;
@property (weak, nonatomic) IBOutlet UILabel *passwordMsg;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *emailMsg;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

