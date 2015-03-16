//
//  ProfileViewController.m
//  SIOChat
//
//  Created by YuheiMiyazato on 3/15/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)doneBtnTapped:(id)sender {
    
    NSString *inputString = self.nicknameLabel.text;
    if(!inputString){
        [UIAlertView bk_alertViewWithTitle:@"no nickname" message:@"Please set your nickname."];
    }
    else if([inputString rangeOfString:kWsDataSeparater].location == NSNotFound){
        [UIAlertView bk_alertViewWithTitle:@"Sorry"
                                   message:[NSString stringWithFormat:@"You cannot use a character \"%@\" ", kWsDataSeparater]];
    }
    
    [Lockbox setString:inputString forKey:kOwnNicknameKey];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)candelBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
