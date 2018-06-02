//
//  MyFollowVC.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NMFollowerType) {
    NMFollowerTypeFollower,
    NMFollowerTypeMyFollow,
};

@interface MyFollowVC : UIViewController

@property (nonatomic,assign) NMFollowerType type;

@end
