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
    };
    
    id notificationOpenedBlock = ^(OSNotificationOpenedResult *result) {
        
        // result.action.actionID 获取点击按钮的 actionID
        //        if (result.action.actionID) {
        //            NSLog(@"Action ID: ", result.action.actionID);
        //        }
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
