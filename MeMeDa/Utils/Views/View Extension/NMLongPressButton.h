//
//  NMLongPressButton.h
//  MeMeDa
//
//  Created by 镓洲 王 on 6/11/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NMLongPressDelegate
@optional
-(void)longPress:(UIButton *)button;
@end


@interface NMLongPressButton : UIButton

@property (nonatomic,weak) id<NMLongPressDelegate> nm_Delegate;

@end
