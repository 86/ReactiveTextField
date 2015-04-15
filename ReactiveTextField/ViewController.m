//
//  ViewController.m
//  ReactiveTextField
//
//  Created by daisuke yamanaka on 2015/04/14.
//  Copyright (c) 2015年 triaedz. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController () <UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.userNameField.delegate = self;
    self.passwordField.delegate = self;
    self.passwordConfirmField.delegate = self;
    self.emailField.delegate = self;
    
    RACSignal *passwordSameSignal = [RACSignal
                                     combineLatest:@[self.passwordField.rac_textSignal,
                                                     self.passwordConfirmField.rac_textSignal]
                                     reduce:^(NSString *password, NSString *passwordConfirm) {
                                         return @([password isEqualToString:passwordConfirm]);
                                     }];
    
    RACSignal *passwordLengthEnoughSignal = [RACSignal
                                             combineLatest:@[self.passwordField.rac_textSignal]
                                             reduce:^(NSString *password) {
                                                 return @([password length] >= 8);
                                             }];
    
    // Submit button enable condition
    RACSignal *formValidSignal = [RACSignal
                          combineLatest:@[self.userNameField.rac_textSignal,
                                          self.emailField.rac_textSignal,
                                          passwordSameSignal,
                                          passwordLengthEnoughSignal]
                                  reduce:^(NSString *userName,
                                           NSString *email,
                                           NSNumber *passwordSame,
                                           NSNumber *passwordLengthEnough) {
                                      NSLog(@"%@, %@, %@, %@", userName, email, passwordSame, passwordLengthEnough);
                                      return @([userName length] > 0 &&
                                          [email length] > 0 &&
                                          [passwordSame boolValue] &&
                                          [passwordLengthEnough boolValue]);
                                      }];
     RAC(self.submitButton,enabled) = formValidSignal;
    
    // Password field validation
    RACSignal *passwordValidSignal = [RACSignal
                                      combineLatest:@[passwordSameSignal,
                                                      passwordLengthEnoughSignal]
                                      reduce:^(NSNumber *passwordSame,
                                               NSNumber *passwordLengthEnough) {
                                                  NSString *message = @"";
                                                  if (![passwordLengthEnough boolValue]) {
                                                      message = @"▲ password at least 8 charactors.";
                                                  }
                                                  if (![passwordSame boolValue]) {
                                                      message = @"▲ input same charactors.";
                                                  }
                                                return message;
                                            }];
    RAC(self.passwordMsg,text) = passwordValidSignal;
    RAC(self.passwordField,backgroundColor) = [passwordValidSignal
                                               map:^id(NSNumber *passwordValid) {
                                                   return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor colorWithRed:0.981 green:1.000 blue:0.658 alpha:1.000];
                                               }];
    
    // User Name validation
    RACSignal *userNameVialidSignal = [RACSignal
                                  combineLatest:@[self.userNameField.rac_textSignal]
                                  reduce:^(NSString *userName) {
                                      NSString *message = @"";
                                      if ([userName length] > 0 && [userName length] < 3) {
                                          message = @"▲ username at least 3 charactors.";
                                      }
                                    return message;
                                }];
    RAC(self.userNameMsg,text) = userNameVialidSignal;
    [[[self.userNameField.rac_textSignal
       map:^id(NSString *text) {
           return @(text.length);
       }]
      filter:^BOOL(NSNumber *length) {
          return [length integerValue] >= 3;
      }]
     subscribeNext:^(id x) {
         self.userNameField.backgroundColor = [UIColor colorWithRed:0.711 green:1.000 blue:0.738 alpha:1.000];
     }];
    
    
    // Email validation
    RACSignal *emailVialidSignal = [RACSignal
                                       combineLatest:@[self.emailField.rac_textSignal]
                                       reduce:^(NSString *email) {
                                           NSString *message = @"";
                                           NSCharacterSet *varidSet = [NSCharacterSet characterSetWithCharactersInString:@"@."];
                                           NSCharacterSet *inputSet = [NSCharacterSet characterSetWithCharactersInString:email];
                                           if ([email length] > 0 && ![inputSet isSupersetOfSet:varidSet]) {
                                               message = @"▲ enter valid address.";
                                           }
                                           return message;
                                       }];
    RAC(self.emailMsg,text) = emailVialidSignal;
    
    // Submit button pressed
    RACSignal *submit = [self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    [submit subscribeNext:^(id sender) {
        NSLog(@"button was pressed!");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Nice!" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
