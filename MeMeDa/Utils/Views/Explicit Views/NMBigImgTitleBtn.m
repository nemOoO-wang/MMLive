//
//  NMBigImgTitleBtn.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NMBigImgTitleBtn.h"


IB_DESIGNABLE
@implementation NMBigImgTitleBtn

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGFloat totalHeight = (imageSize.height + titleSize.height + 10);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height),
                                            0.0f,
                                            0.0f,
                                            - titleSize.width);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                            - imageSize.width,
                                            - (totalHeight - titleSize.height),
                                            0.0f);
    
    self.contentEdgeInsets = UIEdgeInsetsMake(0.0f,
                                              0.0f,
                                              titleSize.height,
                                              0.0f);
}

@end
