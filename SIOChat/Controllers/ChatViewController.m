//
//  ChatViewController.m
//  SIOChat
//
//  Created by YuheiMiyazato on 3/6/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatDataModel.h"
#import "Param.h"
#import <SIOSocket/SIOSocket.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import <MMDrawerController/MMDrawerBarButtonItem.h>
#import "LeftDrawerTableViewController.h"
#import "UIViewController+DismissBlock.h"
#import "ProfileViewController.h"

@interface ChatViewController ()
<LeftDrawerTableViewControllerDelegate>
@property (nonatomic) ChatDataModel *chatData;
@property (nonatomic) SIOSocket *socket;
@property (nonatomic) NSString *currentRoom, *parentRoomId;
@property (nonatomic) NSMutableArray *joinedRooms;
@end

@implementation ChatViewController

#pragma mark - Overrides

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.senderId = [Lockbox stringForKey:kOwnIdKey];
    self.senderDisplayName = [Lockbox stringForKey:kOwnNicknameKey];
    
    self.chatData = [[ChatDataModel alloc] init];
    self.topContentAdditionalInset = 64.0;
    
    // Holds joined room id's (it's On-Memory )
    self.joinedRooms = [@[]mutableCopy];
    
    // Don't use avatar at this point
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    // An user has one own room(as parent) at least
    [self connectWs];
    
    LeftDrawerTableViewController *leftVc = (LeftDrawerTableViewController *)[self.mm_drawerController leftDrawerViewController];
    leftVc.delegate = self;
    
    // Let LeftDrawer observe rooms update
    [self addObserver:leftVc
           forKeyPath:kRoomsObserveKey
              options:NSKeyValueObservingOptionNew
              context:(__bridge void *)(kRoomsUpdateContext)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - own callbacks

-(IBAction)leftDrawerButtonPress:(id)sender
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)joinBtnTapped:(id)sender {
    
    Param *param = [Param MR_createEntity];
    param.isParent = @NO;
    param.message = @"init";
    param.nickname = [Lockbox stringForKey:kOwnNicknameKey];
    param.room = self.currentRoom;
    param.uuid = [Lockbox stringForKey:kOwnIdKey];
    
    [self.socket emit:@"init" args:@[[param paramStr]]];
}

#pragma mark - own methods

- (NSArray *)rooms
{
    return self.chatData.rooms;
}

-(void)setupLeftMenuButton
{
    MMDrawerBarButtonItem * leftDrawerButton =
    [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)postParam:(Param *)param needEmit:(BOOL)needEmit
{
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:param.uuid
                                             senderDisplayName:param.nickname
                                                          date:[NSDate date]
                                                          text:param.message];

    // Prepare empty messsage array if needed
    NSMutableArray *mesAry = self.chatData.messages[self.currentRoom];
    if(!mesAry){
        mesAry = [@[]mutableCopy];
        self.chatData.messages[self.currentRoom] = mesAry;
    }
    
    [self.chatData.messages[self.currentRoom] addObject:message];
    [self finishSendingMessageAnimated:YES];
    
    if(needEmit){
        [self.socket emit:@"post" args:@[[param paramStr]]];
    }
}

- (void)gotMessageFrom:(Param*)param
{
    if(!param) return;
    
    [self scrollToBottomAnimated:YES];

    JSQMessage *newMessage =
    [JSQMessage messageWithSenderId:param.uuid
                        displayName:param.nickname
                               text:param.message];
    [self.chatData.messages[param.room] addObject:newMessage];

    if([self.currentRoom isEqualToString:param.room]){
        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
        [self finishReceivingMessageAnimated:YES];
    }
}

- (void)connectWs
{
    // Close existing connection if needed
    if(self.socket){ [self.socket close];}
    
    [SIOSocket socketWithHost: kWebSocketHostName response: ^(SIOSocket *socket){
        
        self.socket = socket;
        
        __weak typeof(self) weakSelf = self;
        self.socket.onConnect = ^()
        {
            Param *param = [Param MR_createEntity];
            param.isParent = @YES;
            param.message = @"init";
            param.nickname = [Lockbox stringForKey:kOwnNicknameKey];
            param.room = nil;
            param.uuid = [Lockbox stringForKey:kOwnIdKey];
            
            // Create new room if no rooms there, otherwise just join there.
            [weakSelf.socket emit: @"init" args: @[[param paramStr]]];
        };
        
        [self.socket on: @"join" callback: ^(SIOParameterArray *args)
         {
             Param *param = [Param MR_createEntity];
             if(![param setWsArguments:args]){
                 // todo: error handling
             }
             
             param.message = [NSString stringWithFormat:@"%@ joined", param.nickname];
             
             BOOL isOwnRoom = ([self.senderId isEqualToString:param.uuid] && param.isParentValue) ? YES : NO;
             
             if(isOwnRoom){
                 self.parentRoomId = param.room;
                 self.currentRoom = param.room;
                 self.title = param.room;
             }
             
             [self.joinedRooms addObject:param.room];
             
             self.joinBtn.enabled = NO;
             
             // Execute in main thread
             dispatch_async(dispatch_get_main_queue(), ^{

                 if([self.senderId isEqualToString:param.uuid]){
                     [self postParam:param needEmit:NO];
                 }
                 // some others joined
                 else{
                     [self gotMessageFrom:param];
                 }
             });
         }];
        
        [self.socket on: @"update" callback: ^(SIOParameterArray *args)
         {
             Param *param = [Param MR_createEntity];
             if(![param setWsArguments:args]){
                 // todo: error handling
             }
             
             // Execute in main thread
             dispatch_async(dispatch_get_main_queue(), ^{
                 if([self.senderId isEqualToString:param.uuid]) return ;
                 [self gotMessageFrom:param];
             });
             
             // notify posted here
             NSLog(@"posted");
         }];
        
        [self.socket on: @"rooms" callback: ^(SIOParameterArray *args)
         {
             self.chatData.rooms = [args[0] allKeys];
             
             // notify posted here
             NSLog(@"room updated %@", self.chatData.rooms);
         }];
        
        [self.socket on: @"disappear" callback: ^(SIOParameterArray *args)
         {
             NSArray * params = [args[0]componentsSeparatedByString:kWsDataSeparater];
             NSString *message = params[0];
             NSString *room = params[1];

             // Execute in main thread
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self scrollToBottomAnimated:YES];
                 
                 JSQMessage *newMessage =
                 [JSQMessage messageWithSenderId:@"0"
                                     displayName:@"bot"
                                            text:message];
                 [self.chatData.messages[room] addObject:newMessage];
                 
                 if([self.currentRoom isEqualToString:room]){
                     [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
                     [self finishReceivingMessageAnimated:YES];
                 }
             });
                            
             // notify disappear here
             NSLog(@"disappear");
         }];
    }];
}

#pragma mark - LeftDrawerTableViewControllerDelegate

- (void)roomTapped:(NSString *)roomId
{
    if(!roomId || ![roomId isKindOfClass:[NSString class]] || roomId.length<=0) return;
    
    self.currentRoom = roomId;
    self.title = roomId;
    NSInteger joinedRoomIdx = Underscore.array(self.joinedRooms).indexOf(self.currentRoom);
    
    if(joinedRoomIdx == NSNotFound){
        self.joinBtn.enabled = YES;
    }else{
        self.joinBtn.enabled = NO;
    }
    
    [self.collectionView reloadData];
}

- (void)profileTapped:(id)sender
{
    NSString *prevNickname = [Lockbox stringForKey:kOwnNicknameKey];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    UINavigationController* profileNavCon = [storyBoard instantiateInitialViewController];
    ProfileViewController *pvc = (ProfileViewController*)[profileNavCon topViewController];
    pvc.dismissCompletion = ^{

        // Post to other nodes
        NSString *newNickname = [Lockbox stringForKey:kOwnNicknameKey];
        
        Param *param = [Param MR_createEntity];
        param.isParent = ([self.currentRoom isEqualToString:self.parentRoomId]) ? @YES : @NO;
        param.message = [NSString stringWithFormat:@"changed nickname from \"%@\" to \"%@\"",prevNickname ,newNickname];
        param.nickname = newNickname;
        param.room = self.currentRoom;
        param.uuid = self.senderId;
        
        AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSString *postFilePath = [NSString stringWithFormat:@"%@/%@",
                                  kHTTPHostName, kEmitFilePath];
        [manager POST:postFilePath
           parameters:@{@"param":[param paramStr]}
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             NSLog(@"posted");
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
         }];
        
    };
    [self presentViewController:profileNavCon animated:YES completion:nil];
    
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    Param *param = [Param MR_createEntity];
    param.isParent = ([self.currentRoom isEqualToString:self.parentRoomId]) ? @YES : @NO;
    param.message = text;
    param.nickname = senderDisplayName;
    param.room = self.currentRoom;
    param.uuid = self.senderId;
    
    [self postParam:param needEmit:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    /* do nothing at this time */
}

#pragma mark - JSQMessages CollectionView DataSource
#pragma mark required

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView
       messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chatData.messages[self.currentRoom] objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.chatData.messages[self.currentRoom] objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.chatData.outgoingBubbleImageData;
    }
    
    return self.chatData.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
                    avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource
#pragma mark required
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.chatData.messages[self.currentRoom] count];
}

#pragma mark - Adjusting cell label heights
#pragma mark optional
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.chatData.messages[self.currentRoom] objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.chatData.messages[self.currentRoom] objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

@end
