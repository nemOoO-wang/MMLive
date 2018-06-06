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
#import "SquareListVC.h"
#import "HittestView.h"
#import "UserInfoVC.h"


@interface SquareVC ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *onlineBtn;
@property (weak, nonatomic) IBOutlet UIView *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *momentBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionVIew;
@property (nonatomic,strong) NSArray *urlTupleArr;


@property (nonatomic,strong) NSArray *listDataArr;


@end

@implementation SquareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // init tuple
    self.urlTupleArr = @[@[@"关注列表",@"/chat/user/getRecommend"],
                         @[@"活动主题",@"/chat/user/getActivityList"],
                         @[@"热门列表",@"/chat/statistical/getlist"],
                         @[@"素人列表",@"/chat/user/vegetarian"],
                         @[@"推荐列表",@"/chat/user/getRecommandList"]];
    // 首页数据
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getAll" andParam:nil andSuccess:^(id data) {
        self.listDataArr = data[@"data"];
        [self.collectionVIew reloadData];
    }];
    // 在线状态
    NSDictionary *uDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    if([uDic[@"imState"] integerValue] == 1){
        // 在线
        [self.onlineBtn setSelected:NO];
    }else{
        [self.onlineBtn setSelected:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    HittestView *coverView = [[HittestView alloc] initInController:self];
    coverView.views = @[self.momentBtn, self.searchBtn, self.onlineBtn];
}

-(NSDictionary *)getUserAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger dataIndex = 0;
    if (indexPath.section == 0) {
        dataIndex = 2;
    }else if (indexPath.section == 1){
        dataIndex = 3;
    }else if (indexPath.section == 2){
        dataIndex = 1;
    }else if (indexPath.section == 3){
        dataIndex = 6;
    }else{
        dataIndex = 3;
    }
    NSArray *users = self.listDataArr[dataIndex-1][@"user"];
    if (indexPath.row<=users.count) {
        return users[indexPath.row-1];
    }
    return nil;
}

# pragma mark - <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        // list
        [self performSegueWithIdentifier:@"list" sender:self.urlTupleArr[indexPath.section]];
    }else{
        // user detail
        UserInfoVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"user detail"];
        NSDictionary *userDic = [self getUserAtIndexPath:indexPath];
        if (userDic) {
            vc.userId = userDic[@"id"];
        }
        [self.navigationController pushViewController:vc animated:YES];
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
        
        NSDictionary *userDic = [self getUserAtIndexPath:indexPath];
        if (userDic) {
            NSString *url = @"";
            NSArray *imgArr;
            if ([userDic objectForKey:@"imgs"]) {
                NSData *jsonData = [userDic[@"imgs"] dataUsingEncoding:NSUTF8StringEncoding];
                imgArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                if ([imgArr count]>0) {
                    url = imgArr[0];
                }
            }
            [listCell.imgView sd_setImageWithURL:[NSURL URLWithString:url]];
        }
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
    BOOL offline = !self.onlineBtn.selected;
    NSNumber *onNum = offline? @2: @1;
    [SVProgressHUD show];
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/editOnlineState" andParam:@{@"onlineState":onNum} andSuccess:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"更改状态成功"];
        self.onlineBtn.selected = offline;
    }];
    // update DB
    NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"] mutableCopy];
    userDic[@"imState"] = onNum;
    [[NSUserDefaults standardUserDefaults] setObject:[userDic copy] forKey:@"UserData"];
}

# pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"list"]) {
        SquareListVC *vc = segue.destinationViewController;
        [vc setTitle:sender[0]];
        vc.searchUrl = sender[1];
    }
}

@end
