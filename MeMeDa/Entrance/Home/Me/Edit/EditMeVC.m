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
#import <QBImagePickerController/QBImagePickerController.h>
#import "NMPicsBlowser.h"
#import "EditMeRecordAudio.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>


@interface EditMeVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>
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
@property (nonatomic,strong) NSArray<UIImage *> *imgarr;
@property (weak, nonatomic) IBOutlet UIButton *img1;
@property (weak, nonatomic) IBOutlet UIButton *img2;
@property (weak, nonatomic) IBOutlet UIButton *img3;
@property (weak, nonatomic) IBOutlet UIButton *img4;
@property (weak, nonatomic) IBOutlet UIButton *img5;
@property (weak, nonatomic) IBOutlet UIButton *img6;
// audio
@property (nonatomic,strong) NSURL *audioUrl;
@property (weak, nonatomic) IBOutlet UIButton *audioPlayBtn;
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;


@end

@implementation EditMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgarr = @[];
    // layout text view
    self.signTF.layer.borderColor = [UIColor colorWithHexString:@"A3A3A3"].CGColor;
    self.signTF.layer.borderWidth = 1;
    self.signTF.layer.cornerRadius = 5;
    self.psTF.layer.borderColor = [UIColor colorWithHexString:@"A3A3A3"].CGColor;
    self.psTF.layer.borderWidth = 1;
    self.psTF.layer.cornerRadius = 5;
    // video
    self.videoExist.hidden = YES;
    // audio
    self.audioPlayBtn.hidden = YES;
}

- (IBAction)clickHeadImg:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* shootAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertAction* albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
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
        self.birthdayLabel.text = [fm stringFromDate:date];
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

# pragma mark - <UIImagePickerControllerDelegate>
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    self.meImage = info[UIImagePickerControllerOriginalImage];
    //    self.myPicImageView.image = self.meImage;
    if ([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.movie"]) {
        // 视频
        NSURL *vedioUrl = info[@"UIImagePickerControllerMediaURL"];
        self.vedioUrl = vedioUrl;
        // vImg
        AVAsset *asset = [AVAsset assetWithURL:vedioUrl];
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime time = CMTimeMake(1, 1);
        imageGenerator.appliesPreferredTrackTransform = YES;
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        self.videoCover.image = [UIImage imageWithCGImage:imageRef];
        self.videoExist.hidden = NO;
        CGImageRelease(imageRef);
        // other setting
        self.vedioView.videoUrl = vedioUrl;
    }else{
        // 单图
        UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
        self.headImg.image = img;
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
    self.imgarr = [self.imgarr arrayByAddingObjectsFromArray:imgArs];
    [self updateImgs];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)updateImgs{
    [self.img2 setImage:nil forState:UIControlStateNormal];
    [self.img3 setImage:nil forState:UIControlStateNormal];
    [self.img4 setImage:nil forState:UIControlStateNormal];
    [self.img5 setImage:nil forState:UIControlStateNormal];
    [self.img6 setImage:nil forState:UIControlStateNormal];
    [self.imgarr enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (idx) {
            case 0:
                [self.img2 setImage:obj forState:UIControlStateNormal];
                break;
            case 1:
                [self.img3 setImage:obj forState:UIControlStateNormal];
                break;
            case 2:
                [self.img4 setImage:obj forState:UIControlStateNormal];
                break;
            case 3:
                [self.img5 setImage:obj forState:UIControlStateNormal];
                break;
            case 4:
                [self.img6 setImage:obj forState:UIControlStateNormal];
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
        };
    }
}


@end
