//
//  RVBubbleButton.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/19/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RVBubbleButton : UIButton

@property (nonatomic,weak) UIViewController *supVC;
@property (nonatomic,strong) NSDictionary *userDic;

-(void)fire;

@end
