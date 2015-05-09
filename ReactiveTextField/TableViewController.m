//
//  TableViewController.m
//  ReactiveTextField
//
//  Created by daisuke yamanaka on 2015/04/17.
//  Copyright (c) 2015年 triaedz. All rights reserved.
//

#import "TableViewController.h"
#import "TRZBorderedButton.h"
#import "TRZValidationResultView.h"

static const NSInteger TRZUserNameLengthMin = 3;
static const NSInteger TRZUserNameLengthMax = 8;
static const NSInteger TRZPasswordLengthMin = 6;
static const NSInteger TRZPasswordLengthMax = 10;
static const NSString *TRZEmailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";

typedef NS_ENUM(NSInteger, TRZValidLenghtResult) {
    TRZValidLenghtResultNone,
    TRZValidLenghtResultValid,
    TRZValidLenghtResultShort,
    TRZValidLenghtResultOver,
};

typedef NS_ENUM(NSInteger, TRZValidFormatResult) {
    TRZValidFormatResultNone,
    TRZValidFormatResultValid,
    TRZValidFormatResultInvalid,
};

typedef NS_ENUM(NSInteger, TRZValidPasswordResult) {
    TRZValidPasswordResultNone,
    TRZValidPasswordResultValid,
    TRZValidPasswordResultShort,
    TRZValidPasswordResultOver,
    TRZValidPasswordResultNotSame,
};

@interface TableViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmField;

@property (strong, nonatomic) TRZValidationResultView *userNameResultView;
@property (strong, nonatomic) TRZValidationResultView *emailResultView;
@property (strong, nonatomic) TRZValidationResultView *passwordResultView;

@property (weak, nonatomic) IBOutlet TRZBorderedButton *doneButton;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userNameField.delegate = self;
    self.passwordField.delegate = self;
    self.passwordConfirmField.delegate = self;
    self.emailField.delegate = self;
   
    // generate validation result views
    self.userNameResultView = [[TRZValidationResultView alloc] init];
    self.emailResultView = [[TRZValidationResultView alloc] init];
    self.passwordResultView = [[TRZValidationResultView alloc] init];
    
    // User name validation
    RACSignal *validUserNameLength = [self.userNameField.rac_textSignal
                                      map:^id(NSString *userName) {
                                          NSInteger length = [userName length];
                                          if (length > 0 && length < TRZUserNameLengthMin) {
                                              return @(TRZValidLenghtResultShort);
                                          } else if (length >= TRZUserNameLengthMin && length <= TRZUserNameLengthMax) {
                                              return @(TRZValidLenghtResultValid);
                                          } else if (length > TRZUserNameLengthMax) {
                                              return @(TRZValidLenghtResultOver);
                                          }
                                          return @(TRZValidLenghtResultNone);
                                      }];
    
    [[validUserNameLength distinctUntilChanged] subscribeNext:^(NSNumber *validLengthResult) {
        NSLog(@"validUserNameLength signal: %@", validLengthResult);
        NSInteger result = [validLengthResult intValue];
        switch (result) {
            case TRZValidLenghtResultNone: {
                [UIView animateWithDuration:0.3 animations:^{
                    self.userNameResultView.alpha = 0.0;
                    self.userNameResultView.resultMessage.text = @"";
                    self.userNameResultView.resultIcon.image = nil;
                }];
                break;
            }
            case TRZValidLenghtResultShort: {
                [UIView animateWithDuration:0.1 animations:^{self.userNameResultView.alpha = 0.0;} completion:^(BOOL finished){
                    self.userNameResultView.resultMessage.text = [NSString stringWithFormat:@"at least %ld charactors.", (long)TRZUserNameLengthMin];
                    self.userNameResultView.resultIcon.image = [UIImage imageNamed:@"ResultWarning"];
                    [UIView animateWithDuration:0.3 animations:^{self.userNameResultView.alpha = 1.0;}];
                }];
                break;
            }
            case TRZValidLenghtResultValid: {
                [UIView animateWithDuration:0.1 animations:^{self.userNameResultView.alpha = 0.0;} completion:^(BOOL finished){
                    self.userNameResultView.resultMessage.text = @"OK!";
                    self.userNameResultView.resultIcon.image = [UIImage imageNamed:@"ResultOK"];
                    [UIView animateWithDuration:0.3 animations:^{self.userNameResultView.alpha = 1.0;}];
                }];
                break;
            }
            case TRZValidLenghtResultOver: {
                [UIView animateWithDuration:0.1 animations:^{ self.userNameResultView.alpha = 0.0;} completion:^(BOOL finished){
                    self.userNameResultView.resultMessage.text = [NSString stringWithFormat:@"max %ld charactors.", (long)TRZUserNameLengthMax];;
                    self.userNameResultView.resultIcon.image = [UIImage imageNamed:@"ResultWarning"];
                    [UIView animateWithDuration:0.3 animations:^{self.userNameResultView.alpha = 1.0;}];
                }];
                break;
            }
            default: {
                break;
            }
        }
    }];
    
    // Email Validation
    RACSignal *validEmailFormat = [self.emailField.rac_textSignal
                                   map:^id(NSString *email) {
                                       NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", TRZEmailRegex];
                                       if (email.length > 0) {
                                           if ([emailTest evaluateWithObject:email]) {
                                                return @(TRZValidFormatResultValid);
                                           }
                                           return @(TRZValidFormatResultInvalid);
                                       }
                                       return @(TRZValidFormatResultNone);
                                   }];
    
    [[validEmailFormat distinctUntilChanged] subscribeNext:^(NSNumber *validFormatResult) {
        NSLog(@"validEmailFormat signal: %@", validFormatResult);
        NSInteger result = [validFormatResult intValue];
        switch (result) {
            case TRZValidFormatResultNone: {
                [UIView animateWithDuration:0.3 animations:^{
                    self.emailResultView.alpha = 0.0;
                    self.emailResultView.resultMessage.text = @"";
                    self.emailResultView.resultIcon.image = nil;
                }];
                break;
            }
            case TRZValidFormatResultInvalid: {
                [UIView animateWithDuration:0.1 animations:^{self.emailResultView.alpha = 0.0;} completion:^(BOOL finished){
                    self.emailResultView.resultMessage.text = @"input valid email address.";
                    self.emailResultView.resultIcon.image = [UIImage imageNamed:@"ResultWarning"];
                    [UIView animateWithDuration:0.3 animations:^{self.emailResultView.alpha = 1.0;}];
                }];
                break;
            }
            case TRZValidFormatResultValid: {
                [UIView animateWithDuration:0.1 animations:^{self.emailResultView.alpha = 0.0;} completion:^(BOOL finished){
                    self.emailResultView.resultMessage.text = @"OK!";
                    self.emailResultView.resultIcon.image = [UIImage imageNamed:@"ResultOK"];
                    [UIView animateWithDuration:0.3 animations:^{self.emailResultView.alpha = 1.0;}];
                }];
                break;
            }
            default:
                break;
        }
    }];
    
    // Password Validation
    RACSignal *validPasswordLength = [[self.passwordField.rac_textSignal
                                      filter:^BOOL(NSString *password) {
                                          NSInteger length = [password length];
                                          return length < TRZPasswordLengthMin || length > TRZPasswordLengthMax;
                                      }]
                                      map:^id(NSString *password) {
                                          NSInteger length = [password length];
                                          if (length > 0 && length < TRZPasswordLengthMin) {
                                              return @(TRZValidPasswordResultShort);
                                          } else if (length > TRZPasswordLengthMax) {
                                              return @(TRZValidPasswordResultOver);
                                          }
                                          return @(TRZValidPasswordResultNone);
                                      }];
    
    RACSignal *validPassword = [self.passwordField.rac_textSignal
                                      filter:^BOOL(NSString *password) {
                                          NSInteger length = [password length];
                                          return length >= TRZPasswordLengthMin && length <= TRZPasswordLengthMax;
                                      }];
    
    RACSignal *validPasswordsEqual = [RACSignal
                                      combineLatest:@[validPassword, self.passwordConfirmField.rac_textSignal]
                                      reduce:^(NSString *password, NSString *passwordConfirm) {
                                          NSLog(@"password signal: %@, passwordConfirm signal: %@", password, passwordConfirm);
                                          return [password isEqualToString:passwordConfirm] ? @(TRZValidPasswordResultValid) : @(TRZValidPasswordResultNotSame);
                                      }];
    
    RACSignal *validPasswordConfirm = [validPasswordLength merge:validPasswordsEqual];
    
    [[validPasswordConfirm distinctUntilChanged] subscribeNext:^(NSNumber *validPasswordResult) {
        NSLog(@"validPassword signal: %@", validPasswordResult);
        NSInteger result = [validPasswordResult intValue];
        switch (result) {
            case TRZValidPasswordResultNone: {
                [UIView animateWithDuration:0.3 animations:^{
                    self.passwordResultView.alpha = 0.0;
                    self.passwordResultView.resultMessage.text = @"";
                    self.passwordResultView.resultIcon.image = nil;
                }];
                break;
            }
            case TRZValidPasswordResultShort: {
                [UIView animateWithDuration:0.1 animations:^{self.passwordResultView.alpha = 0.0;} completion:^(BOOL finished){
                    self.passwordResultView.resultMessage.text = [NSString stringWithFormat:@"at least %ld charactors.", (long)TRZPasswordLengthMin];
                    self.passwordResultView.resultIcon.image = [UIImage imageNamed:@"ResultWarning"];
                    [UIView animateWithDuration:0.3 animations:^{self.passwordResultView.alpha = 1.0;}];
                }];
                break;
            }
            case TRZValidPasswordResultNotSame: {
                [UIView animateWithDuration:0.1 animations:^{self.passwordResultView.alpha = 0.0;} completion:^(BOOL finished){
                    self.passwordResultView.resultMessage.text = @"Input same string for comfirm field.";
                    self.passwordResultView.resultIcon.image = [UIImage imageNamed:@"ResultWarning"];
                    [UIView animateWithDuration:0.3 animations:^{self.passwordResultView.alpha = 1.0;}];
                }];
                break;
            }
            case TRZValidPasswordResultValid: {
                [UIView animateWithDuration:0.1 animations:^{self.passwordResultView.alpha = 0.0;} completion:^(BOOL finished){
                    self.passwordResultView.resultMessage.text = @"OK!";
                    self.passwordResultView.resultIcon.image = [UIImage imageNamed:@"ResultOK"];
                    [UIView animateWithDuration:0.3 animations:^{self.passwordResultView.alpha = 1.0;}];
                }];
                break;
            }
            case TRZValidPasswordResultOver: {
                [UIView animateWithDuration:0.1 animations:^{ self.passwordResultView.alpha = 0.0;} completion:^(BOOL finished){
                    self.passwordResultView.resultMessage.text = [NSString stringWithFormat:@"max %ld charactors.", (long)TRZPasswordLengthMax];
                    self.passwordResultView.resultIcon.image = [UIImage imageNamed:@"ResultWarning"];
                    [UIView animateWithDuration:0.3 animations:^{self.passwordResultView.alpha = 1.0;}];
                }];
                break;
            }
            default: {
                break;
            }
        }
    }];
    
    // Done button enable condition
    RAC(self.doneButton,enabled) = [RACSignal
                                    combineLatest:@[validUserNameLength, validEmailFormat, validPasswordConfirm]
                                    reduce:^(NSNumber *validUserName, NSNumber *validEmail, NSNumber *validPassword) {
                                        NSLog(@"%@, %@, %@", validUserName, validEmail, validPassword);
                                        return @([validUserName intValue] == TRZValidLenghtResultValid
                                        && [validEmail intValue] == TRZValidFormatResultValid
                                        && [validPassword intValue] == TRZValidPasswordResultValid);
                                  }];
    
    // Done button pressed
    RACSignal *doneButtonPressed = [self.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    [doneButtonPressed subscribeNext:^(id sender) {
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

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view;
    switch (section) {
        case 0:
            view = self.userNameResultView;
            break;
        case 1:
            view = self.emailResultView;
            break;
        case 2:
            view = self.passwordResultView;
            break;
        default:
            break;
    }
    return view;
}

@end
