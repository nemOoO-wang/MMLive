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
#import "MeThemeVC.h"


@interface SquareVC ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *onlineBtn;
@property (weak, nonatomic) IBOutlet UIView *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *momentBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionVIew;
@property (nonatomic,strong) NSArray *urlTupleArr;

@property (nonatomic,strong) NSArray *partyArr;

@property (nonatomic,strong) NSArray *listDataArr;


@end

@implementation SquareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *uDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    // 男用户不显示认证
    NSString *replaceStr = ([uDic[@"gender"] integerValue] == 1)? @"素人列表": @"男用户列表";
    // init tuple
    self.urlTupleArr = @[@[@"关注列表",@"/chat/user/meFollowList"],
//                             @"关注列表",@"/chat/user/getRecommend"],
                         @[@"主题活动",@"/chat/user/getActivityList"],
                         @[@"热门列表",@"/chat/statistical/getlist"],
                         @[replaceStr,@"/chat/user/vegetarian"],
                         @[@"推荐列表",@"/chat/user/getRecommandList"]];
    // 在线状态
    if([uDic[@"imState"] integerValue] == 1){
        // 在线
        [self.onlineBtn setSelected:NO];
        [self clickOnline:nil];
    }else{
        [self.onlineBtn setSelected:YES];
    }
    self.navigationController.delegate = self;
    // 主题活动
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getActivityList" andParam:@{@"page":@0, @"size":@10} andSuccess:^(id data) {
        self.partyArr = data[@"data"][@"content"];
        NSMutableArray *mArr = [self.partyArr mutableCopy];
        NSInteger count = self.partyArr.count;
        while ((count--) > 6) {
            [mArr removeLastObject];
        }
        self.partyArr = [mArr copy];
        [self.collectionVIew reloadSections:[NSIndexSet indexSetWithIndex:1]];
    }];
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    navigationController.navigationItem.hidesBackButton = YES;
//    navigationController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    HittestView *coverView = [[HittestView alloc] initInController:self];
    coverView.views = @[self.momentBtn, self.searchBtn, self.onlineBtn];
    // 首页数据
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getAll" andParam:nil andSuccess:^(id data) {
        self.listDataArr = data[@"data"];
        [self.collectionVIew reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
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
        if (indexPath.section == 1) {
            [self performSegueWithIdentifier:@"party" sender:nil];
        }else{
            // list
            [self performSegueWithIdentifier:@"list" sender:self.urlTupleArr[indexPath.section]];
        }
    }else{
        if (indexPath.section == 1) {
            // 主题
            NSDictionary *dic = self.partyArr[indexPath.row-1];
            NSDictionary *searchDic = @{@"activityId":dic[@"id"]};
            SquareListVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"square list"];
            [vc setTitle:@"活动主播列表"];
            vc.searchUrl = @"/chat/user/indexSearch";
            vc.optSearchDic = searchDic;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            // user detail
            UserInfoVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"user detail"];
            NSDictionary *userDic = [self getUserAtIndexPath:indexPath];
            if (userDic) {
                vc.dataDic = userDic;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"用户不存在"];
            }
        }
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
        }else{
            [listCell.imgView setImage:[UIImage imageNamed:@"Nobody"]];
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
    if (section == 1) {
        return 1+self.partyArr.count;
    }
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
    if ([segue.identifier isEqualToString:@"party"]) {
        MeThemeVC *vc = segue.destinationViewController;
    }
}

@end
