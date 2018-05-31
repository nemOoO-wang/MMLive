
//
//  UserInfoVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "UserInfoVC.h"
#import "UserInfoPopMenuVC.h"
#import "UserInfoScrollBannerView.h"


@interface UserInfoVC ()
@property (weak, nonatomic) IBOutlet UserInfoScrollBannerView *bannerScrollViedw;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *coverView;
@property (weak, nonatomic) IBOutlet UIScrollView *guestScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerTopConstraint;

@end

@implementation UserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    NSArray *tmp = @[[UIImage imageNamed:@"gakki"],[UIImage imageNamed:@"gakki"],[UIImage imageNamed:@"gakki"],[UIImage imageNamed:@"gakki"],[UIImage imageNamed:@"gakki"],[UIImage imageNamed:@"gakki"]];
    [self addToScrollViewWithImgs:tmp];
    // vedio:
//    https://stackoverflow.com/questions/32368751/implementing-video-view-in-the-storyboard
    [self.bannerScrollViedw setImgArr:tmp];
    //request
    if (self.userId) {
        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/userDetail" andParam:@{@"userId":self.userId} andSuccess:^(id data) {
            
        }];
    }
}


// add img to scroll view
-(void)addToScrollViewWithImgs:(NSArray *)imgArr{
    if (!imgArr) {
        return;
    }
    for (int i = 0; i < imgArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:imgArr[i]];
        imgView.clipsToBounds = YES;
        imgView.layer.cornerRadius = 17.5;
        imgView.frame = CGRectMake(49*i+14, 0, 35, 35);
        [self.guestScrollView addSubview:imgView];
    }
    self.guestScrollView.contentSize = CGSizeMake(49*imgArr.count+14, 35);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"menu"]) {
        UserInfoPopMenuVC *vc = [segue destinationViewController];
        vc.coverView = self.coverView;
        [UIView animateWithDuration:0.5 animations:^{
            self.coverView.alpha = 0.5;
        }];
    }
}


@end
