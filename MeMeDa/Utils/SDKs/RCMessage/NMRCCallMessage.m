//
//  NMRCCallMessage.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/23/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMRCCallMessage.h"
#import <NIMSDK/NIMSDK.h>


@implementation NMRCCallMessage

-(NSString *)wId{
    if (!_wId) {
        _wId = [NIMSDK sharedSDK].loginManager.currentAccount;
    }
    return _wId;
}

-(NSString *)roomName{
    if (!_roomName) {
        _roomName = @"";
    }
    return _roomName;
}

-(NSData *)encode{
    if (!self.headImg) {
        self.headImg = @"";
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"roomName":self.roomName, @"nickname":self.nickname, @"headImg":self.headImg, @"id":self.uId, @"wId":self.wId, @"trId":self.trId, @"code":self.code} options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.roomName = dic[@"roomName"];
    self.nickname = dic[@"nickname"];
    self.headImg = dic[@"headImg"];
    self.uId = [dic[@"id"] stringValue];
    self.wId = dic[@"wId"];
    self.trId = dic[@"trId"];
    self.code = dic[@"code"];
}

+(NSString *)getObjectName{
    return @"app:NMRCCallMessage";
}

+(RCMessagePersistent)persistentFlag{
//    return MessagePersistent_STATUS;
    return MessagePersistent_NONE;
}

-(NSString *)conversationDigest{
    return @"邀您会话";
}

@end
