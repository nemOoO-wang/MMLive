//
//  SquareListVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/9/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SquareListVC.h"
#import "SquareListGirlsCell.h"
#import "NMFlowLayout.h"
#import <MJRefresh.h>


@interface SquareListVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger page;
@end

@implementation SquareListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // water fall
    NMFlowLayout *flow = [[NMFlowLayout alloc] init];
    [flow setItemHeightBlock:^CGFloat(CGFloat itemHeight, NSIndexPath *indexPath) {
        CGFloat width = SCREEN_WIDTH/2;
        if (indexPath.row == 1) {
            return width*1.2;
        }
        return width*1.5;
    }];
    [self.collectionView setCollectionViewLayout:flow];
    // request
    if ([self.title isEqualToString:@"热门列表"]) {
        // 热门
        NSDictionary *paramDic = @{@"type":@5};
        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:self.searchUrl andParam:paramDic andSuccess:^(id data) {
            
        }];
    }else{
        // 其他
        self.page = 0;
        // header
        MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        mjHeader.stateLabel.textColor = [UIColor whiteColor];
        mjHeader.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
        self.collectionView.mj_header = mjHeader;
        
        // footer
        MJRefreshAutoNormalFooter *mjFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(nextPageData)];
        mjFooter.stateLabel.textColor = [UIColor whiteColor];
        self.collectionView.mj_footer = mjFooter;
    }
}

-(void)refreshData{
    self.page = 0;
    NSDictionary *paramDic = @{@"page":@0,@"size":@20};
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:self.searchUrl andParam:paramDic andSuccess:^(id data) {
        [self.collectionView.mj_header endRefreshing];
    }];
}

-(void)nextPageData{
    NSDictionary *paramDic = @{@"page":@(++self.page),@"size":@20};
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:self.searchUrl andParam:paramDic andSuccess:^(id data) {
        [self.collectionView.mj_footer endRefreshing];
    }];
}

# pragma mark - <UICollectionViewDataSource>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SquareListGirlsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

# pragma mark - <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"userDetail" sender:nil];
}

@end
