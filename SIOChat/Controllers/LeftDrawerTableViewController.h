//
//  LeftDrawerTableViewController.h
//  SIOChat
//
//  Created by YuheiMiyazato on 3/16/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftDrawerTableViewController : UITableViewController
<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, assign) id delegate;
@end

@protocol LeftDrawerTableViewControllerDelegate <NSObject>
@optional

-(void)roomTapped:(NSString *)roomId;
-(void)profileTapped:(id)sender;
@end