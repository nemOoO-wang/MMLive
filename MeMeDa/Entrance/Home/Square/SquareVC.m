//
//  SquareVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/7/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SquareVC.h"
#import "SquareHeaderCarousel.h"
#import "SquareHeaderCell.h"
#import "SquareListCell.h"
#import "HittestView.h"


@interface SquareVC ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *onlineBtn;
@property (weak, nonatomic) IBOutlet UIView *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *momentBtn;

@end

@implementation SquareVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    HittestView *coverView = [[HittestView alloc] initInController:self];
    coverView.views = @[self.momentBtn, self.searchBtn, self.onlineBtn];
}

# pragma mark - <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        // list
        [self performSegueWithIdentifier:@"list" sender:nil];
    }else{
        // user detail
        [self performSegueWithIdentifier:@"userDetail" sender:nil];        
    }
}

# pragma mark - <UICollectionViewDataSource>
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SquareHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"header" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
                cell.type = SquareHeaderTypeGuanZhu;
                break;
            case 1:
                cell.type = SquareHeaderTypeHuoDong;
                break;
            case 2:
                cell.type = SquareHeaderTypeReMen;
                break;
            case 3:
                cell.type = SquareHeaderTypeShuRen;
                break;
            case 4:
                cell.type = SquareHeaderTypeTuJian;
                break;                
            default:
                break;
        }
        return cell;
    }else{
        SquareListCell *listCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"list" forIndexPath:indexPath];
        return listCell;
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"carousel" forIndexPath:indexPath];
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"NullHeader" forIndexPath:indexPath];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    // 1 header + 4 cell
    return 5;
}

# pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        // header
        return CGSizeMake(SCREEN_WIDTH, 34);
    }
    // list cell
    CGFloat frameWidth = (SCREEN_WIDTH-5)/2;
    return CGSizeMake(frameWidth, frameWidth/1.32);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section != 0) {
        return CGSizeZero;
    }
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/2.68);
}


# pragma mark - click
- (IBAction)clickOnline:(id)sender {
    BOOL on = !self.onlineBtn.selected;
    self.onlineBtn.selected = on;
}

@end
