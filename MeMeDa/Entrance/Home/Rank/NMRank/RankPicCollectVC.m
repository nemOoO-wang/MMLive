//
//  RankPicCollectVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/10/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "RankPicCollectVC.h"
#import "RankPicCollectionCell.h"


@interface RankPicCollectVC ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *dailyBtn;
@property (weak, nonatomic) IBOutlet UIButton *weeklyBtn;

@end

@implementation RankPicCollectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.VCType == RankViewTypeTuHao) {
        self.collectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    }else{
        self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }
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

# pragma mark - click btn
- (IBAction)clickRank:(id)sender {
    UIButton *btn = sender;
    if (btn.tag == 0) {
        // daily
        self.dailyBtn.alpha = 1;
        self.weeklyBtn.alpha = 0.5;
    }else{
        // weekly
        self.dailyBtn.alpha = 0.5;
        self.weeklyBtn.alpha = 1;
    }
}

# pragma mark - <UICollectionViewDataSource>
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RankPicCollectionCell *cell;
    if (indexPath.row < 3) {
        switch (indexPath.row) {
            case 0:
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
                break;
            case 1:
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell2" forIndexPath:indexPath];
                break;
            case 2:
                cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell3" forIndexPath:indexPath];
                break;
            default:
                break;
        }
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell4" forIndexPath:indexPath];
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

# pragma mark - <UICollectionViewDelegateFlowLayout>
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/1.7);
    }else if (indexPath.row == 1 || indexPath.row == 2){
        CGFloat width = SCREEN_WIDTH/2;
        return CGSizeMake(width, width/1.12);
    }else{
        CGFloat width = SCREEN_WIDTH/3;
        return CGSizeMake(width, width/1.13);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    if (self.VCType == RankViewTypeTuHao) {
//        return UIEdgeInsetsMake(44, 0, 0, 0);
//    }
//    return UIEdgeInsetsMake(64, 0, 0, 0);
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.collectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
}

@end
