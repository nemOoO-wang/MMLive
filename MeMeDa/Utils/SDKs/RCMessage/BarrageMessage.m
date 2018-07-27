//
//  BarrageMessage.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/24/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "BarrageMessage.h"

@implementation BarrageMessage

-(NSData *)encode{
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"name":self.name, @"danmu":self.danmu, @"img":self.img} options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}

-(void)decodeWithData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.name = dic[@"name"];
    self.img = dic[@"img"];
    self.danmu = dic[@"danmu"];
}

+(NSString *)getObjectName{
    return @"app:BarrageMessage";
}

+(RCMessagePersistent)persistentFlag{
    return MessagePersistent_ISPERSISTED;
}

@end
