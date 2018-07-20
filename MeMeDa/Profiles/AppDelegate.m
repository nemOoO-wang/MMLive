//
//  AppDelegate.m
//  MeMeDa
//
//  Created by 镓洲 王 on 5/3/18.
//  Copyright © 2018 镓洲 王. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager.h>
#import <PushKit/PushKit.h>
// RCCloud
#import <RongCloudIM/RongIMLib/RongIMLib.h>
// ShareSDK
#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
// 网易云直播
#import <NIMSDK/NIMSDK.h>
// my VC
#import "StartCallVC.h"
#import "BeCalledVC.h"
#import "VCallVC.h"
#import "NMFloatWindow.h"
#import "UIWindow+NMCurrent.h"


@interface AppDelegate ()<NIMLoginManagerDelegate, PKPushRegistryDelegate, RCIMClientReceiveMessageDelegate>

@property (nonatomic,strong) UIView *vcallView;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // IQKeyboard
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    // 小米推送
    [MiPushSDK registerMiPush:self type:0 connect:YES];
    // 处理点击通知打开app的逻辑
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){//推送信息
        NSString *messageId = [userInfo objectForKey:@"_id_"];
        if (messageId!=nil) {
            [MiPushSDK openAppNotify:messageId];
        }
    }
    // 融云
    [[RCIMClient sharedRCIMClient] initWithAppKey:RCAPPKey];
    // RC远程推送的内容
    NSDictionary *remoteNotificationUserInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    //RC注册推送, iOS 8
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, iOS 8
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCLibDispatchReadReceiptNotification
     object:nil];
    // ShareSDK
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)]
                             onImport:^(SSDKPlatformType platformType){
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 [appInfo SSDKSetupWeChatByAppId:@"wx8d815228ae6baef5"
                                       appSecret:@"b47f4c048d60dd44633dda8c305bcbba"];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 [appInfo SSDKSetupQQByAppId:@"1106892596"
                                      appKey:@"mvPWS5I1GJbRig7S"
                                    authType:SSDKAuthTypeSSO];
//                 [appInfo SSDKSetupQQByAppId:@"QQ41F9D734" appKey:@"mvPWS5I1GJbRig7S" authType:SSDKAuthTypeSSO useTIM:false];
                 break;
             default:
                   break;
                   }
    }];
    
    // 网易云 IM
    NIMSDKOption *opt = [NIMSDKOption optionWithAppKey:NEAPPKey];
#ifdef DEBUG
    opt.apnsCername = @"DevCertificates123";
#else
    opt.apnsCername = @"StoreCertificates123";
#endif
    opt.pkCername = @"MMDVoiPCertificates";
    [[NIMSDK sharedSDK] registerWithOption:opt];
//    [[NIMSDK sharedSDK] registerWithAppID:NEAPPKey cerName:nil];
    
    PKPushRegistry *pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    // login
    if (NEUserAccount) {
        [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
        [[[NIMSDK sharedSDK] loginManager] autoLogin:NEUserAccount token:NEUserToken];
        [[[NIMSDK sharedSDK] loginManager] login:NEUserAccount token:NEUserToken completion:^(NSError * _Nullable error) {
            NSLog(@"%@",error.description);
        }];
    }
    //开启控制台调试
//    [[NIMSDK sharedSDK] enableConsoleLog];
    
    // 注册融云 delegate
    // 设置消息接收监听
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    
    return YES;
}

// 网易云 IM 登录失败回调
- (void)onAutoLoginFailed:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"NIM 登录失败"];
}

/**
 * RC推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /**
     *  RC将得到的devicetoken 传给融云用于离线状态接收push ，您的app后台要上传推送证书
     *  推送处理3
     */
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    // 小米：注册APNS成功, 注册deviceToken
    [MiPushSDK bindDeviceToken:deviceToken];
    // 网易云 IM 注册 token
    [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    // 请检查App的APNs的权限设置，更多内容可以参考文档
    // http://www.rongcloud.cn/docs/ios_push.html。
    NSLog(@"获取DeviceToken失败！！！");
    NSLog(@"ERROR：%@", error);
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}

/**
 * RC推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
    // 小米：消息去重，然后通过miPushReceiveNotification:回调返回给App
    [ MiPushSDK handleReceiveRemoteNotification :userInfo];
}

#pragma mark <MiPushSDKDelegate>
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data
{
    // 请求成功
    // 可在此获取regId
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
        NSLog(@"regid = %@", data[@"regid"]);
    }
}

- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data
{
    // 请求失败
}

- ( void )miPushReceiveNotification:( NSDictionary *)data
{
    // 长连接收到的消息。消息格式跟APNs格式一样
    if ([data[@"code"]integerValue] == 1) {
        BeCalledVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"be called"];
        vc.callDataDic = data;
        [[NMFloatWindow keyFLoatWindow] setFullScreenWithoutAni:YES];
        [NMFloatWindow keyFLoatWindow].frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2);;
        [NMFloatWindow keyFLoatWindow].rootViewController = vc;
        [[NMFloatWindow keyFLoatWindow] show];
    }else if([data[@"code"]integerValue] == 2){
        UIViewController *currentVC = [[[UIApplication sharedApplication]keyWindow]getCurrentViewController];
        if ([currentVC isKindOfClass:[StartCallVC class]]) {
            StartCallVC *vc = (StartCallVC *)currentVC;
            vc.callDataDic = data;
            [vc handleResponse];
        }
    }
}

// iOS10新加入的回调方法
// 应用在前台收到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    //    completionHandler(UNNotificationPresentationOptionAlert);
}

# pragma mark - PKPushRegistryDelegate
- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type
{
    if ([type isEqualToString:PKPushTypeVoIP])
    {
        [[NIMSDK sharedSDK] updatePushKitToken:credentials.token];
    }
}

// 点击通知进入应用
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [MiPushSDK handleReceiveRemoteNotification:userInfo];
    }
    completionHandler();
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
    }
    NSLog(@"还剩余的未接收的消息数：%d", nLeft);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
