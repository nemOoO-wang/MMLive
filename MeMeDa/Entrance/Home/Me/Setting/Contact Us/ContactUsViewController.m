//
//  ContactUsViewController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/17/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "ContactUsViewController.h"
#import "NMTextView.h"
#import "NetEaseOSS.h"


@interface ContactUsViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet NMTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,strong) NSString *imgUrl;
@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"FFFFFF " alpha:0.4].CGColor;
    self.textView.layer.borderWidth = 1;
    self.btnView.layer.borderColor = [UIColor colorWithHexString:@"FFFFFF " alpha:0.4].CGColor;
    self.btnView.layer.borderWidth = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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


- (IBAction)clickUpload:(id)sender {
    if ([self.textView isEdited]) {
        NSString *img = self.imgUrl? self.imgUrl: @"";
        NSDictionary *paramDic = @{@"content":self.textView.text, @"img":img};
        [[BeeNet sharedInstance] requestWithType:Request_POST andUrl:@"/chat/user/saveSuggestion" andParam:paramDic andSuccess:^(id data) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请输入反馈"];
    }
}


# pragma mark - <UIImagePickerControllerDelegate>
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [SVProgressHUD show];
    // 单图
    UIImage *img = info[@"UIImagePickerControllerOriginalImage"];
    self.imgView.image = img;
    [[NetEaseOSS sharedInstance] putImage:img result:^(NSString *urlPath) {
        self.imgUrl = urlPath;
        [SVProgressHUD dismiss];
    }];
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
