//
//  LeftDrawerTableViewController.m
//  SIOChat
//
//  Created by YuheiMiyazato on 3/16/15.
//  Copyright (c) 2015 mitolab. All rights reserved.
//

#import "LeftDrawerTableViewController.h"
#import "ChatViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>

static NSInteger const kProfileSection = 0;
static NSInteger const kRoomsSection = 1;

@interface LeftDrawerTableViewController ()
@property(nonatomic)NSArray *sections, *rooms;
@property(nonatomic)NSString *currentRoom;
@end

@implementation LeftDrawerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sections = @[@"profile", @"rooms"];
    self.rooms = @[];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (!keyPath ||
        ![keyPath isEqualToString:kRoomsObserveKey]) return;
 
    NSString *contextMessgae = (__bridge NSString *)context;
    if([contextMessgae isEqualToString:kRoomsUpdateContext]){
        
        self.rooms = [(ChatViewController *)object rooms];
        [self.tableView reloadData];
    }
}


#pragma mark - Table view data source
#pragma mark required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rowCnt = 1;
    switch (section) {
        case kRoomsSection:
        {
            rowCnt = [self.rooms count];
            break;
        }
        default:
            break;
    }
    
    return rowCnt;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftDrawerCell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case kProfileSection:
        {
            cell.textLabel.text = @"Edit Profile";
            break;
        }
        case kRoomsSection:
        {
            cell.textLabel.text = self.rooms[indexPath.row];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark optional
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sections[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

#pragma mark - Table view delegate
#pragma mark optional
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case kProfileSection:
        {
            // close slider then pass delegate
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                if(self.delegate && [self.delegate respondsToSelector:@selector(profileTapped:)]){
                    [self.delegate performSelector:@selector(profileTapped:)
                                        withObject:nil];
                }
            }];
            
            break;
        }
        case kRoomsSection:
        {
            // remove chackmark for previous cell
            NSInteger prevIdx = Underscore.array(self.rooms).indexOf(self.currentRoom);
            if(prevIdx != NSNotFound){
                NSIndexPath *ip = [NSIndexPath indexPathForRow:prevIdx inSection:kRoomsSection];
                UITableViewCell *prevCell = [self.tableView cellForRowAtIndexPath:ip];
                [prevCell setAccessoryType:UITableViewCellAccessoryNone];
            }
            
            // add checkmark for current cell
            UITableViewCell *currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
            [currentCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
            self.currentRoom = currentCell.textLabel.text;
            
            // close slider then pass delegate
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                if(self.delegate && [self.delegate respondsToSelector:@selector(roomTapped:)]){
                    [self.delegate performSelector:@selector(roomTapped:)
                                                withObject:currentCell.textLabel.text]; // pass roomId
                }
            }];

            break;
        }
        default:
            break;
    }
}

@end
