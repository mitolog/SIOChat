//
//  ChatViewController.h
//  SIOChat
//
//  Created by YuheiMiyazato on 3/6/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h>

@interface ChatViewController : JSQMessagesViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *joinBtn;
- (NSArray *)rooms;
@end

