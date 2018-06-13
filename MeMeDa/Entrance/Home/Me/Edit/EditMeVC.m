//
//  EditMeVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 6/6/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "EditMeVC.h"
#import "NMTextView.h"
#import "DatePickerVC.h"
#import "CityPickerVC.h"
#import "NMClickVideoView.h"
#import "NMLongPressButton.h"
#import <QBImagePickerController/QBImagePickerController.h>
#import "NMPicsBlowser.h"
#import "EditMeRecordAudio.h"
#import <AVKit/AVKit.h>
#import "NetEaseOSS.h"
#import <AVFoundation/AVFoundation.h>


@interface EditMeVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate,UITextFieldDelegate,NMTextViewDelegate,NMLongPressDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextField *jobTF;
@property (weak, nonatomic) IBOutlet NMTextView *signTF;
@property (weak, nonatomic) IBOutlet NMTextView *psTF;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
// video
@property (weak, nonatomic) IBOutlet UIImageView *videoCover;
@property (weak, nonatomic) IBOutlet UIImageView *videoExist;
@property (weak, nonatomic) IBOutlet NMClickVideoView *vedioView;
@property (nonatomic,strong) NSURL *vedioUrl;
// imgs
@property (nonatomic,strong) NSArray<NSString *> *imgarr;
@property (weak, nonatomic) IBOutlet NMLongPressButton *img1;
@property (weak, nonatomic) IBOutlet NMLongPressButton *img2;
@property (weak, nonatomic) IBOutlet NMLongPressButton *img3;
@property (weak, nonatomic) IBOutlet NMLongPressButton *img4;
@property (weak, nonatomic) IBOutlet NMLongPressButton *img5;
@property (weak, nonatomic) IBOutlet NMLongPressButton *img6;
// audio
@property (nonatomic,strong) NSURL *audioUrl;
@property (weak, nonatomic) IBOutlet UIButton *audioPlayBtn;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;


@end

@implementation EditMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signTF.nm_delegate = self;
    self.psTF.nm_delegate = self;
    // layout text view
    self.signTF.layer.borderColor = [UIColor colorWithHexString:@"A3A3A3"].CGColor;
    self.signTF.layer.borderWidth = 1;
    self.signTF.layer.cornerRadius = 5;
    self.psTF.layer.borderColor = [UIColor colorWithHexString:@"A3A3A3"].CGColor;
    self.psTF.layer.borderWidth = 1;
    self.psTF.layer.cornerRadius = 5;
    // update data
    // 用户字典
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    self.nickname.text = userDic[@"nickname"];
    self.birthdayLabel.text = userDic[@"birthday"];
    self.locationLabel.text = userDic[@"cityName"];
        // head
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:userDic[@"headImg"]]];
        // video
    self.vedioUrl = [NSURL URLWithString:userDic[@"video"]];
    if (self.vedioUrl) {
        self.videoExist.hidden = NO;
        self.vedioView.videoUrl = self.vedioUrl;
        [self.videoCover sd_setImageWithURL:[NSURL URLWithString:userDic[@"vedioImg"]]];
    }else{
        self.videoExist.hidden = YES;
    }
        // audio
    self.audioUrl = [NSURL URLWithString:userDic[@"voice"]];
    if (self.audioUrl) {
        self.audioPlayBtn.hidden = NO;
    }else{
        self.audioPlayBtn.hidden = YES;
    }
    // imgs
    NSArray *imgArr;
    if ([userDic objectForKey:@"imgs"]) {
        NSData *jsonData = [userDic[@"imgs"] dataUsingEncoding:NSUTF8StringEncoding];
        imgArr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        for (int i=0; i<imgArr.count; i++) {
            if (i==0) {
                [self.img2 sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] forState:UIControlStateNormal];
            }
            if (i==1) {
                [self.img3 sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] forState:UIControlStateNormal];
            }
            if (i==2) {
                [self.img4 sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] forState:UIControlStateNormal];
            }
            if (i==3) {
                [self.img5 sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] forState:UIControlStateNormal];
            }
            if (i==4) {
                [self.img6 sd_setImageWithURL:[NSURL URLWithString:imgArr[i]] forState:UIControlStateNormal];
            }
        }
        self.imgarr = imgArr;
    }else{
        self.imgarr = @[];
    }
    // init btn delegate
    self.img2.nm_Delegate = self;
    self.img3.nm_Delegate = self;
    self.img4.nm_Delegate = self;
    self.img5.nm_Delegate = self;
    self.img6.nm_Delegate = self;
}

-(void)viewDidAppear:(BOOL)animated{
    // 用户字典
    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    self.jobTF.text = userDic[@"profession"];
    self.psTF.text = userDic[@"mark"];
    self.signTF.text = userDic[@"introduction"];
}

# pragma mark - upload
-(void)uploadData{
     NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/saveEdit" andParam:userDic andSuccess:^(id data) {
        [SVProgressHUD showSuccessWithStatus:@"更改成功"];
    }];
}

-(void)smartUpadeData:(id)obj with:(NSString *)key{
    // 用户字典
    NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"] mutableCopy];
    userDic[key] = obj;
    [[NSUserDefaults standardUserDefaults] setObject:[userDic copy] forKey:@"UserData"];
    [self uploadData];
}

# pragma mark - click
- (IBAction)clickHeadImg:(id)sender {
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

- (IBAction)clickDate:(id)sender {
    DatePickerVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DatePicker"];
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    fm.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [fm dateFromString:self.birthdayLabel.text];
    vc.oldDate = date;
    vc.pickDate = ^(NSDate *date) {
        NSString *dateStr = [fm stringFromDate:date];
        self.birthdayLabel.text = dateStr;
        // 用户字典
        NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"] mutableCopy];
        userDic[@"birthday"] = dateStr;
        [[NSUserDefaults standardUserDefaults] setObject:[userDic copy] forKey:@"UserData"];
        [self uploadData];
    };
    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
- (IBAction)clickCity:(id)sender {
    // location
    CityPickerVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"CityPicker"];
    vc.pickLocation = ^(NSString *location) {
        self.locationLabel.text = location;
        // 用户字典
        NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"] mutableCopy];
        userDic[@"cityName"] = location;
        [[NSUserDefaults standardUserDefaults] setObject:[userDic copy] forKey:@"UserData"];
        [self uploadData];
    };
    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (IBAction)clickRecordVideo:(id)sender {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        NSArray *videoMediaTypesOnly = [mediaTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF contains %@)", @"movie"]];
        //        if ([videoMediaTypesOnly count] == 0)        //等于0说明没有录像权限
        // 调用前置摄像头
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
            imgPicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        imgPicker.mediaTypes = videoMediaTypesOnly;
        imgPicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        imgPicker.videoMaximumDuration = 10;            //Specify in seconds (600 is default)
        
        [self presentViewController:imgPicker animated:YES completion:^{}];
    }
}
- (IBAction)clickAddImgs:(id)sender {
    // selec from album
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        QBImagePickerController *imagePickerController = [QBImagePickerController new];
        imagePickerController.mediaType = QBImagePickerMediaTypeImage;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.maximumNumberOfSelection = 6-self.imgarr.count;
        imagePickerController.showsNumberOfSelectedAssets = YES;
        imagePickerController.delegate = self;
        // gray bar
        UINavigationController *tmp = [imagePickerController.childViewControllers firstObject];
        tmp.navigationBar.backgroundColor = [UIColor grayColor];
        [self presentViewController:imagePickerController animated:YES completion:^{
        }];
    }
}
- (IBAction)clickPlayAudio:(id)sender {
    if (!self.audioPlayer) {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.audioUrl error:nil];
    }
    [self.audioPlayer play];
}

# pragma mark - img button long press
-(void)longPress:(UIButton *)button{
    NSInteger tag = button.tag;
    if (tag<self.imgarr.count) {
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"删除图片" message:@"确定删除这张照片吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* confirmAction = [UIAlertAction
           actionWithTitle:@"确定" style:  UIAlertActionStyleDefault
             handler:^(UIAlertAction * action) {
                 NSMutableArray *tmpArr = [self.imgarr mutableCopy];
                 [tmpArr removeObjectAtIndex:tag];
                 self.imgarr = [tmpArr copy];
                 [self updateImgs];
             }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {}];
        [alertCon addAction:confirmAction];
        [alertCon addAction:cancelAction];
        [self presentViewController:alertCon animated:YES completion:^{
            
        }];
    }
}

# pragma mark - text view delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        // nickname
        [self smartUpadeData:textField.text with:@"nickname"];
    }else{
        // job
        [self smartUpadeData:textField.text with:@"profession"];
    }
}

- (void)nm_textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 1) {
        // sign
        [self smartUpadeData:textView.text with:@"introduction"];
    }else{
        // ps
        [self smartUpadeData:textView.text with:@"mark"];
    }
}

# pragma mark - <UIImagePickerControllerDelegate>
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    self.meImage = info[UIImagePickerControllerOriginalImage];
    //    self.myPicImageView.image = self.meImage;
    if ([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.movie"]) {
        [SVProgressHUD show];
        // 视频
        NSURL *vedioUrl = info[@"UIImagePickerControllerMediaURL"];
        // vImg
        AVAsset *asset = [AVAsset assetWithURL:vedioUrl];
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime time = CMTimeMake(1, 1);
        imageGenerator.appliesPreferredTrackTransform = YES;
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        UIImage *imgCover = [UIImage imageWithCGImage:imageRef];
        self.videoCover.image = imgCover;
        self.videoExist.hidden = NO;
        CGImageRelease(imageRef);
        // other setting
        self.vedioView.videoUrl = vedioUrl;
        __block NSString *vUrl;
        __block NSString *viUrl;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_group_t group = dispatch_group_create();
//        1
        dispatch_group_enter(group);
        [[NetEaseOSS sharedInstance] putMOV:vedioUrl result:^(NSString *urlPath) {
            self.vedioUrl = [NSURL URLWithString:urlPath];
//            1-
            dispatch_group_leave(group);
            vUrl = urlPath;
        }];
//        2
        dispatch_group_enter(group);
        [[NetEaseOSS sharedInstance] putImage:imgCover result:^(NSString *urlPath) {
//            2-
            dispatch_group_leave(group);
            viUrl = urlPath;
        }];
//        3
        dispatch_group_notify(group, queue, ^{
            // 用户字典
            NSMutableDictionary *userDic = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"] mutableCopy];
            userDic[@"video"] = vUrl;
            userDic[@"vedioImg"] = viUrl;
            [[NSUserDefaults standardUserDefaults] setObject:[userDic copy] forKey:@"UserData"];
            [self uploadData];
        });
    }else{
        // 单图
        UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
        self.headImg.image = img;
        [[NetEaseOSS sharedInstance] putImage:img result:^(NSString *urlPath) {
            [self smartUpadeData:urlPath with:@"headImg"];
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - <QBImagePickerControllerDelegate>
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    PHImageRequestOptions *phiOpt = [[PHImageRequestOptions alloc] init];
    phiOpt.synchronous = YES;
    __block NSMutableArray *imgArs = [[NSMutableArray alloc] init];
    for (PHAsset *asset in assets) {
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:phiOpt resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            UIImage *img = [UIImage imageWithData:imageData];
            [imgArs addObject:img];
        }];
    }
    [SVProgressHUD show];
    [[NetEaseOSS sharedInstance] putImages:[imgArs copy] result:^(NSArray *urlArr) {
        self.imgarr = [self.imgarr arrayByAddingObjectsFromArray:urlArr];
        [self updateImgs];
        [self dismissViewControllerAnimated:YES completion:NULL];
        [SVProgressHUD dismiss];
    }];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)updateImgs{
    // load
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.imgarr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self smartUpadeData:jsonStr with:@"imgs"];
    // clear
    [self.img2 setImage:nil forState:UIControlStateNormal];
    [self.img3 setImage:nil forState:UIControlStateNormal];
    [self.img4 setImage:nil forState:UIControlStateNormal];
    [self.img5 setImage:nil forState:UIControlStateNormal];
    [self.img6 setImage:nil forState:UIControlStateNormal];
    // set imgs
    [self.imgarr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURL *url = [NSURL URLWithString:obj];
        switch (idx) {
            case 0:
                [self.img2 sd_setImageWithURL:url forState:UIControlStateNormal];
                break;
            case 1:
                [self.img3 sd_setImageWithURL:url forState:UIControlStateNormal];
                break;
            case 2:
                [self.img4 sd_setImageWithURL:url forState:UIControlStateNormal];
                break;
            case 3:
                [self.img5 sd_setImageWithURL:url forState:UIControlStateNormal];
                break;
            case 4:
                [self.img6 sd_setImageWithURL:url forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"audio"]) {
        EditMeRecordAudio *vc = segue.destinationViewController;
        vc.recorded = ^(NSURL *url) {
            self.audioUrl = url;
            self.audioPlayBtn.hidden = NO;
            [[NetEaseOSS sharedInstance] putM4A:url result:^(NSString *urlPath) {
                [self smartUpadeData:[url absoluteString] with:@"voice"];
            }];
        };
    }
}


@end
