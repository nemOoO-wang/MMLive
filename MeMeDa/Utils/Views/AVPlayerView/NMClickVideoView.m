//
//  NMClickVideoView.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/5/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMClickVideoView.h"
#import "UIWindow+NMCurrent.h"
#import <AVKit/AVKit.h>


@implementation NMClickVideoView

-(void)didMoveToSuperview{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideo:)];
    [self addGestureRecognizer:tap];
}

-(void)showVideo:(UITapGestureRecognizer *)recognizer{
    NSLog(@"tap");
    if (self.videoUrl) {
        UIViewController *vc = [[[UIApplication sharedApplication]keyWindow] getCurrentViewController];
        AVPlayerViewController *playerCon = [[AVPlayerViewController alloc] init];
        playerCon.showsPlaybackControls = YES;
        AVPlayer *player = [AVPlayer playerWithURL:self.videoUrl];
        playerCon.player = player;
//        self.frame = playerCon.view.frame;
//        [self addSubview:playerCon.view];
        [vc presentViewController:playerCon animated:YES completion:^{
            
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
