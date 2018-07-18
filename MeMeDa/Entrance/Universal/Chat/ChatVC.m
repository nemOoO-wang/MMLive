//
//  ChatVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/24/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ChatVC.h"
#import "ChatTBCell.h"
#import "NetEaseOSS.h"
#import <AVFoundation/AVFoundation.h>
#import <RongCloudIM/RongIMLib/RongIMLib.h>


@interface ChatVC ()<UITableViewDelegate, UITableViewDataSource,
                    RCIMClientReceiveMessageDelegate,
                    UITextFieldDelegate,UIImagePickerControllerDelegate,
                    UINavigationControllerDelegate,AVAudioRecorderDelegate>
@property (nonatomic,strong) RCUserInfo *myUserInfo;
@property (nonatomic,strong) NSString *friendId;
@property (nonatomic,strong) NSArray *dialogHistoryArr;
@property (nonatomic,strong) AVAudioRecorder *recoder;
@property (nonatomic,strong) NSURL *audioUrl;
@property (nonatomic,strong) UIVisualEffectView *blurView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;

@end


@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.friendUserDic[@"nickname"]];
    self.tableView.estimatedRowHeight = 50;
    
    // 设置消息接收监听
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    // 本地历史
    self.dialogHistoryArr = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:self.friendId count:20];
    // 远程历史
    [[RCIMClient sharedRCIMClient] getRemoteHistoryMessages:ConversationType_PRIVATE targetId:self.friendId recordTime:0 count:20 success:^(NSArray *messages) {
        //        self.dialogHistoryArr =
    } error:^(RCErrorCode status) {
        NSLog(@"融云远程历史出错");
    }];
    // audio session
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"myRecord.wav"];
    NSURL *pathUrl = [NSURL fileURLWithPath:path];
    self.audioUrl = pathUrl;
    NSError *err = nil;
    NSDictionary *settings = @{AVFormatIDKey: @(kAudioFormatLinearPCM),
                               AVSampleRateKey: @8000.00f,
                               AVNumberOfChannelsKey: @1,
                               AVLinearPCMBitDepthKey: @16,
                               AVLinearPCMIsNonInterleaved: @NO,
                               AVLinearPCMIsFloatKey: @NO,
                               AVLinearPCMIsBigEndianKey: @NO};
    self.recoder = [[AVAudioRecorder alloc] initWithURL:pathUrl settings:settings error:&err];
    if (err) {
        NSLog(@"创建录音机对象时发生错误，错误信息：%@",err.localizedDescription);
    }
    self.recoder.delegate = self;
}


-(void)viewDidAppear:(BOOL)animated{
    if (self.dialogHistoryArr.count>0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dialogHistoryArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

-(NSString *)friendId{
    if(!_friendId){
        NSInteger targetIdInt = [[self.friendUserDic objectForKey:@"id"] integerValue];
        _friendId = [NSString stringWithFormat:@"%ld",targetIdInt];
    }
    return _friendId;
}

-(RCUserInfo *)myUserInfo{
    if(!_myUserInfo){
        NSDictionary *userDic = MDUserDic;
        NSInteger idInt = [[userDic objectForKey:@"id"] integerValue];
        NSString *targitId = [NSString stringWithFormat:@"%ld",idInt];
        _myUserInfo = [[RCUserInfo alloc] initWithUserId:targitId name:userDic[@"nickname"] portrait:userDic[@"headImg"]];
    }
    return _myUserInfo;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - click
- (IBAction)clickAddImg:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* shootAction = [UIAlertAction actionWithTitle:@"拍照"
          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
              // select from camera
              if([UIImagePickerController isSourceTypeAvailable:
                  UIImagePickerControllerSourceTypeCamera]){
                  // init imgPicker
                  UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                  imgPicker.delegate = self;
                  //    imgPicker.allowsEditing = YES;
                  imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                  [self presentViewController:imgPicker animated:YES completion:^{
                      imgPicker.navigationBar.backgroundColor = [UIColor darkGrayColor];
                  }];
              }
      }];
    UIAlertAction* albumAction = [UIAlertAction actionWithTitle:@"相册"
          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
              // select from camera
              if([UIImagePickerController isSourceTypeAvailable:
                  UIImagePickerControllerSourceTypePhotoLibrary]){
                  // init imgPicker
                  UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
                  imgPicker.delegate = self;
                  //    imgPicker.allowsEditing = YES;
                  imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                  [self presentViewController:imgPicker animated:YES completion:^{
                      imgPicker.navigationBar.backgroundColor = [UIColor darkGrayColor];
                  }];
              }
      }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    
    [alert addAction:shootAction];
    [alert addAction:albumAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

                                               
- (IBAction)audioClickDown:(id)sender {
    [self.recoder prepareToRecord];
    [self.recoder deleteRecording];
    if (![self.recoder isRecording]){
        [self.recoder record];
    }
    [SVProgressHUD showWithStatus:@"录音中。。。"];
}
- (IBAction)audioClickEnd:(id)sender {
    [self.recoder stop];
    [SVProgressHUD showSuccessWithStatus:@"发送成功"];
}
- (IBAction)audioClickCancel:(id)sender {
    [SVProgressHUD showInfoWithStatus:@"取消"];
}

# pragma mark - <Delegate>
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (flag) {
        NSData *audioData = [NSData dataWithContentsOfURL:self.audioUrl];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:audioData error:nil];
        RCVoiceMessage *msg = [RCVoiceMessage messageWithAudio:audioData duration:player.duration];
        [[RCIMClient sharedRCIMClient] sendMediaMessage:ConversationType_PRIVATE targetId:self.friendId content:msg pushContent:nil pushData:nil progress:^(int progress, long messageId) {
            
        } success:^(long messageId) {
            [self refreshMsg];
        } error:^(RCErrorCode errorCode, long messageId) {
            
        } cancel:^(long messageId) {
            
        }];
    }
}

# pragma mark - <UIImagePickerControllerDelegate>
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 单图
    UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
    RCImageMessage *imgMsg = [RCImageMessage messageWithImage:img];
    [[RCIMClient sharedRCIMClient] sendMediaMessage:ConversationType_PRIVATE targetId:self.friendId content:imgMsg pushContent:nil pushData:nil progress:^(int progress, long messageId) {
    } success:^(long messageId) {
        [self refreshMsg];
    } error:^(RCErrorCode errorCode, long messageId) {
        
    } cancel:^(long messageId) {
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - <text field delegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // content
    RCTextMessage *mContent = [RCTextMessage messageWithContent:self.inputTextField.text];
    NSString *rmPuthContent = [NSString stringWithFormat:@"%@: %@",self.friendUserDic[@"nickname"], self.inputTextField.text];
    mContent.senderUserInfo = self.myUserInfo;
    self.inputTextField.text = @"";
    [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:self.friendId content:mContent pushContent:rmPuthContent pushData:nil success:^(long messageId) {
    } error:^(RCErrorCode nErrorCode, long messageId) {
        
    }];
    [self refreshMsg];
    return YES;
}

-(void)refreshMsg{
    self.dialogHistoryArr = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_PRIVATE targetId:self.friendId count:20];
    [self.tableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dialogHistoryArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

# pragma mark - <UITableViewDataSource>

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCMessage *msg = self.dialogHistoryArr[self.dialogHistoryArr.count - indexPath.row - 1];
    ChatTBCell *cell;
    // differ cell type
    NSString *userId;
    if ([msg isMemberOfClass:[RCMessage class]]) {
        userId = msg.senderUserId;
    }else{
        RCTextMessage *testMessage = (RCTextMessage *)msg;
        userId = testMessage.senderUserInfo.userId;
    }
    if([userId isEqualToString:self.friendId]){
        // you
        cell = [tableView dequeueReusableCellWithIdentifier:@"friend"];
        cell.userDic = self.friendUserDic;
    }else{
        // me
        cell = [tableView dequeueReusableCellWithIdentifier:@"me"];
        cell.userDic = MDUserDic;
    }
    
    // reveived message
    if ([msg isMemberOfClass:[RCMessage class]]) {
        // history
        // origin message
        if ([msg.content isMemberOfClass:[RCTextMessage class]]) {
            RCTextMessage *testMessage = (RCTextMessage *)msg.content;
            cell.content = testMessage.content;
        }
    }else{
        if ([msg isMemberOfClass:[RCTextMessage class]]) {
            RCTextMessage *testMessage = (RCTextMessage *)msg;
            cell.content = testMessage.content;
        }else if([msg.content isMemberOfClass:[RCImageMessage class]]){
            RCImageMessage *imgMsg = (RCImageMessage *)msg.content;
            cell.imgUrl = imgMsg.imageUrl;
        }else if([msg.content isMemberOfClass:[RCVoiceMessage class]]){
            RCVoiceMessage *voiceMsg = (RCVoiceMessage *)msg.content;
            cell.voiceData = voiceMsg.wavAudioData;
        }
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dialogHistoryArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.dialogHistoryArr.count == 0) {
        return 0;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCMessage *msg = self.dialogHistoryArr[self.dialogHistoryArr.count - indexPath.row - 1];
    if ([msg.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *testMessage = (RCTextMessage *)msg.content;
        NSString *str = testMessage.content;
        CGSize size = [str boundingRectWithSize:CGSizeMake(207, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        if(size.height<60){
            return 60;
        }else{
            return size.height+20;
        }
    }else if([msg.content isMemberOfClass:[RCImageMessage class]]){
        return 200;
    }else if([msg.content isMemberOfClass:[RCVoiceMessage class]]){
        return 60;
    }
    return 60;
}

# pragma mark - <RCIMClientReceiveMessageDelegate>
/*!
 @param message     当前接收到的消息
 @param nLeft       还剩余的未接收的消息数，left>=0
 @param object      消息监听设置的key值
 
 @discussion 如果您设置了IMlib消息监听之后，SDK在接收到消息时候会执行此方法。
 其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
 您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
 object为您在设置消息接收监听时的key值。
 */
- (void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object {
    if ([message.content isMemberOfClass:[RCTextMessage class]]) {
        RCTextMessage *textMessage = (RCTextMessage *)message.content;
        NSLog(@"消息内容：%@", textMessage.content);
//        NSMutableArray *tmpArr = [self.dialogHistoryArr mutableCopy];
//        [tmpArr addObject:textMessage];
//        self.dialogHistoryArr = [tmpArr copy];
//        dispatch_sync(dispatch_get_main_queue(), ^{
////            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
//            [self.tableView reloadData];
//        });
        [self refreshMsg];
    }
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}


@end
