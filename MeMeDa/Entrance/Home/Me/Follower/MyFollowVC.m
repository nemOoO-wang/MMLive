//
//  MyFollowVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MyFollowVC.h"


@interface MyFollowVC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underFollower;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *underFollowing;
@property (weak, nonatomic) IBOutlet UIButton *folowingBtn;
@property (weak, nonatomic) IBOutlet UIButton *followerBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger indexToken;
@end

@implementation MyFollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexToken = 0;
}

-(void)viewDidAppear:(BOOL)animated{
    [self scrollToType:self.type];
}

-(void)viewWillAppear:(BOOL)animated{
    [self scrollToTypeWithoutAni:self.type];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FollowerTVC *tvc = [segue destinationViewController];
    if (self.indexToken++ == 0) {
//        tvc.type = self.type;
        tvc.type = NMFollowerTypeMyFollow;
    }else{
//        NMFollowerType another = (self.type == NMFollowerTypeMyFollow)? NMFollowerTypeFollower: NMFollowerTypeMyFollow;
//        tvc.type = another;
        tvc.type = NMFollowerTypeFollower;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        [self fixSelectionTo:0];
    }else{
        [self fixSelectionTo:1];
    }
}

- (IBAction)clickFollowing:(id)sender {
    [self scrollToType:NMFollowerTypeMyFollow];
}

- (IBAction)clickFoller:(id)sender {
    [self scrollToType:NMFollowerTypeFollower];
}

-(void)scrollToType:(NMFollowerType)type{
    CGSize sSize = self.scrollView.bounds.size;
    if (type == NMFollowerTypeMyFollow) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, sSize.width, sSize.height) animated:YES];
        [self fixSelectionTo:0];
    }else{
        [self.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH, 0, sSize.width, sSize.height) animated:YES];
        [self fixSelectionTo:1];
    }
}

-(void)scrollToTypeWithoutAni:(NMFollowerType)type{
    CGSize sSize = self.scrollView.bounds.size;
    if (type == NMFollowerTypeMyFollow) {
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, sSize.width, sSize.height) animated:NO];
        [self fixSelectionTo:0];
    }else{
        [self.scrollView scrollRectToVisible:CGRectMake(SCREEN_WIDTH, 0, sSize.width, sSize.height) animated:NO];
        [self fixSelectionTo:1];
    }
}

-(void)fixSelectionTo:(NSInteger)index{
    switch (index) {
        case 0:
            self.underFollowing.priority = 900;
            self.underFollower.priority = 800;
            [self.folowingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.followerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            break;
            
        default:
            self.underFollowing.priority = 800;
            self.underFollower.priority = 900;
            [self.folowingBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.followerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
    }
}

@end
