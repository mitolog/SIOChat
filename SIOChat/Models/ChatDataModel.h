//
//  ChatDataModel.h
//  SIOChat
//
//  Created by YuheiMiyazato on 3/14/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessages.h"

@interface ChatDataModel : NSObject

@property(nonatomic)NSArray *rooms;     // holds data like [parent's socketid(same as roomId), ...]
@property(nonatomic)NSMutableDictionary *messages;  // holds data like {parent's socketid : [JQMessage, ...], ...}
@property(nonatomic)JSQMessagesBubbleImage *outgoingBubbleImageData;
@property(nonatomic)JSQMessagesBubbleImage *incomingBubbleImageData;


@end
