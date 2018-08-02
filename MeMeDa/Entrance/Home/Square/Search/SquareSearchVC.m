//
//  SquareSearchVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/8/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SquareSearchVC.h"
#import "SquareSearchChooseVC.h"
#import "SquareSearchGenderButton.h"
#import "SquareSearchHistoryCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "SearchTextField.h"
#import "NSMutableArray+NMReverse.h"
#import "MessageListTVC.h"


@interface SquareSearchVC ()<UICollectionViewDataSource, UICollectionViewDelegateLeftAlignedLayout, UICollectionViewDelegate>

@property (nonatomic,strong) UIVisualEffectView *coverView;
@property (nonatomic,assign) NSInteger genderBtnIndex;
@property (nonatomic,strong) NSArray *historyArr;

@property (weak, nonatomic) IBOutlet SquareSearchGenderButton *manBtn;
@property (weak, nonatomic) IBOutlet SquareSearchGenderButton *womenBtn;
@property (weak, nonatomic) IBOutlet SquareSearchGenderButton *allGenderBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet SearchTextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
//labels
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatWayLabel;
@property (weak, nonatomic) IBOutlet UILabel *onlineTimeLabel;

@end

@implementation SquareSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // init cover view
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.coverView = [[UIVisualEffectView alloc] initWithEffect:effect];
    self.coverView.frame = self.view.bounds;
    self.coverView.alpha = 0;
    [self.view addSubview:self.coverView];
    // init gender button
    self.allGenderBtn.on = YES;
    self.genderBtnIndex = 0;
    // init history
    [self refreshHistory];
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    [self.collectionView setCollectionViewLayout:layout];
    self.searchDic = [[NSMutableDictionary alloc] init];
    // init label dic
    self.labelDic = @{@"age":self.ageLabel, @"cityName":self.cityLabel, @"price":self.coinLabel, @"type":self.chatWayLabel, @"time":self.onlineTimeLabel};
}

-(void)viewDidAppear:(BOOL)animated{
    HittestView *hit = [[HittestView alloc] initInController:self];
    hit.views = @[self.searchBtn, self.searchTextField, self.quitBtn];
//    [HittestView hitInController:self with:@[self.searchBtn, self.searchTextField, self.quitBtn]];
}

-(void)refreshHistory{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Search History"] isKindOfClass:[NSArray class]]) {
        NSMutableArray *tmpArr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Search History"] mutableCopy];
        [tmpArr reverse];
        self.historyArr = [tmpArr copy];
        [self.collectionView reloadData];
    }else{
        self.historyArr = @[];
    }
}


# pragma mark - <UICollectionViewDataSource>
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SquareSearchHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"history" forIndexPath:indexPath];
    cell.textLabel.text = self.historyArr[indexPath.row];
      
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.historyArr.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

# pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    NSString *str = self.historyArr[indexPath.row];
    CGFloat width = [str boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:context].size.width;
    return CGSizeMake(width + 38, 46);
}

# pragma mark - <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.searchTextField.text = self.historyArr[indexPath.row];
}

# pragma mark - Click Gender
- (IBAction)clickGender:(id)sender {
    SquareSearchGenderButton *btn = sender;
    self.manBtn.on = NO;
    self.womenBtn.on = NO;
    self.allGenderBtn.on = NO;
    NSInteger tag = btn.tag;
    self.genderBtnIndex = tag;
    switch (tag) {
        case 0:
            self.manBtn.on = YES;
            self.searchDic[@"gender"] = @1;
            break;
        case 1:
            self.womenBtn.on = YES;
            self.searchDic[@"gender"] = @2;
            break;
        case 2:
            self.allGenderBtn.on = YES;
            [self.searchDic removeObjectForKey:@"gender"];
            break;
        default:
            break;
    }
}

# pragma mark - Click to Choose
- (IBAction)clickOld:(id)sender {
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (int i=23; i<50; i++) {
        [tmpArr addObject:[@(i) stringValue]];
    }
    [self performSegueWithIdentifier:@"choose" sender:@{@"dataArr":[tmpArr copy], @"key":@"age"}];
}


- (IBAction)clickCity:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:nil];
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSArray *provinceArr = dataDic[@"province"];
    NSArray *cityArr = provinceArr[0][@"city"];
    [self performSegueWithIdentifier:@"choose"
                              sender:@{@"dataArr":provinceArr,
                                       @"subDataArr":cityArr,
                                       @"key":@"cityName"}];
}


- (IBAction)clickCoin:(id)sender {
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (int i=0; i<1000; i+=200) {
        [tmpArr addObject:[@(i) stringValue]];
    }
    [self performSegueWithIdentifier:@"choose" sender:@{@"dataArr":[tmpArr copy], @"key":@"price"}];
}


- (IBAction)clickChatWay:(id)sender {
    NSArray *dataArr = @[@"视频聊天",@"语音聊天"];
    [self performSegueWithIdentifier:@"choose" sender:@{@"dataArr":dataArr, @"key":@"type"}];
}


- (IBAction)clickOnlineTime:(id)sender {
    NSArray *dataArr = @[@"一小时",@"二小时",@"三小时",@"四小时",@"五小时及以上"];
    [self performSegueWithIdentifier:@"choose" sender:@{@"dataArr":dataArr, @"key":@"time"}];
}


- (IBAction)clickQuit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)clickClearHistory:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"Search History"];
    [self refreshHistory];
}

- (IBAction)clickSearch:(id)sender {
    // Add to History
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Search History"]){
        NSMutableArray *tmpArr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Search History"]mutableCopy];
        NSString *searchStr = self.searchTextField.text;
        if ([tmpArr containsObject:searchStr]) {
            [tmpArr removeObject:searchStr];
        }
        [tmpArr addObject:self.searchTextField.text];
        [[NSUserDefaults standardUserDefaults] setObject:[tmpArr copy] forKey:@"Search History"];
    }else{
        NSArray *tmpArr = @[self.searchTextField.text];
        [[NSUserDefaults standardUserDefaults] setObject:tmpArr forKey:@"Search History"];
    }
    [self refreshHistory];
    [self performSegueWithIdentifier:@"result" sender:nil];
}


# pragma mark - segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.searchTextField resignFirstResponder];
    // menu
    if([segue.identifier isEqualToString:@"choose"]){
        // vc
        SquareSearchChooseVC *vc = segue.destinationViewController;
        vc.coverView = self.coverView;
        [UIView animateWithDuration:0.3 animations:^{
            self.coverView.alpha = 0.5;
        }];
        // set attr
        vc.dataArr = [sender objectForKey:@"dataArr"];
        vc.subDataArr = [sender objectForKey:@"subDataArr"];
        vc.siftKey = [sender objectForKey:@"key"];
        __weak typeof(self) weakSelf = self;
        vc.vc = weakSelf;
    }
    // result
    if ([segue.identifier isEqualToString:@"result"]) {
        // delete invalid key
        [self.searchDic removeObjectForKey:@"type"];
        [self.searchDic removeObjectForKey:@"time"];
        // next
        MessageListTVC *vc = segue.destinationViewController;
        vc.listType = MessageTypeSearch;
        NSMutableDictionary *dic = [@{@"nickname":self.searchTextField.text, @"page":@0, @"size":@20} mutableCopy];
        [dic addEntriesFromDictionary:[self.searchDic copy]];
        vc.searchDic = [dic copy];
        [vc setTitle:@"搜索结果"];
    }
}

@end
