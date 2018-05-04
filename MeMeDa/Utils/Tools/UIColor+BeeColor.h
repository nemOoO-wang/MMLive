//
//  UIColor+BeeColor.h
//  ShopDog
//
//  Created by 陈必锋 on 2017/8/4.
//  Copyright © 2017年 shopDog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BeeColor)

+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
