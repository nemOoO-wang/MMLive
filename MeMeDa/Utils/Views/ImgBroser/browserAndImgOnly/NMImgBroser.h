//
//  NMImgBroser.h
//  MeMeDa
//
//  Created by 镓洲 王 on 6/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImgType) {
    ImgTypeImg,
    ImgTypeUrl,
};

@interface NMImgBroser : UIPageViewController

@property (nonatomic,strong) NSArray *imgArr;
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,assign) ImgType arrType;

@end
