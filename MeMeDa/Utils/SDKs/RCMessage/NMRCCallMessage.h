//
//  NMRCCallMessage.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/23/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface NMRCCallMessage : RCMessageContent

@property (nonatomic,strong) NSString *roomName;
@property (nonatomic,strong) NSString *nickname;
@property (nonatomic,strong) NSString *headImg;
@property (nonatomic,strong) NSString *uId;
// 网易云 id
@property (nonatomic,strong) NSString *wId;
@property (nonatomic,strong) NSString *trId;
@property (nonatomic,strong) NSString *code;

@end
