//
//  ChatTBCell.h
//  MeMeDa
//
//  Created by 镓洲 王 on 6/13/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTBCell : UITableViewCell

@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSDictionary *userDic;
@property (nonatomic,strong) NSData *voiceData;


@end
