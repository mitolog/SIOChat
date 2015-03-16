//
//  ChatDataModel.m
//  SIOChat
//
//  Created by YuheiMiyazato on 3/14/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#import "ChatDataModel.h"

@implementation ChatDataModel

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    self.messages = [@{} mutableCopy];
    
    /**
     *  Create message bubble images objects.
     *
     *  Be sure to create your bubble images one time and reuse them for good performance.
     *
     */
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor lightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    return self;
}


@end
