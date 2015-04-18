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

#import <ReactiveCocoa/ReactiveCocoa.h>

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
    
    // User name validation
    RACSignal *validUsernamelengthMin = [self.userNameField.rac_textSignal
                                         map:^id(NSString *userName) {
                                             return @([userName length] >= 3);
                                         }];
    RACSignal *validUsernameLengthMax = [self.userNameField.rac_textSignal
                                         map:^id(NSString *userName) {
                                             return @([userName length] <= 8);
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
    
    UINib *nib = [UINib nibWithNibName:@"TRZVaridationResultView" bundle:nil];
    TRZValidationResultView *view;
    if (nib) {
        view = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
        switch (section) {
            case 0:
                self.userNameResultView = view;
                self.userNameResultView.resultMessage.text = @"user name message";
                break;
            case 1:
                self.emailResultView = view;
                self.emailResultView.resultMessage.text = @"email message";
                break;
            case 2:
                self.passwordResultView = view;
                self.passwordResultView.resultMessage.text = @"password message";
                break;
            default:
                break;
        }
    }
    return view;
}



@end
