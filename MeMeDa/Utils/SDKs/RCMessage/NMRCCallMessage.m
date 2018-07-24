//
//  NMRCCallMessage.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/23/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMRCCallMessage.h"

@implementation NMRCCallMessage

-(NSData *)encode{
    if (!self.headImg) {
        self.headImg = @"";
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"roomName":self.roomName, @"nickname":self.nickname, @"headImg":self.headImg, @"id":self.uId} options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.roomName = dic[@"roomName"];
    self.nickname = dic[@"nickname"];
    self.headImg = dic[@"headImg"];
    self.uId = [dic[@"id"] stringValue];
}

+(NSString *)getObjectName{
    return @"NMRCCallMessage";
}

+(RCMessagePersistent)persistentFlag{
//    return MessagePersistent_STATUS;
    return MessagePersistent_NONE;
}

-(NSString *)conversationDigest{
    return @"邀您会话";
}

@end
