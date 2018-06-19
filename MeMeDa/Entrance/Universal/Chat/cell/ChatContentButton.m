//
//  ChatContentButton.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/14/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ChatContentButton.h"
#import "NMImgBroser.h"
#import "UIWindow+NMCurrent.h"
#import <AVFoundation/AVFoundation.h>


@interface ChatContentButton()

@property (nonatomic,strong) AVAudioPlayer *aPlayer;


@end

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
        [self addTarget:self action:@selector(cilck) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setAudioData:(NSData *)audioData{
    _audioData = audioData;
    [super setImage:nil forState:UIControlStateNormal];
    [super setTitle:@"🗣 🔉" forState:UIControlStateNormal];
    self.contentType = ContentTypeAudio;
    [self setSize:CGSizeMake(150, 50)];
}

-(void)cilck{
    if (self.contentType == ContentTypeImg) {
        UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] getCurrentViewController];
        NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:10] forKey:UIPageViewControllerOptionInterPageSpacingKey];
        NMImgBroser *pre = [[NMImgBroser alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
        pre.imgArr = @[self.imageView.image];
        pre.index = 0;
        pre.arrType = ImgTypeImg;
        [vc.navigationController pushViewController:pre animated:YES];
    }
    if (self.contentType == ContentTypeAudio) {
        self.aPlayer = [[AVAudioPlayer alloc] initWithData:self.audioData error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
        [self.aPlayer play];
    }
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    // delete image
    [self setImage:nil forState:UIControlStateNormal];
    // contnt type
    self.contentType = ContentTypeText;
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
    if (image) {
        [super setTitle:nil forState:UIControlStateNormal];
        [super setImage:image forState:state];
        // contnt type
        self.contentType = ContentTypeImg;
        [self setSize:CGSizeMake(180/image.size.height*image.size.width, 180)];
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.maskLayer.frame = self.bounds;
}

-(void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    if (self.chatType == ChaterTypeFriend) {
        [self setFrame:CGRectMake(65, frame.origin.y, size.width, size.height)];
    }else{
        CGPoint origin = frame.origin;
        origin.x = origin.x + frame.size.width - size.width;
        [self setFrame:CGRectMake(origin.x, origin.y, size.width, size.height)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
