//
//  ImageOnlyController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/5/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ImageOnlyController.h"

@interface ImageOnlyController ()

@end

@implementation ImageOnlyController

+(instancetype)controllerWithImage:(UIImage *)img andIndex:(NSInteger)index{
    ImageOnlyController *vc = [[ImageOnlyController alloc] init];
    vc.index = index;
    vc.img = img;
    vc.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [vc.view setBackgroundColor:[UIColor blackColor]];
    // pic
    UIImageView *iv = [[UIImageView alloc] initWithImage:vc.img];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.frame = vc.view.bounds;
    [vc.view addSubview:iv];
    return vc;
}

+(instancetype)controllerWithImageUrl:(NSString *)imgUrl andIndex:(NSInteger)index{
    ImageOnlyController *vc = [[ImageOnlyController alloc] init];
    vc.index = index;
    vc.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [vc.view setBackgroundColor:[UIColor blackColor]];
    // pic
    UIImageView *iv = [[UIImageView alloc] init];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.frame = vc.view.bounds;
    [iv sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    [vc.view addSubview:iv];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
