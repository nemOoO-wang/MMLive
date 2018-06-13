//
//  ChatTBCell.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/13/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ChatTBCell.h"


@interface ChatTBCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UIButton *textContent;

@end

@implementation ChatTBCell

-(void)setContent:(NSString *)content{
    _content = content;
    [self.textContent setTitle:content forState:UIControlStateNormal];
    CGSize size = [content boundingRectWithSize:CGSizeMake(207, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    if(size.height <= 60){
        CGRect frame = self.textContent.frame;
        frame.size.width = size.width + 50;
        self.textContent.frame = frame;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
