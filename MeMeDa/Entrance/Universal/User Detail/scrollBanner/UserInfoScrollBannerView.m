//
//  UserInfoScrollBannerView.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UserInfoScrollBannerView.h"
#import <UIImageView+WebCache.h>
#import <AVKit/AVKit.h>
#import "UIWindow+NMCurrent.h"


@interface UserInfoScrollBannerView()<UIScrollViewDelegate>
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UIPageControl *pageControl;
@end

@implementation UserInfoScrollBannerView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGSize size = self.bounds.size;
    NSInteger typecount = 0;
    // video
    if (self.videoImgUrlStr || self.videoUrlStr) {
        typecount++;
    }
    // imgs
    for (int i = 0; i<self.imgArr.count+typecount; i++) {
        if (typecount>0) {
            if (i==0) {
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.frame = CGRectMake(size.width*i, 0, size.width, size.height);
                [self.scrollView addSubview:imgView];
                [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[0]]];
            }
            if (i==1) {
                // video view
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(size.width*i, 0, size.width, size.height);
                [self.scrollView addSubview:btn];
                [btn sd_setImageWithURL:[NSURL URLWithString:self.videoImgUrlStr] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
            }
            if (i>1) {
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.frame = CGRectMake(size.width*i, 0, size.width, size.height);
                [self.scrollView addSubview:imgView];
                [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[i-1]]];
            }
        }else{
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.frame = CGRectMake(size.width*i, 0, size.width, size.height);
            [self.scrollView addSubview:imgView];
            [imgView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[i]]];
        }
    }
    self.scrollView.contentSize = CGSizeMake(size.width*(self.imgArr.count+typecount), 0);
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.imgArr.count+typecount;
}

-(void)playVideo{
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:self.videoUrlStr]];
    AVPlayerViewController *con = [[AVPlayerViewController alloc] init];
    [con setPlayer:player];
    con.showsPlaybackControls = YES;
    [[[[UIApplication sharedApplication] keyWindow] getCurrentViewController] presentViewController:con animated:YES completion:^{
        
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.bounds.size.width;
    self.pageControl.currentPage = index;
}

@end
