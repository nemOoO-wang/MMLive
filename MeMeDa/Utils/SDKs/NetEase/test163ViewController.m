//
//  test163ViewController.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/31/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "test163ViewController.h"
#import "NetEaseOSS.h"


@interface test163ViewController ()

@end

@implementation test163ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickddd:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"nipple.jpg" ofType:nil];
    NSString *path2 = NSTemporaryDirectory();
    UIImage *tmpImg = [UIImage imageNamed:@"gakki"];
//    NSData dataWithContentsOfFile:<#(nonnull NSString *)#>
    
    [[NetEaseOSS sharedInstance] putFile:path withKey:@"AAAgakki.jpg" result:^(NOSResponseInfo *info, NSString *key, NSDictionary *resp) {
        
    }];
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
