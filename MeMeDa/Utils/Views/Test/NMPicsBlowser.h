//
//  NMPicsBlowser.h
//  MeMeDa
//
//  Created by 镓洲 王 on 6/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NMPicsBlowser : UIImageView

@property (nonatomic,strong) void (^browser)(void);
@property (nonatomic,strong) void (^deletion)(void);
@property (nonatomic,strong) NSArray *imgArr;


-(void)setImg:(UIImage *)img withBrowser:(void (^)(NMPicsBlowser *obj))browser delete:(void (^)(void))deletion;

@end
