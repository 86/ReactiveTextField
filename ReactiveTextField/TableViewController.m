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
                view.resultMessage.text = @"aaaaa";
                break;
            case 1:
                view.resultMessage.text = @"bbbbb";
                break;
            case 2:
                view.resultMessage.text = @"ccccc";
                break;
            default:
                break;
        }
    }
    return view;
}



@end
