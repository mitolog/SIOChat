//
//  AppConsts.h
//  SIOChat
//
//  Created by YuheiMiyazato on 3/14/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#ifndef SIOChat_AppConsts_h
#define SIOChat_AppConsts_h

static NSString * const kWebSocketHostName = @"ws://ec2-user@ec2-54-65-59-13.ap-northeast-1.compute.amazonaws.com:3000";

static NSString * const kWsDataSeparater = @",";
static NSString * const kOwnIdKey = @"ownIdKey";
static NSString * const kOwnNicknameKey = @"ownNicknameKey";
static NSString * const kDefaultNickname = @"mitolog";

static NSString * const kRoomsObserveKey = @"chatData.rooms";
static NSString * const kRoomsUpdateContext = @"update";

typedef enum : NSUInteger {
    PairingAsParent,
    PairingAsChild
} PairingAsType;

#endif
