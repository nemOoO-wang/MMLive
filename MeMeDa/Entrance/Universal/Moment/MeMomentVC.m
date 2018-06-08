//
//  MeMomentVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MeMomentVC.h"
#import "MeMommentCollectionCell.h"

#define PageSize @20


@interface MeMomentVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,assign) NSInteger imgCellWidth;
@property (nonatomic,assign) NSInteger cellWidth;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,strong) NSMutableArray *dataArr;


@end

@implementation MeMomentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellWidth = SCREEN_WIDTH-24;
    self.imgCellWidth = (self.cellWidth-66)/3;
    [self refreshMoment];
}

// refresh moment
-(void)refreshMoment{
    self.pageIndex = 0;
    NSDictionary *paramDic = @{@"page":[NSString stringWithFormat:@"%ld",self.pageIndex],
                               @"size":PageSize
                               };
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getFriendTrends" andParam:paramDic andSuccess:^(id data) {
        self.dataArr = [data[@"data"] mutableCopy];
        [self.collectionView reloadData];
    }];
}

# pragma mark - <UICollectionViewDataSource>
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MeMommentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.dataDic = self.dataArr[indexPath.row];
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
    // text height
    NSString *context = self.dataArr[indexPath.row][@"text"];
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    CGSize textSize = [context boundingRectWithSize:CGSizeMake(self.cellWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:drawContext].size;
    // img height
    NSInteger imgHeight = 0;
    NSString *jsonStr = self.dataArr[indexPath.row][@"imgs"];
    if (jsonStr) {
        NSArray *tArr = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        NSInteger imgRow = (tArr.count+2)/3;
        imgHeight = self.imgCellWidth * imgRow;
    }
    // video height
    NSInteger videoHeight = 0;
    NSString *tmpStr = self.dataArr[indexPath.row][@"vedioImg"];
    if ([tmpStr length]>0) {
        videoHeight = 150;
    }
    return CGSizeMake(self.cellWidth, textSize.height+130+imgHeight+videoHeight);
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

@end
