//
//  BarrageMessage.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/24/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>


@interface BarrageMessage : RCMessageContent

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *danmu;
@property (nonatomic,strong) NSString *img;

@end
