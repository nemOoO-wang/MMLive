//
//  MessageListTVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeSearch,
    MessageTypePeepMe,
    MessageTypeCallLog,
    MessageTypeRecall,
    MessageTypeReservation,
    MessageTypeFriendMsg,
    MessageTypeSysInfo,
    MessageTypeLahei,
};

@interface MessageListTVC : UITableViewController

@property (nonatomic,assign) MessageType listType;
@property (nonatomic,strong) NSDictionary *searchDic;
// paging
@property (nonatomic,assign) BOOL paging;
@property (nonatomic,assign) NSInteger page;
//@property (nonatomic,strong) NSString *url;

@end
