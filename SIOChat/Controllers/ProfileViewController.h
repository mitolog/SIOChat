//
//  ProfileViewController.h
//  SIOChat
//
//  Created by YuheiMiyazato on 3/15/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nicknameLabel;
@property (nonatomic, copy) dispatch_block_t dismissCompletion;
@end
