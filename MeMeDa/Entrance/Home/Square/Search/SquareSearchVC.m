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


@interface SquareSearchVC ()<UICollectionViewDataSource, UICollectionViewDelegateLeftAlignedLayout>

@property (nonatomic,strong) UIVisualEffectView *coverView;
@property (nonatomic,assign) NSInteger genderBtnIndex;
@property (nonatomic,strong) NSArray *historyArr;


@property (weak, nonatomic) IBOutlet SquareSearchGenderButton *manBtn;
@property (weak, nonatomic) IBOutlet SquareSearchGenderButton *womenBtn;
@property (weak, nonatomic) IBOutlet SquareSearchGenderButton *allGenderBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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
    self.manBtn.on = YES;
    self.genderBtnIndex = 0;
    // init history
    self.historyArr = @[@"teststs", @"dfdfd", @"teststs",
                        @"dfdfd", @"teststs", @"dfdfd", @"teststs",
                        @"dfdfd", @"teststs", @"dfdfd", @"teststs", @"dfdfd"];
    UICollectionViewLeftAlignedLayout  *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
    [self.collectionView setCollectionViewLayout:layout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            break;
        case 1:
            self.womenBtn.on = YES;
            break;
        case 2:
            self.allGenderBtn.on = YES;
            break;
        default:
            break;
    }
}

# pragma mark - Click to Choose
- (IBAction)clickOld:(id)sender {
    NSArray *dataArr = @[@"sds",@"sds",@"sds",@"sds"];
    [self performSegueWithIdentifier:@"choose" sender:@{@"dataArr":dataArr}];
}

- (IBAction)clickCity:(id)sender {
    NSArray *dataArr = @[@"sds",@"sds",@"sds",@"sds"];
    [self performSegueWithIdentifier:@"choose" sender:@{@"dataArr":dataArr}];
}

- (IBAction)clickCoin:(id)sender {
    NSArray *dataArr = @[@"sds",@"sds",@"sds",@"sds"];
    [self performSegueWithIdentifier:@"choose" sender:@{@"dataArr":dataArr}];
}

- (IBAction)clickChatWay:(id)sender {
    NSArray *dataArr = @[@"sds",@"sds",@"sds",@"sds"];
    [self performSegueWithIdentifier:@"choose" sender:@{@"dataArr":dataArr, @"subDataArr": @[@"!!!!!!"]}];
}

- (IBAction)clickOnlineTime:(id)sender {
    NSArray *dataArr = @[@"sds",@"sds",@"sds",@"sds"];
    [self performSegueWithIdentifier:@"choose" sender:@{@"dataArr":dataArr}];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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
    }
}


- (IBAction)clickQuit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
