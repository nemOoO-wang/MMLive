//
//  RVBubbleButton.m
//  MeMeDa
//
//  Created by 镓洲 王 on 7/19/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "RVBubbleButton.h"
#import "StartCallVC.h"

#define ButtonSize 70
#define BiasWidth 400

@implementation RVBubbleButton
- (void)setUserDic:(NSDictionary *)userDic{
    _userDic = userDic;
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:userDic[@"headImg"]]];
    [self sd_setImageWithURL:[NSURL URLWithString:userDic[@"headImg"]] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(startCall) forControlEvents:UIControlEventTouchUpInside];
    self.enabled = YES;
    self.userInteractionEnabled = YES;
}

-(void)startCall{
    //拨打电话
    if ([self.userDic[@"anchorState"] integerValue] != 2) {
        [SVProgressHUD showWithStatus:@"主播未认证"];
    }else{
        StartCallVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"start call"];
        vc.usrDic = self.userDic;
        [self.supVC presentViewController:vc animated:YES completion:nil];
    }
    
}

# pragma mark - animation
-(void)fire{
    // layoutview
    // img mode
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.frame = CGRectMake(20, 20, ButtonSize, ButtonSize);
    // corner
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.bounds.size.height/2;
//    // fix position
//    CGSize containerSize = self.superview.bounds.size;
//    CGFloat startY = containerSize.height + ButtonSize/2;
//    CGFloat deltaWidth = ButtonSize + 100;
//    CGFloat starX = arc4random_uniform(containerSize.width-deltaWidth)+deltaWidth/2;
//    CGFloat bias = arc4random_uniform(BiasWidth);
//    bias -= BiasWidth/2;
//    self.center = CGPointMake(starX, startY);
//    // fire
//    [UIView animateWithDuration:4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        CGFloat edgeX = starX + bias;
//        if (edgeX < ButtonSize/2) {
//            edgeX = ButtonSize/2;
//        }
//        if (edgeX > containerSize.width-ButtonSize/2) {
//            edgeX = containerSize.width-ButtonSize/2;
//        }
//        self.center = CGPointMake(edgeX, -ButtonSize);
//        self.alpha = 0.4;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    // fix position
    CGSize containerSize = self.superview.bounds.size;
    CGFloat delta = ButtonSize + 50;
    CGFloat y = arc4random_uniform(containerSize.height - delta) + delta/2;
    CGFloat x = arc4random_uniform(containerSize.width-delta)+delta/2;
    self.center = CGPointMake(x, y);
    // sub button
    UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.subBtn = subBtn;
    subBtn.frame = self.frame;
    [subBtn addTarget:self action:@selector(startCall) forControlEvents:UIControlEventTouchUpInside];
    [self.superview addSubview:self.subBtn];
    // pre setting
    self.alpha = 0;
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.3, 0.3);
    transform = CGAffineTransformRotate(transform, M_PI_4);
    self.transform = transform;
    // fire
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.4 delay:1.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alpha = 0;
        self.transform = transform;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.subBtn removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

@end
