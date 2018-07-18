//
//  MeMommentCollectionCell.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MeMommentCollectionCell.h"
#import "NMPicsBlowser.h"
#import "NMClickVideoView.h"
#import <UIImageView+WebCache.h>


@interface MeMommentCollectionCell()
// head
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *contextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contextFieldHeightConstraint;
// video
@property (nonatomic,strong) NSString *videoImgUrl;
@property (weak, nonatomic) IBOutlet UIImageView *videoPreviewImgView;
@property (weak, nonatomic) IBOutlet NMClickVideoView *clickVideoView;
// like btn
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

// 9 pics
@property (weak, nonatomic) IBOutlet NMPicsBlowser *pic1;
@property (weak, nonatomic) IBOutlet NMPicsBlowser *pic2;
@property (weak, nonatomic) IBOutlet NMPicsBlowser *pic3;
@property (weak, nonatomic) IBOutlet NMPicsBlowser *pic4;
@property (weak, nonatomic) IBOutlet NMPicsBlowser *pic5;
@property (weak, nonatomic) IBOutlet NMPicsBlowser *pic6;
@property (weak, nonatomic) IBOutlet NMPicsBlowser *pic7;
@property (weak, nonatomic) IBOutlet NMPicsBlowser *pic8;
@property (weak, nonatomic) IBOutlet NMPicsBlowser *pic9;

// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row1Ratio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row2Ratio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row3Ratio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row1HideRatio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row3HideRatio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row2HideRatio;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row12Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row23Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoWidth;

@end


@implementation MeMommentCollectionCell

- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    // name
    self.nameLabel.text = dataDic[@"userId"][@"nickname"];
    // head
    NSString *head = dataDic[@"userId"][@"headImg"];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:head]];
    // img
    NSString *jsonStr = dataDic[@"imgs"];
    if (jsonStr) {
        self.imgArr = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    }
    // context
    self.context = self.dataDic[@"text"];
    // video
    self.videoImgUrl = self.dataDic[@"vedioImg"];
    [self.videoPreviewImgView sd_setImageWithURL:[NSURL URLWithString:self.videoImgUrl]];
    self.clickVideoView.videoUrl = [NSURL URLWithString:self.dataDic[@"video"]];
    // like
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    NSInteger myId = [userDic[@"id"] integerValue];
    NSArray *likedArr = dataDic[@"likeUsers"];
    [likedArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"id"] integerValue] == myId) {
            [self.likeBtn setSelected:YES];
        }
    }];
    // clear views
    [self updateType];
}

-(void)setContext:(NSString *)context{
    _context = context;
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    CGSize textSize = [context boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:drawContext].size;
    self.contextFieldHeightConstraint.constant = textSize.height;
    self.contextField.text = context;
}

-(void)setImgArr:(NSArray<NSString *> *)imgArr{
    _imgArr = imgArr;
    [imgArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            [self.pic1 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                [obj setUpWith:imgArr and:idx];
            } delete:nil];
        }else if (idx == 1){
            [self.pic2 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                [obj setUpWith:imgArr and:idx];
            } delete:nil];
        }else if (idx == 2){
            [self.pic3 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                [obj setUpWith:imgArr and:idx];
            } delete:nil];
        }else if (idx == 3){
            [self.pic4 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                [obj setUpWith:imgArr and:idx];
            } delete:nil];
        }else if (idx == 4){
            [self.pic5 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                [obj setUpWith:imgArr and:idx];
            } delete:nil];
        }else if (idx == 5){
            [self.pic6 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                [obj setUpWith:imgArr and:idx];
            } delete:nil];
        }else if (idx == 6){
            [self.pic7 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                [obj setUpWith:imgArr and:idx];
            } delete:nil];
        }else if (idx == 7){
            [self.pic8 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                [obj setUpWith:imgArr and:idx];
            } delete:nil];
        }else if (idx == 8){
            [self.pic9 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                [obj setUpWith:imgArr and:idx];
            } delete:nil];
        }
    }];
}

-(void)prepareForReuse{
    [self clearImgs];    
}

-(void)clearImgs{
    [self.pic1 clearSetting];
    [self.pic2 clearSetting];
    [self.pic3 clearSetting];
    [self.pic4 clearSetting];
    [self.pic5 clearSetting];
    [self.pic6 clearSetting];
    [self.pic7 clearSetting];
    [self.pic8 clearSetting];
    [self.pic9 clearSetting];
}
-(void)updateType{
    // hide img
    if (!self.imgArr || self.imgArr.count == 0 ) {
        self.row1Ratio.priority = 800;
        self.row1HideRatio.priority = 900;
        self.row2Ratio.priority = 800;
        self.row2HideRatio.priority = 900;
        self.row3Ratio.priority = 800;
        self.row3HideRatio.priority = 900;
        self.row12Height.constant = 0;
        self.row23Height.constant = 0;
        self.videoHeight.constant = 0;
    }else if (self.imgArr.count < 4){
        self.row1Ratio.priority = 900;
        self.row1HideRatio.priority = 800;
        self.row2Ratio.priority = 800;
        self.row2HideRatio.priority = 900;
        self.row3Ratio.priority = 800;
        self.row3HideRatio.priority = 900;
        self.row12Height.constant = 0;
        self.row23Height.constant = 0;
        self.videoHeight.constant = 0;
    }else if (self.imgArr.count < 7){
        self.row1Ratio.priority = 900;
        self.row1HideRatio.priority = 800;
        self.row2Ratio.priority = 900;
        self.row2HideRatio.priority = 800;
        self.row3Ratio.priority = 800;
        self.row3HideRatio.priority = 900;
        self.row12Height.constant = 13;
        self.row23Height.constant = 0;
        self.videoHeight.constant = 0;
    }else{
        // 3
        self.row1Ratio.priority = 900;
        self.row1HideRatio.priority = 800;
        self.row2Ratio.priority = 900;
        self.row2HideRatio.priority = 800;
        self.row3Ratio.priority = 900;
        self.row3HideRatio.priority = 800;
        self.row12Height.constant = 13;
        self.row23Height.constant = 13;
        self.videoHeight.constant = 0;
    }
    if ([self.videoImgUrl length]>0) {
        self.row1Ratio.priority = 800;
        self.row1HideRatio.priority = 900;
        self.row2Ratio.priority = 800;
        self.row2HideRatio.priority = 900;
        self.row3Ratio.priority = 800;
        self.row3HideRatio.priority = 900;
        self.row12Height.constant = 0;
        self.row23Height.constant = 0;
        self.videoHeight.constant = 150;
    }
}

-(void)drawRect:(CGRect)rect{
    [self.contextField setTextContainerInset:UIEdgeInsetsZero];
    [super drawRect:rect];
}
- (IBAction)clickLike:(id)sender {
    NSLog(@"%ld",[self.dataDic[@"id"] integerValue]);
    NSDictionary *paramDic = @{@"treId":self.dataDic[@"id"]};
    if (![sender isSelected]) {
        [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/likeTrends" andParam:paramDic andSuccess:^(id data) {
            [sender setSelected:YES];
        }];
    }else{
        [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/disLikeTrends" andParam:paramDic andSuccess:^(id data) {
            [sender setSelected:NO];
        }];
    }
}

@end
