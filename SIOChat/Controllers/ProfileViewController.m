//
//  ProfileViewController.m
//  SIOChat
//
//  Created by YuheiMiyazato on 3/15/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#import "ProfileViewController.h"
#import "Param.h"

@interface ProfileViewController ()
@end

@implementation ProfileViewController

#pragma mark - overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nicknameLabel.delegate = self;
    self.nicknameLabel.text = [Lockbox stringForKey:kOwnNicknameKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - own callbacks

- (IBAction)doneBtnTapped:(id)sender {
    
    NSString *inputString = self.nicknameLabel.text;
    if(!inputString){
        [UIAlertView bk_alertViewWithTitle:@"no nickname" message:@"Please set your nickname."];
        return;
    }
    else if([inputString rangeOfString:kWsDataSeparater].location == NSNotFound){
        [Lockbox setString:inputString forKey:kOwnNicknameKey];
    }else{
        [UIAlertView bk_alertViewWithTitle:@"Sorry"
                                   message:[NSString stringWithFormat:@"You cannot use a character \"%@\" ", kWsDataSeparater]];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:self.dismissCompletion];
}

- (IBAction)candelBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
