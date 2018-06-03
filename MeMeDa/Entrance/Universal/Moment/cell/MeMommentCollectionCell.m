//
//  MeMommentCollectionCell.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MeMommentCollectionCell.h"
#import "NMPicsBlowser.h"


@interface MeMommentCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *contextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contextFieldHeightConstraint;
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

@end


@implementation MeMommentCollectionCell

-(void)setContext:(NSString *)context{
    _context = context;
    NSStringDrawingContext *drawContext = [[NSStringDrawingContext alloc] init];
    CGSize textSize = [context boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:drawContext].size;
    self.contextFieldHeightConstraint.constant = textSize.height;
}

-(void)setImgArr:(NSArray<UIImage *> *)imgArr{
    _imgArr = imgArr;
    [imgArr enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [self.pic1 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                obj.imgArr = imgArr;
            } delete:nil];
        }else if (idx == 1){
            [self.pic2 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                obj.imgArr = imgArr;
            } delete:nil];
        }else if (idx == 2){
            [self.pic3 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                obj.imgArr = imgArr;
            } delete:nil];
        }else if (idx == 3){
            [self.pic4 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                obj.imgArr = imgArr;
            } delete:nil];
        }else if (idx == 4){
            [self.pic5 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                obj.imgArr = imgArr;
            } delete:nil];
        }else if (idx == 5){
            [self.pic6 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                obj.imgArr = imgArr;
            } delete:nil];
        }else if (idx == 6){
            [self.pic7 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                obj.imgArr = imgArr;
            } delete:nil];
        }else if (idx == 7){
            [self.pic8 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                obj.imgArr = imgArr;
            } delete:nil];
        }else if (idx == 8){
            [self.pic9 setImg:imgArr[idx] withBrowser:^(NMPicsBlowser *obj) {
                obj.imgArr = imgArr;
            } delete:nil];
        }
    }];
}

-(void)drawRect:(CGRect)rect{
    [self.contextField setTextContainerInset:UIEdgeInsetsZero];
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
    }else if (self.imgArr.count < 4){
        self.row1Ratio.priority = 900;
        self.row1HideRatio.priority = 800;
        self.row2Ratio.priority = 800;
        self.row2HideRatio.priority = 900;
        self.row3Ratio.priority = 800;
        self.row3HideRatio.priority = 900;
        self.row12Height.constant = 0;
        self.row23Height.constant = 0;
    }else if (self.imgArr.count < 7){
        self.row1Ratio.priority = 900;
        self.row1HideRatio.priority = 800;
        self.row2Ratio.priority = 900;
        self.row2HideRatio.priority = 800;
        self.row3Ratio.priority = 800;
        self.row3HideRatio.priority = 900;
        self.row12Height.constant = 13;
        self.row23Height.constant = 0;
    }else{
        self.row1Ratio.priority = 900;
        self.row1HideRatio.priority = 800;
        self.row2Ratio.priority = 900;
        self.row2HideRatio.priority = 800;
        self.row3Ratio.priority = 900;
        self.row3HideRatio.priority = 800;
        self.row12Height.constant = 13;
        self.row23Height.constant = 13;
    }
    [super drawRect:rect];
}

@end
