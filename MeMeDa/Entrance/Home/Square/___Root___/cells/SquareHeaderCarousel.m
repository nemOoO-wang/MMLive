//
//  SquareHeaderCarousel.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/8/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "SquareHeaderCarousel.h"

@interface SquareHeaderCarousel()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *index0;
@property (weak, nonatomic) IBOutlet UIView *index1;
@property (weak, nonatomic) IBOutlet UIView *index2;
@property (weak, nonatomic) IBOutlet UIView *index3;
@property (weak, nonatomic) IBOutlet UIView *index4;

@property (weak, nonatomic) IBOutlet UIButton *img0;
@property (weak, nonatomic) IBOutlet UIButton *img1;
@property (weak, nonatomic) IBOutlet UIButton *img2;
@property (weak, nonatomic) IBOutlet UIButton *img3;
@property (weak, nonatomic) IBOutlet UIButton *img4;


@end


@implementation SquareHeaderCarousel

-(void)didMoveToSuperview{
    [[BeeNet sharedInstance] requestWithType:Request_GET andUrl:@"/chat/user/getBunner" andParam:nil andSuccess:^(id data) {
        NSArray *imgArr = data[@"data"];
        [self.img0 sd_setImageWithURL:[NSURL URLWithString:imgArr[0]] forState:UIControlStateNormal];
        [self.img1 sd_setImageWithURL:[NSURL URLWithString:imgArr[1]] forState:UIControlStateNormal];
        if (imgArr.count>4) {
            [self.img4 sd_setImageWithURL:[NSURL URLWithString:imgArr[4]] forState:UIControlStateNormal];
            [self.img3 sd_setImageWithURL:[NSURL URLWithString:imgArr[3]] forState:UIControlStateNormal];
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:imgArr[2]] forState:UIControlStateNormal];
        }else if (imgArr.count>3){
            [self.img3 sd_setImageWithURL:[NSURL URLWithString:imgArr[3]] forState:UIControlStateNormal];
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:imgArr[2]] forState:UIControlStateNormal];
        }else if (imgArr.count>2){
            [self.img2 sd_setImageWithURL:[NSURL URLWithString:imgArr[2]] forState:UIControlStateNormal];
        }
    }];
}


- (IBAction)clickImg:(id)sender {
    NSLog(@"click");
}

# pragma mark - <UIScrollViewDelegate>
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = self.scrollView.contentOffset.x/ SCREEN_WIDTH;
    [self showIndicatorAtIndex:index];
}

-(void)showIndicatorAtIndex:(NSInteger)index{
    [self.index0 setBackgroundColor:[UIColor lightGrayColor]];
    [self.index1 setBackgroundColor:[UIColor lightGrayColor]];
    [self.index2 setBackgroundColor:[UIColor lightGrayColor]];
    [self.index3 setBackgroundColor:[UIColor lightGrayColor]];
    [self.index4 setBackgroundColor:[UIColor lightGrayColor]];
    switch (index) {
        case 0:
            [self.index0 setBackgroundColor:[UIColor whiteColor]];
            break;
        
        case 1:
            [self.index1 setBackgroundColor:[UIColor whiteColor]];
            break;
            
        case 2:
            [self.index2 setBackgroundColor:[UIColor whiteColor]];
            break;
            
        case 3:
            [self.index3 setBackgroundColor:[UIColor whiteColor]];
            break;
            
        case 4:
            [self.index4 setBackgroundColor:[UIColor whiteColor]];
            break;
            
        default:
            break;
    }
}

@end
