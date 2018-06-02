//
//  NewMomentVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/16/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "NewMomentVC.h"
#import <QBImagePickerController/QBImagePickerController.h>
#import "NetEaseOSS.h"
#import <AVKit/AVKit.h>


@interface NewMomentVC ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumBtn;
@property (weak, nonatomic) IBOutlet UIButton *vedioBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
// img views
@property (weak, nonatomic) IBOutlet UIImageView *imgView1;
@property (weak, nonatomic) IBOutlet UIImageView *imgView2;
@property (weak, nonatomic) IBOutlet UIImageView *imgView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgView4;
@property (weak, nonatomic) IBOutlet UIImageView *imgView5;
@property (weak, nonatomic) IBOutlet UIImageView *imgView6;
@property (weak, nonatomic) IBOutlet UIImageView *imgView7;
@property (weak, nonatomic) IBOutlet UIImageView *imgView8;
@property (weak, nonatomic) IBOutlet UIImageView *imgView9;
// vedio view
@property (weak, nonatomic) IBOutlet UIView *vedioView;

// show constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showConstraint3;
// hide constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hideConstraint1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hideConstraint2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hideConstraint3;
// pic constraint
// show
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row1Show;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row2Show;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row3Show;
// hide
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row1Hide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row2Hide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row3Hide;
// margin   13/0
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row12Margin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *row23Margin;
// vedio view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vedioHeigt;

@property (nonatomic,strong) NSArray *imgarr;
@property (nonatomic,assign) BOOL canShowImg;
@property (nonatomic,strong) AVPlayer *avPlayer;
@property (nonatomic,strong) NSURL *vedioUrl;
@property (nonatomic,strong) UIImage *vImg;


@end

@implementation NewMomentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // set text view
    self.textView.text = @"请输入动态文字";
    self.textView.textColor = [UIColor lightGrayColor];
    // hide btn
    self.hideConstraint1.priority = 900;
    self.showConstraint1.priority = 800;
    self.hideConstraint2.priority = 900;
    self.showConstraint2.priority = 800;
    self.hideConstraint3.priority = 900;
    self.showConstraint3.priority = 800;
    self.albumBtn.alpha = 0;
    self.vedioBtn.alpha = 0;
    self.takePhotoBtn.alpha = 0;
    // set pic&vedio
    [self setShowType:NMMomentShowTypeNone];
    self.canShowImg = YES;
    self.imgarr = [[NSArray alloc] init];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

# pragma mark - click
// click add animation
- (IBAction)clickAdd:(id)sender {
    UIButton *addB = sender;
    if (addB.selected) {
        addB.selected = NO;
        // hide
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:2 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.hideConstraint1.priority = 900;
            self.showConstraint1.priority = 800;
            self.hideConstraint2.priority = 900;
            self.showConstraint2.priority = 800;
            self.hideConstraint3.priority = 900;
            self.showConstraint3.priority = 800;
            self.albumBtn.alpha = 0;
            self.vedioBtn.alpha = 0;
            self.takePhotoBtn.alpha = 0;
            [self.view layoutIfNeeded];
        } completion:nil];
    }else{
        addB.selected = YES;
        // show
        [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:10 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
            self.hideConstraint1.priority = 800;
            self.showConstraint1.priority = 900;
            self.hideConstraint2.priority = 800;
            self.showConstraint2.priority = 900;
            self.hideConstraint3.priority = 800;
            self.showConstraint3.priority = 900;
            self.albumBtn.alpha = 1;
            self.vedioBtn.alpha = 1;
            self.takePhotoBtn.alpha = 1;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (IBAction)clickTakePhoto:(id)sender {
    if (self.imgarr.count >= 9) {
        [SVProgressHUD showErrorWithStatus:@"最多9张照片哦！"];
        return;
    }
    if (!self.canShowImg) {
        [SVProgressHUD showErrorWithStatus:@"已经有小视频啦！"];
        return;
    }
    // select from camera
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypeCamera]){
        // init imgPicker
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.delegate = self;
        //    imgPicker.allowsEditing = YES;
        imgPicker.navigationBar.tintColor = [UIColor darkGrayColor];
        imgPicker.navigationBar.tintColor = [UIColor darkGrayColor];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:YES completion:^{}];
    }
}

- (IBAction)clickAlbum:(id)sender {
    if (self.imgarr.count >= 9) {
        [SVProgressHUD showErrorWithStatus:@"最多9张照片哦！"];
        return;
    }
    if (!self.canShowImg) {
        [SVProgressHUD showErrorWithStatus:@"已经有小视频啦！"];
        return;
    }
    // selec from album
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        QBImagePickerController *imagePickerController = [QBImagePickerController new];
        imagePickerController.mediaType = QBImagePickerMediaTypeImage;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.maximumNumberOfSelection = 9-self.imgarr.count;
        imagePickerController.showsNumberOfSelectedAssets = YES;
        imagePickerController.delegate = self;
        imagePickerController.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        imagePickerController.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        [self presentViewController:imagePickerController animated:YES completion:NULL];
    }
}

- (IBAction)clickVedio:(id)sender {
    if (self.imgarr.count > 0) {
        [SVProgressHUD showErrorWithStatus:@"已经有照片啦~"];
        return;
    }
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    //    imgPicker.allowsEditing = YES;
    imgPicker.navigationBar.tintColor = [UIColor darkGrayColor];
    imgPicker.navigationBar.tintColor = [UIColor darkGrayColor];
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

-(void)addPics:(NSArray *)imgArr{
    self.imgarr = [self.imgarr arrayByAddingObjectsFromArray:imgArr];
    for (int i=0; i<self.imgarr.count; i++) {
        switch (i) {
            case 0:
                [self.imgView1 setImage:self.imgarr[i]];
                break;
            case 1:
                [self.imgView2 setImage:self.imgarr[i]];
                break;
            case 2:
                [self.imgView3 setImage:self.imgarr[i]];
                break;
            case 3:
                [self.imgView4 setImage:self.imgarr[i]];
                break;
            case 4:
                [self.imgView5 setImage:self.imgarr[i]];
                break;
            case 5:
                [self.imgView6 setImage:self.imgarr[i]];
                break;
            case 6:
                [self.imgView7 setImage:self.imgarr[i]];
                break;
            case 7:
                [self.imgView8 setImage:self.imgarr[i]];
                break;
            case 8:
                [self.imgView9 setImage:self.imgarr[i]];
                break;
                
            default:
                break;
        }
    }
    // set show mode
    NSInteger lineCount = (self.imgarr.count+2)/3;
    switch (lineCount) {
        case 0:
            [self setShowType:NMMomentShowTypeNone];
            break;
        case 1:
            [self setShowType:NMMomentShowTypeRow1];
            break;
        case 2:
            [self setShowType:NMMomentShowTypeRow2];
            break;
        case 3:
            [self setShowType:NMMomentShowTypeRow3];
            break;
        default:
            [self setShowType:NMMomentShowTypeNone];
            break;
    }
}
- (IBAction)post:(id)sender {
    NSInteger kinds = 0;
    NSString *textContent = @"";
    __block NSString *imgArrJsonStr = @"";
    __block NSString *vedioUrlStr = @"";
    __block NSString *vedioShoot = @"";
    // text
    if (![self.textView.text isEqualToString:@"请输入动态文字"]) {
        textContent = self.textView.text;
        kinds++;
    }
    // GCD
    dispatch_queue_t queue = dispatch_queue_create("push_moment_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_sync(queue, ^{
        // img
        if (self.imgarr.count>0) {
            dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC));
            [[NetEaseOSS sharedInstance] putImages:self.imgarr result:^(NSArray *urlArr) {
                NSArray *imgUrlArr = urlArr;
                // imgs arr json
                NSData *arrData = [NSJSONSerialization dataWithJSONObject:imgUrlArr options:NSJSONWritingPrettyPrinted error:nil];
                vedioUrlStr = [[NSString alloc] initWithData:arrData encoding:NSUTF8StringEncoding];
                dispatch_semaphore_signal(semaphore);
            }];
        }
        // vedio
        if (self.vedioUrl) {
            // write vedio
            dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC));
            [[NetEaseOSS sharedInstance] putMOV:self.vedioUrl result:^(NSString *urlPath) {
                vedioUrlStr = urlPath;
                dispatch_semaphore_signal(semaphore);
            }];
            // write vImg
            dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 5*NSEC_PER_SEC));
            [[NetEaseOSS sharedInstance] putImage:self.vImg result:^(NSString *urlPath) {
                vedioShoot = urlPath;
                dispatch_semaphore_signal(semaphore);
            }];
            
        }
        // push
        if (kinds <= 0) {
            [SVProgressHUD showErrorWithStatus:@"请先编辑内容"];
        }else{
            NSDictionary *paramDic = @{@"text":textContent, @"video":vedioUrlStr, @"vedioImg":vedioShoot, @"imgs":imgArrJsonStr};
            
            [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/insertTrends" andParam:paramDic andSuccess:^(id data) {
                
            }];
        }
    });
//    NSInteger gcdValue = 0;
}

# pragma mark - <UIImagePickerControllerDelegate>
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    self.meImage = info[UIImagePickerControllerOriginalImage];
    //    self.myPicImageView.image = self.meImage;
    if ([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.movie"]) {
        // 视频
        self.canShowImg = NO;
        [self setShowType:NMMomentShowTypeVedio];
        NSURL *vedioUrl = info[@"UIImagePickerControllerMediaURL"];
        self.vedioUrl = vedioUrl;
        // player
        AVPlayer *player = [[AVPlayer alloc] initWithURL:vedioUrl];
        player.muted = YES;
        self.avPlayer = player;
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:[player currentItem]];
        AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        avLayer.frame = self.vedioView.bounds;
        [self.vedioView.layer addSublayer:avLayer];
        [player play];
        // vImg
        AVAsset *asset = [AVAsset assetWithURL:vedioUrl];
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
        CMTime time = CMTimeMake(1, 1);
        imageGenerator.appliesPreferredTrackTransform = YES;
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        self.vImg = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
    }else{
        // 单图
        UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
        [self addPics:@[img]];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)playerItemDidEnd:(NSNotification *)notification {
    [[self.avPlayer currentItem] seekToTime:kCMTimeZero];
    [self.avPlayer play];
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
    [self addPics:imgArs];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

# pragma mark - Fix Views
// text view setting
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入动态文字"]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"请输入动态文字";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

// pic & vedio setting
-(void)setShowType:(NMMomentShowType)type{
    switch (type) {
        case NMMomentShowTypeNone:
            self.row1Show.priority = 800;
            self.row1Hide.priority = 900;
            self.row2Show.priority = 800;
            self.row2Hide.priority = 900;
            self.row3Show.priority = 800;
            self.row3Hide.priority = 900;
            self.row12Margin.constant = 0;
            self.row23Margin.constant = 0;
            self.vedioHeigt.constant = 0;
            break;
        case NMMomentShowTypeRow1:
            self.row1Show.priority = 900;
            self.row1Hide.priority = 800;
            self.row2Show.priority = 800;
            self.row2Hide.priority = 900;
            self.row3Show.priority = 800;
            self.row3Hide.priority = 900;
            self.row12Margin.constant = 0;
            self.row23Margin.constant = 0;
            self.vedioHeigt.constant = 0;
            break;
        case NMMomentShowTypeRow2:
            self.row1Show.priority = 900;
            self.row1Hide.priority = 800;
            self.row2Show.priority = 900;
            self.row2Hide.priority = 800;
            self.row3Show.priority = 800;
            self.row3Hide.priority = 900;
            self.row12Margin.constant = 13;
            self.row23Margin.constant = 0;
            self.vedioHeigt.constant = 0;
            break;
        case NMMomentShowTypeRow3:
            self.row1Show.priority = 900;
            self.row1Hide.priority = 800;
            self.row2Show.priority = 900;
            self.row2Hide.priority = 800;
            self.row3Show.priority = 900;
            self.row3Hide.priority = 800;
            self.row12Margin.constant = 13;
            self.row23Margin.constant = 13;
            self.vedioHeigt.constant = 0;
            break;
        case NMMomentShowTypeVedio:
            self.row1Show.priority = 800;
            self.row1Hide.priority = 900;
            self.row2Show.priority = 800;
            self.row2Hide.priority = 900;
            self.row3Show.priority = 800;
            self.row3Hide.priority = 900;
            self.row12Margin.constant = 0;
            self.row23Margin.constant = 0;
            self.vedioHeigt.constant = 250;
            break;
        default:
            break;
    }
    [self.view layoutIfNeeded];
}

@end
