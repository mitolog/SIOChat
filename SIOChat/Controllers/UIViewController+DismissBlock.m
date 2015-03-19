//
//  UIViewController+DismissBlock.m
//  SIOChat
//
//  Created by YuheiMiyazato on 3/19/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#import "UIViewController+DismissBlock.h"

@implementation UIViewController (DismissBlock)

- (void)setCompletionBlock:(dispatch_block_t)completionBlock
{
    //_completionBlock = [completionBlock copy];
}

- (dispatch_block_t)completionBlock
{
    //_completionBlock = [completionBlock copy];
    return self.completionBlock;
}

- (void)dismissViewControllerAnimated:(BOOL)flag
{
    if(self.completionBlock){
        [self dismissViewControllerAnimated:flag completion:self.completionBlock];
        self.completionBlock = nil;
        return;
    }
    [self dismissViewControllerAnimated:flag completion:nil];
}

-(void)presentViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion
           dismissCompletion:(dispatch_block_t)dismissCompletion{
    self.completionBlock = dismissCompletion;
    [self presentViewController:viewController animated:animated completion:completion];
}
@end
