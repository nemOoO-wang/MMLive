//
//  HomeSNSVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/10/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "HomeSNSVC.h"
#import "RankPicCollectVC.h"


@interface HomeSNSVC ()<UIScrollViewDelegate>
// button position fix
@property (weak, nonatomic) IBOutlet UIButton *indexBtn0;
@property (weak, nonatomic) IBOutlet UIButton *indexBtn1;
@property (weak, nonatomic) IBOutlet UIButton *indexBtn2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineConstrant0;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineConstraint2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation HomeSNSVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // init VC
    if ([segue.identifier isEqualToString:@"tuhaoVC"]) {
        RankPicCollectVC *vc = segue.destinationViewController;
        vc.VCType = RankViewTypeTuHao;
    }else if ([segue.identifier isEqualToString:@"nvshengVC"]){
        RankPicCollectVC *vc = segue.destinationViewController;
        vc.VCType = RankViewTypeNvSheng;
    }
}

# pragma mark - VC Control
-(void)scrollToVCAtIndex:(NSInteger)index{
    if (index<0 || index>2) {
        return;
    }
    [self fixButtonToIndex:index];
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:YES];
}

-(void)fixButtonToIndex:(NSInteger)index{
    if (index<0 || index>2) {
        return;
    }
    if (index == 0) {
        // 0
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // btn
            self.indexBtn0.alpha = 1;
            self.indexBtn1.alpha = 0.5;
            self.indexBtn2.alpha = 0.5;
            // underline
            self.lineConstrant0.priority = 100;
            self.lineConstraint1.priority = 99;
            self.lineConstraint2.priority = 99;
            [self.view layoutIfNeeded];
        } completion:nil];
    }else if (index == 1){
        // 1
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // btn
            self.indexBtn0.alpha = 0.5;
            self.indexBtn1.alpha = 1;
            self.indexBtn2.alpha = 0.5;
            // underline
            self.lineConstrant0.priority = 99;
            self.lineConstraint1.priority = 100;
            self.lineConstraint2.priority = 99;
            [self.view layoutIfNeeded];
        } completion:nil];
    }else{
        // 2
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // btn
            self.indexBtn0.alpha = 0.5;
            self.indexBtn1.alpha = 0.5;
            self.indexBtn2.alpha = 1;
            // underline
            self.lineConstrant0.priority = 99;
            self.lineConstraint1.priority = 99;
            self.lineConstraint2.priority = 100;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (IBAction)clickIndexBtn:(id)sender {
    UIButton *btn = sender;
    [self scrollToVCAtIndex:btn.tag];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self fixButtonToIndex:scrollView.contentOffset.x/SCREEN_WIDTH];
}

@end
