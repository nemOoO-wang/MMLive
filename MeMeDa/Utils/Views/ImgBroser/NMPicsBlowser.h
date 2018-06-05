//
//  NMPicsBlowser.h
//  MeMeDa
//
//  Created by 镓洲 王 on 6/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>


@interface NMPicsBlowser : UIImageView

@property (nonatomic,strong) void (^browser)(void);
@property (nonatomic,strong) void (^deletion)(void);

-(void)setUpWith:(NSArray *)imgArr and:(NSInteger)index;
-(void)setImg:(NSString *)img withBrowser:(void (^)(NMPicsBlowser *obj))browser delete:(void (^)(void))deletion;
-(void)setRawImg:(NSString *)img withBrowser:(void (^)(NMPicsBlowser *obj))browser delete:(void (^)(void))deletion;

@end
