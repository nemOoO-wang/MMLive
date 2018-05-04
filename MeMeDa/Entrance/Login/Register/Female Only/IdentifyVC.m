//
//  IdentifyVC.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/4/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "IdentifyVC.h"


@interface IdentifyVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myPicImageView;

@property (nonatomic,strong) UIImage *meImage;


@end

@implementation IdentifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

// select pic
- (IBAction)clickSelectPic:(id)sender {
    // init img picker
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
//    picker.allowsEditing = YES;
    picker.navigationBar.tintColor = [UIColor darkGrayColor];
    picker.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    // alert
    UIAlertController* alert = [UIAlertController
        alertControllerWithTitle:nil message:nil
        preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* fromAlbum = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {
                // selec from album
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:picker animated:YES completion:^{}];
                }
            }];
    UIAlertAction* fromCamera = [UIAlertAction actionWithTitle:@"拍一张" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action) {
                // select from camera
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:^{}];
                }
            }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:fromAlbum];
    [alert addAction:fromCamera];
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}


# pragma mark - <UIImagePickerControllerDelegate>
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.meImage = info[UIImagePickerControllerOriginalImage];
    self.myPicImageView.image = self.meImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
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
