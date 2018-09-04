//
//  AppDelegate.m
//  ChopeOneSignal
//
//  Created by 彭利民 on 2018/9/3.
//  Copyright © 2018年 彭利民. All rights reserved.
//

#import "AppDelegate.h"
#import <OneSignal/OneSignal.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setUpOneSignalSetting:launchOptions];
    
    return YES;
}

- (void)setUpOneSignalSetting:(NSDictionary *)launchOptions
{

    id notificationReceiverBlock = ^(OSNotification *notification) {
        NSLog(@"Received Notification - %@", notification.payload.notificationID);
        
        // 接受silent-notifications
        // 静默消息注意三点： 发送背景通知
//        1. Notification Service Extension. See Step 1 of our iOS Native SDK setup guide to add one to your Xcode project. This will only fire for iOS 10+.
//        2. Add a notification message or API contents parameter.
        // 不能添加content title 以及 subtitle等。不然通知就是可见的
//        3. Enabling Mutable Content in the Dashboard > New Message > Options section or the API mutable_content parameter
        
        // 发送无声通知
//        静音通知专为原生iOS和Android应用而设计。您可以使用本机代码在非本机应用程序上实现它们。
//
//        iOS - 只需启用content_available = true
//        这将允许您省略消息正文以防止显示通知，以便您可以发送所需的任何数据。

//        iOS静音通知仅在应用程序处于打开状态且在后台或前台时才有效。
//        如果应用程序已强制退出或“刷掉”，您可以通过向通知添加内容来“唤醒”。


        

    };
    
    id notificationOpenedBlock = ^(OSNotificationOpenedResult *result) {
        
        
        // result.action.actionID 获取点击按钮的 actionID
        if (result.action.actionID) {
            
            if ([result.action.actionID isEqualToString:@"comment"]) {
                // 点击了评论
            }
            
            if ([result.action.actionID isEqualToString:@"join"]) {
                // 点击了加入
            }
            
        }
        // This block gets called when the user reacts to a notification received
        OSNotificationPayload* payload = result.notification.payload;
        
        NSString* messageTitle = @"OneSignal Example";
        NSString* fullMessage = [payload.body copy];
        
        if (payload.additionalData) {
            
            if(payload.title)
                messageTitle = payload.title;
            
            NSDictionary* additionalData = payload.additionalData;
            
            if (additionalData[@"actionSelected"])
                fullMessage = [fullMessage stringByAppendingString:[NSString stringWithFormat:@"\nPressed ButtonId:%@", additionalData[@"actionSelected"]]];
        }
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:messageTitle
                                                            message:fullMessage
                                                           delegate:self
                                                  cancelButtonTitle:@"Close"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
    };
    
    id onesignalInitSettings = @{kOSSettingsKeyAutoPrompt : @YES};
    
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:@"ed7f9896-ec0b-43eb-a850-c1b05b3fd9eb"
          handleNotificationReceived:notificationReceiverBlock
            handleNotificationAction:notificationOpenedBlock
                            settings:onesignalInitSettings];
    
    
    [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
        // 用户点击同意接受通知时，会调到这个block里。
        // 每次启动的时候都会进来，检测通知是否开启。如果没有开启可以做一些其他的操作。
        NSLog(@"User accepted notifications: %d", accepted);
    }];
    
}

@end
