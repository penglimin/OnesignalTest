//
//  AppDelegate.m
//  ChopeOneSignal
//
//  Created by 彭利民 on 2018/9/3.
//  Copyright © 2018年 彭利民. All rights reserved.
//

#import "AppDelegate.h"
#import <OneSignal/OneSignal.h>
#import "RedViewController.h"
#import "GreenViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setUpOneSignalSetting:launchOptions];
    
    return YES;
}

- (void)setUpOneSignalSetting:(NSDictionary *)launchOptions
{

    // (Optional) - Create block the will fire when a notification is recieved while the app is in focus.
    id notificationRecievedBlock = ^(OSNotification *notification) {
        NSLog(@"Received Notification - %@", notification.payload.notificationID);
    };
    
    // (Optional) - Create block that will fire when a notification is tapped on.
    id notificationOpenedBlock = ^(OSNotificationOpenedResult *result) {
        OSNotificationPayload* payload = result.notification.payload;
        
        NSString* messageTitle = @"OneSignal Example";
        NSString* fullMessage = [payload.body copy];
        
        if (payload.additionalData) {
            
            if (payload.title)
                messageTitle = payload.title;
            
            if (result.action.actionID) {
                fullMessage = [fullMessage stringByAppendingString:[NSString stringWithFormat:@"\nPressed ButtonId:%@", result.action.actionID]];
                
                UIViewController *vc;
                
                if ([result.action.actionID isEqualToString: @"id2"]) {
                    RedViewController *redVC = [[RedViewController alloc] init];
                    
                    if (payload.additionalData[@"OpenURL"])
                        redVC.receivedUrl = [NSURL URLWithString:(NSString *)payload.additionalData[@"OpenURL"]];
                    
                    vc = redVC;
                } else if ([result.action.actionID isEqualToString:@"id1"]) {
//                    vc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"greenVC"];
                    
                    GreenViewController *greenVC = [[GreenViewController alloc] init];
                    
                    if (payload.additionalData[@"OpenURL"])
                        greenVC.receivedUrl = [NSURL URLWithString:(NSString *)payload.additionalData[@"OpenURL"]];
                    
                    vc = greenVC;
                }
                
                [self.window.rootViewController presentViewController:vc animated:true completion:nil];
            }
            
            
        }
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Push Notification" message:fullMessage preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil]];
        
        [self.window.rootViewController presentViewController:controller animated:true completion:nil];
        
    };
    
    // (Optional) - Configuration options for OneSignal settings.
    id oneSignalSetting = @{kOSSettingsKeyInFocusDisplayOption : @(OSNotificationDisplayTypeNotification), kOSSettingsKeyAutoPrompt : @YES};
    
    
    
    // (REQUIRED) - Initializes OneSignal
//    [OneSignal initWithLaunchOptions:launchOptions
//                               appId:@"f79818a7-cdd0-42b2-bf83-affeeb67bba6"
//          handleNotificationReceived:notificationRecievedBlock
//            handleNotificationAction:notificationOpenedBlock
//                            settings:oneSignalSetting];
    
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:@"ed7f9896-ec0b-43eb-a850-c1b05b3fd9eb"
          handleNotificationReceived:notificationRecievedBlock
            handleNotificationAction:notificationOpenedBlock
                            settings:oneSignalSetting];
    
    
    [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
        // 用户点击同意接受通知时，会调到这个block里。
        // 每次启动的时候都会进来，检测通知是否开启。如果没有开启可以做一些其他的操作。
        NSLog(@"User accepted notifications: %d", accepted);
    }];
    
}

@end
