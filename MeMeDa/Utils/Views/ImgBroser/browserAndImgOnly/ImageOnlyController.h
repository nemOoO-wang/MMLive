//
//  ImageOnlyController.h
//  MeMeDa
//
//  Created by 镓洲 王 on 6/5/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageOnlyController : UIViewController

@property (nonatomic,strong) UIImage *img;
@property (nonatomic,assign) NSInteger index;

+(instancetype)controllerWithImage:(UIImage *)img andIndex:(NSInteger)index;
+(instancetype)controllerWithImageUrl:(NSString *)imgUrl andIndex:(NSInteger)index;

@end
