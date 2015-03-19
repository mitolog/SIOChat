//
//  UIViewController+DismissBlock.h
//  SIOChat
//
//  Created by YuheiMiyazato on 3/19/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DismissBlock)
@property (nonatomic, copy) dispatch_block_t completionBlock;
- (void)dismissViewControllerAnimated:(BOOL)flag;
-(void)presentViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion
           dismissCompletion:(dispatch_block_t)dismissCompletion;
@end