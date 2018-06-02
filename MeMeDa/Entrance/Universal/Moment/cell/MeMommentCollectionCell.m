//
//  MeMommentCollectionCell.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "MeMommentCollectionCell.h"

@interface MeMommentCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *contextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contextFieldHeightConstraint;
// 9 pics
@property (weak, nonatomic) IBOutlet UIImageView *pic1;
@property (weak, nonatomic) IBOutlet UIImageView *pic2;
@property (weak, nonatomic) IBOutlet UIImageView *pic3;
@property (weak, nonatomic) IBOutlet UIImageView *pic4;
@property (weak, nonatomic) IBOutlet UIImageView *pic5;
@property (weak, nonatomic) IBOutlet UIImageView *pic6;
@property (weak, nonatomic) IBOutlet UIImageView *pic7;
@property (weak, nonatomic) IBOutlet UIImageView *pic8;
@property (weak, nonatomic) IBOutlet UIImageView *pic9;

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
        switch (idx) {
            case 0:
                [self.pic1 setImage:imgArr[idx]];
                break;
            case 1:
                [self.pic2 setImage:imgArr[idx]];
                break;
            case 2:
                [self.pic3 setImage:imgArr[idx]];
                break;
            case 3:
                [self.pic4 setImage:imgArr[idx]];
                break;
            case 4:
                [self.pic5 setImage:imgArr[idx]];
                break;
            case 5:
                [self.pic6 setImage:imgArr[idx]];
                break;
            case 6:
                [self.pic7 setImage:imgArr[idx]];
                break;
            case 7:
                [self.pic8 setImage:imgArr[idx]];
                break;
            case 8:
                [self.pic9 setImage:imgArr[idx]];
                break;
            default:
                break;
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
