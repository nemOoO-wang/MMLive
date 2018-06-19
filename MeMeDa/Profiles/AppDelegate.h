//
//  AppDelegate.h
//  MeMeDa
//
//  Created by 镓洲 王 on 5/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import <UIKit/UIKit.h>
// 小米推送
#import "MiPushSDK.h"

@interface AppDelegate : UIResponder <MiPushSDKDelegate,      // <--
                                    UNUserNotificationCenterDelegate,      // <-- iOS10+
                                    UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

