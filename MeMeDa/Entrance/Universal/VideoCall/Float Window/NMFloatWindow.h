//
//  NMFloatWindow.h
//  MeMeDa
//
//  Created by 镓洲 王 on 7/10/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NMFloatWindow : UIWindow

+(instancetype)keyFLoatWindow;


@property (nonatomic,assign) CGRect defaultSmallFrame;
@property (nonatomic,assign) BOOL fullScreen;

-(void)setFullScreenWithoutAni:(BOOL)fullScreen;
-(void)dismiss;
-(void)show;

// inner
@property (nonatomic,strong) UIPanGestureRecognizer *panGstr;
@property (nonatomic,strong) UITapGestureRecognizer *tapGstr;



@end
