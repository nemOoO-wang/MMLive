//
//  ChatContentButton.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ChatContentButton.h"

@implementation ChatContentButton

-(instancetype)initWithType:(ChaterType)type{
    if(self = [super init]){
        self.chatType = type;
        if(type == ChaterTypeFriend){
            // you
            self.titleEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 5);
                // layer
            self.maskLayer = [CAShapeLayer layer];
            self.maskLayer.contents = (id)[UIImage imageNamed:@"Combined Shape Copy 2"].CGImage;
            self.maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
            self.maskLayer.contentsScale = [UIScreen mainScreen].scale;
            self.layer.mask = self.maskLayer;
            [self setBackgroundColor:[UIColor whiteColor]];
            // title
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
            //        [self.contentBtn setTitle:content forState:UIControlStateNormal];
//            [self setImage:[UIImage imageNamed:@"gakki"] forState:UIControlStateNormal];
        }else{
            // me
            self.titleEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 15);
            // layer
            self.maskLayer = [CAShapeLayer layer];
            self.maskLayer.contents = (id)[UIImage imageNamed:@"Combined Shape Copy 3"].CGImage;
            self.maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
            self.maskLayer.contentsScale = [UIScreen mainScreen].scale;
            self.layer.mask = self.maskLayer;
            [self setBackgroundColor:[UIColor colorWithHexString:@"FF7799"]];
            // title
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        }
    }
    return self;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    // delete image
    [self setImage:nil forState:UIControlStateNormal];
    // update frame
    CGSize size = [title boundingRectWithSize:CGSizeMake(207, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        // fix string size
    if(size.height <= 40){
        size.height = 40;
    }else{
        size.height += 20;
    }
    if(self.chatType == ChaterTypeFriend){
        self.frame = CGRectMake(65, 5, size.width+20, size.height);
    }else{
        self.frame = CGRectMake(SCREEN_WIDTH - (65+size.width+20), 5, size.width+20, size.height);
    }
        // fix layer
    self.maskLayer.frame = self.bounds;
    [super setTitle:title forState:state];
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setTitle:nil forState:UIControlStateNormal];
    [super setImage:image forState:state];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
