//
//  ChatContentButton.h
//  MeMeDa
//
//  Created by 镓洲 王 on 6/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, ChaterType) {
    ChaterTypeMe,
    ChaterTypeFriend,
};


@interface ChatContentButton : UIButton

@property (nonatomic,strong) CAShapeLayer *maskLayer;
@property (nonatomic,assign) ChaterType chatType;

-(instancetype)initWithType:(ChaterType)type;

@end
