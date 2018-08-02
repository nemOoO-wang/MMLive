//
//  MeThemeVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MeThemeVC.h"
#import "MeMommentCollectionCell.h"
#import "SquareListVC.h"
#import <MJRefresh.h>


@interface MeThemeVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSString *partyId;
@property (nonatomic,assign) NSInteger page;
@end

@implementation MeThemeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reFreshData];
    // mj
    [self.collectionView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reFreshData];
    }]];
    [self.collectionView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getActivityList" andParam:@{@"page":@(++self.page), @"size":@10} andSuccess:^(id data) {
            NSArray *content = data[@"data"][@"content"];
            if (content.count<=0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                NSMutableArray *tmpArr = [self.dataArr mutableCopy];
                [tmpArr addObjectsFromArray:content];
                self.dataArr = [tmpArr copy];
                [self.collectionView reloadData];
            }
        }];
    }]];
}

-(void)reFreshData{
    self.page = 0;
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getActivityList" andParam:@{@"page":@0, @"size":@10} andSuccess:^(id data) {
        self.dataArr = data[@"data"][@"content"];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer resetNoMoreData];
    }];
    NSDictionary *dic = MDUserDic;
    self.partyId = [dic[@"activityId"] stringValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

# pragma mark - delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (MDIsAnchor) {
        NSDictionary *dic = self.dataArr[indexPath.row];
        NSString *selectedId = [dic[@"id"] stringValue];
        if ([selectedId isEqualToString:self.partyId]) {
            [SVProgressHUD showInfoWithStatus:@"已经参加过了哦"];
        }else{
            [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/activity/joinActivity" andParam:@{@"id":selectedId} andSuccess:^(id data) {
                [SVProgressHUD showInfoWithStatus:@"参加成功"];
                NSMutableDictionary *mDic = [MDUserDic mutableCopy];
                [mDic setObject:dic[@"id"] forKey:@"activityId"];
                [[NSUserDefaults standardUserDefaults] setObject:[mDic copy] forKey:@"UserData"];
                [self reFreshData];
            }];
        }
    }else{
        NSDictionary *dic = self.dataArr[indexPath.row];
        NSDictionary *searchDic = @{@"activityId":dic[@"id"]};
        [self performSegueWithIdentifier:@"show" sender:searchDic];
    }
}

# pragma mark - <UICollectionViewDataSource>
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MeMommentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.nameLabel.text = dic[@"title"];
    cell.contextField.text = dic[@"content"];
    if (MDIsAnchor) {
        if ([[dic[@"id"] stringValue] isEqualToString:self.partyId]) {
            [cell.infoLabel setTitle:@"已加入" forState:UIControlStateNormal];
        }else{
            [cell.infoLabel setTitle:@"加入活动" forState:UIControlStateNormal];
        }
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

# pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *context = @"活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍活动介绍";
    CGFloat cellWidth = SCREEN_WIDTH-24;
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    CGSize textSize = [context boundingRectWithSize:CGSizeMake(cellWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:drawContext].size;
    return CGSizeMake(cellWidth, textSize.height+130);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"show"]) {
        SquareListVC *vc = segue.destinationViewController;
        [vc setTitle:@"活动主播列表"];
        vc.searchUrl = @"/chat/user/indexSearch";
        vc.optSearchDic = sender;
    }
}

@end
