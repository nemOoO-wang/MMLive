//
//  ChatTBCell.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/13/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ChatTBCell.h"
#import "ChatContentButton.h"


@interface ChatTBCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (nonatomic,strong) ChatContentButton *contentBtn;

@end

@implementation ChatTBCell

-(ChatContentButton *)contentBtn{
    if(!_contentBtn){
        if(self.headImgView.frame.origin.x < SCREEN_WIDTH/2){
            // you
            _contentBtn = [[ChatContentButton alloc] initWithType:ChaterTypeFriend];
        }else{
            // me
            _contentBtn = [[ChatContentButton alloc] initWithType:ChaterTypeMe];
        }
        [self addSubview:_contentBtn];
    }
    return _contentBtn;
}

-(void)setContent:(NSString *)content{
    _content = content;
    [self.contentBtn setTitle:content forState:UIControlStateNormal];
}

-(void)setUserDic:(NSDictionary *)userDic{
    _userDic = userDic;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:userDic[@"headImg"]]];
}

-(void)layoutSubviews{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
