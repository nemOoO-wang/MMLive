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


@interface MeThemeVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation MeThemeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getActivityList" andParam:@{@"page":@0, @"size":@10} andSuccess:^(id data) {
        self.dataArr = data[@"data"][@"content"];
        [self.collectionView reloadData];
    }];
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
    NSDictionary *dic = self.dataArr[indexPath.row];
    NSDictionary *searchDic = @{@"activityId":dic[@"id"]};
    [self performSegueWithIdentifier:@"show" sender:searchDic];
}

# pragma mark - <UICollectionViewDataSource>
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MeMommentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dic = self.dataArr[indexPath.row];
    cell.nameLabel.text = dic[@"title"];
    cell.contextField.text = dic[@"content"];
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
        [vc setTitle:@"活动主题"];
        vc.searchUrl = @"/chat/user/indexSearch";
        vc.optSearchDic = sender;
    }
}

@end
