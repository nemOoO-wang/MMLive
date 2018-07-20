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
#import "UserInfoVC.h"


@interface SquareListVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation SquareListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // water fall
    NMFlowLayout *flow = [[NMFlowLayout alloc] init];
    [flow setItemHeightBlock:^CGFloat(CGFloat itemHeight, NSIndexPath *indexPath) {
        CGFloat width = (SCREEN_WIDTH-15)/2;
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
            self.dataArr = data[@"data"];
            [self.collectionView reloadData];
        }];
    }else if ([self.title isEqualToString:@"活动主题"]){
        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:self.searchUrl andParam:self.optSearchDic andSuccess:^(id data) {
            self.dataArr = data[@"data"][@"content"];
            [self.collectionView reloadData];
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
        
        // refresh
        [self refreshData];
    }
}

-(void)refreshData{
    self.page = 0;
    NSDictionary *paramDic = @{@"page":@0,@"size":@20};
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:self.searchUrl andParam:paramDic andSuccess:^(id data) {
        if ([self.title isEqualToString:@"素人列表"]) {
            self.dataArr = data[@"data"][@"content"];
        }else{
            self.dataArr = data[@"data"];
        }
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
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
    if ([self.title isEqualToString:@"热门列表"]) {
        cell.uDic = self.dataArr[indexPath.row][@"user"];
    }else{
        cell.uDic = self.dataArr[indexPath.row];
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

# pragma mark - <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UserInfoVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"user detail"];
    if ([self.title isEqualToString:@"热门列表"]) {
        vc.dataDic = self.dataArr[indexPath.row][@"user"];
    }else{
        vc.dataDic = self.dataArr[indexPath.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
