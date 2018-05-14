//
//  UserInfoScrollBannerView.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UserInfoScrollBannerView.h"


@interface UserInfoScrollBannerView()<UIScrollViewDelegate>
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UIPageControl *pageControl;
@end

@implementation UserInfoScrollBannerView
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGSize size = self.bounds.size;
    for (int i = 0; i<self.imgArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:self.imgArr[i]];
        imgView.frame = CGRectMake(size.width*i, 0, size.width, size.height);
        [self.scrollView addSubview:imgView];
    }
    self.scrollView.contentSize = CGSizeMake(size.width*self.imgArr.count, 0);
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.imgArr.count;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.bounds.size.width;
    self.pageControl.currentPage = index;
}

@end
