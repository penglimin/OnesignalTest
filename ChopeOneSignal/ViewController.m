//
//  ViewController.m
//  ChopeOneSignal
//
//  Created by 彭利民 on 2018/9/3.
//  Copyright © 2018年 彭利民. All rights reserved.
//

#import "ViewController.h"
#import <OneSignal/OneSignal.h>

@interface ViewController ()<OSPermissionObserver,OSSubscriptionObserver>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *registerNotificationBtn;
@property (weak, nonatomic) IBOutlet UISwitch *subscriptionStatusSwitch;
@property (weak, nonatomic) IBOutlet UILabel *subscriptionStatusLabel;

@end

@implementation ViewController
- (IBAction)sendTagsBtnClick:(id)sender {
    [OneSignal sendTags:@{@"real_name" : @"DuKe"} onSuccess:^(NSDictionary *result) {
        NSLog(@"success!");
    } onFailure:^(NSError *error) {
        NSLog(@"Error - %@", error.localizedDescription);
    }];
}
- (IBAction)getTagsBtnClick:(id)sender {
    
    [OneSignal getTags:^(NSDictionary *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = [NSString stringWithFormat:@"Successfully got tags: \n\n%@", result];
        });
    } onFailure:^(NSError *error) {
        
        NSLog(@"%@",error.localizedDescription);
        
    }];
    
}
- (IBAction)deleteOrUpdateBtnClick:(id)sender {
   
    NSDictionary *exampleTags = @{@"some_key" : @"some_value", @"users_name" : @"Jon", @"finished_level" : @30, @"has_followers" : @(false), @"added_review" : @(false)};
    
    [OneSignal sendTags:exampleTags onSuccess:^(NSDictionary *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = [NSString stringWithFormat: @"Successfully Sent Tags: \n\n%@", result];
        });
    } onFailure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
    
}
- (IBAction)sendNotification1BtnClick:(id)sender {
    OSPermissionSubscriptionState *state = [OneSignal getPermissionSubscriptionState];
    NSString *pushToken = state.subscriptionStatus.pushToken;
    NSString *userId = state.subscriptionStatus.userId;
    
    if (pushToken) {
        NSDictionary *content = @{
                                  @"include_player_ids" : @[userId],
                                  @"contents" : @{@"en" : @"This is a notification's message/body"},
                                  @"headings" : @{@"en" : @"Notification Title"},
                                  @"subtitle" : @{@"en" : @"An English Subtitle"},
                                  // If want to open a url with in-app browser
                                  //"url": "https://google.com",
                                  // If you want to deep link and pass a URL to your webview, use "data" parameter and use the key in the AppDelegate's notificationOpenedBlock
                                  @"data" : @{@"OpenURL" : @"https://imgur.com"},
                                  @"ios_attachments" : @{@"id" : @"https://cdn.pixabay.com/photo/2017/01/16/15/17/hot-air-balloons-1984308_1280.jpg"},
                                  @"ios_badgeType" : @"Increase",
                                  @"ios_badgeCount" : @1
                                  };
        
        [OneSignal postNotification:content onSuccess:^(NSDictionary *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = [NSString stringWithFormat:@"Sent notification with payload: \n\n%@", content];
            });
        } onFailure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    } else {
        NSLog(@"Could not send push notification: current user does not have a push token");
    }
    
}
- (IBAction)sendNotification2BtnClick:(id)sender {
    
    OSPermissionSubscriptionState *state = [OneSignal getPermissionSubscriptionState];
    NSString *pushToken = state.subscriptionStatus.pushToken;
    NSString *userId = state.subscriptionStatus.userId;
    
    if (pushToken) {
        NSDictionary *content = @{
                                  @"include_player_ids" : @[userId],
                                  @"headings" : @{@"en" : @"Congrats {{username}}!"},
                                  @"contents" : @{@"en" : @"You finished level {{ finished_level | default: '1'}}! Let's see if you can do more."},
                                  @"buttons" : @[@{@"id" : @"id1", @"text" : @"green"}, @{@"id" : @"id2", @"text" : @"red"}],
                                  @"data" : @{@"OpenURL" : @"https://www.arstechnica.com"}
                                  };
        
        [OneSignal postNotification:content onSuccess:^(NSDictionary *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = [NSString stringWithFormat:@"Successfully sent notification with payload: \n\n%@", content];
            });
        } onFailure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    } else {
        NSLog(@"Could not send push notification: current user does not have a push token");
    }
}

- (IBAction)notification3BtnClick:(id)sender {
    OSPermissionSubscriptionState *state = [OneSignal getPermissionSubscriptionState];
    NSString *pushToken = state.subscriptionStatus.pushToken;
    NSString *userId = state.subscriptionStatus.userId;
    
    if (pushToken) {
        NSDictionary *content = @{
                                  @"include_player_ids" : @[userId],
                                  @"headings" : @{@"en" : @"Congrats {{username}}!"},
                                  @"contents" : @{@"en" : @"You finished level {{ finished_level | default: '1'}}! Let's see if you can do more."},
//                                  @"buttons" : @[@{@"id" : @"id1", @"text" : @"green"}, @{@"id" : @"id2", @"text" : @"red"}],
                                  @"data" : @{@"OpenURL" : @"https://www.arstechnica.com"}
                                  };
        
        [OneSignal postNotification:content onSuccess:^(NSDictionary *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = [NSString stringWithFormat:@"Successfully sent notification with payload: \n\n%@", content];
            });
        } onFailure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    } else {
        NSLog(@"Could not send push notification: current user does not have a push token");
    }
}


- (IBAction)notification4BtnClick:(id)sender {
    
    OSPermissionSubscriptionState *state = [OneSignal getPermissionSubscriptionState];
    NSString *pushToken = state.subscriptionStatus.pushToken;
    NSString *userId = state.subscriptionStatus.userId;
    
    if (pushToken) {
        NSDictionary *content = @{
                                  @"include_player_ids" : @[userId],
//                                  @"headings" : @{@"en" : @"Congrats {{username}}!"},
//                                  @"contents" : @{@"en" : @"You finished level {{ finished_level | default: '1'}}! Let's see if you can do more."},
//                                  @"mutable_content":@"1",
                                  @"content_available":@"1",

                                  //                                  @"buttons" : @[@{@"id" : @"id1", @"text" : @"green"}, @{@"id" : @"id2", @"text" : @"red"}],
                                  @"data" : @{@"OpenURL" : @"https://www.arstechnica.com"}
                                  };
        
        [OneSignal postNotification:content onSuccess:^(NSDictionary *result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = [NSString stringWithFormat:@"Successfully sent notification with payload: \n\n%@", content];
            });
        } onFailure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    } else {
        NSLog(@"Could not send push notification: current user does not have a push token");
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([OneSignal getPermissionSubscriptionState].subscriptionStatus.subscribed) {
        
        self.registerNotificationBtn.backgroundColor = [UIColor greenColor];
    self.registerNotificationBtn.userInteractionEnabled = NO;
        
        self.subscriptionStatusSwitch.on = YES;
        self.subscriptionStatusLabel.text = @"Set Subscription ON";

    }else{
        
        self.registerNotificationBtn.backgroundColor = [UIColor redColor];
        
        self.subscriptionStatusSwitch.on = NO;
        self.subscriptionStatusLabel.text = @"Set Subscription OFF";

    }
    
    if ([OneSignal getPermissionSubscriptionState].permissionStatus.status == OSNotificationPermissionAuthorized) {
        
        self.registerNotificationBtn.userInteractionEnabled = NO;
        
        
    }else{
        
        self.registerNotificationBtn.userInteractionEnabled = YES;
        
        self.registerNotificationBtn.backgroundColor = [UIColor redColor];
        self.subscriptionStatusSwitch.userInteractionEnabled = NO;

    }
    
    // 系统通知
    [OneSignal addPermissionObserver:self];
    // 通知开启
    [OneSignal addSubscriptionObserver:self];


}

#pragma mark OSPermissionStateChanges Delegate Method
-(void)onOSPermissionChanged:(OSPermissionStateChanges *)stateChanges {
    if (stateChanges.from.status == OSNotificationPermissionAuthorized) {
        if (stateChanges.to.status == OSNotificationPermissionDenied)
        {
            self.registerNotificationBtn.backgroundColor = [UIColor redColor];
 self.registerNotificationBtn.userInteractionEnabled = YES;
            self.subscriptionStatusSwitch.userInteractionEnabled = NO;
        }
    } else
    {
        
        if (self.subscriptionStatusSwitch.isOn)
        {
            self.registerNotificationBtn.backgroundColor = [UIColor greenColor];

        }else
        {
            self.registerNotificationBtn.backgroundColor = [UIColor redColor];

        }
        self.registerNotificationBtn.userInteractionEnabled = NO;
        self.subscriptionStatusSwitch.userInteractionEnabled = YES;
    }
}
- (void)displaySettingsNotification {
    UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Tapped Settings");
        if ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [self displayAlert:@"Settings" withMessage:@"Please turn on notifications by going to Settings > Notifications > Allow Notifications" actions:@[settings, cancel]];
}

- (void)displayAlert:(NSString *)title withMessage:(NSString *)message actions:(NSArray<UIAlertAction *>*)actions {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        if (!actions || actions.count == 0) {
            [controller addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil]];
        } else {
            for (UIAlertAction *action in actions) {
                [controller addAction:action];
            }
        }
        [self presentViewController:controller animated:true completion:nil];
    });
}
- (IBAction)registerButtonPressed:(UIButton *)sender {
    OSPermissionSubscriptionState *state = [OneSignal getPermissionSubscriptionState];
    
    if (!state.permissionStatus.hasPrompted) {
        [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
            NSLog(@"User %@ Notifications Permission", accepted ? @"Accepted" : @"Denied");
        }];
    } else {
        [self displaySettingsNotification];
    }
}
#pragma mark OSSubscriptionStateChanges Delegate Method
-(void)onOSSubscriptionChanged:(OSSubscriptionStateChanges *)stateChanges {
    if (stateChanges.from.subscribed &&  !stateChanges.to.subscribed) {
        self.subscriptionStatusSwitch.on = false;
        self.subscriptionStatusLabel.text = @"Set Subscription OFF";
        self.registerNotificationBtn.backgroundColor = [UIColor redColor];
        
    } else if (!stateChanges.from.subscribed && stateChanges.to.subscribed) {
        self.subscriptionStatusSwitch.on = true;
        self.subscriptionStatusLabel.text = @"Set Subscription ON";
        self.registerNotificationBtn.backgroundColor = [UIColor greenColor];
    }
}

- (IBAction)subscriptionSwitchValueChanged:(UISwitch *)sender {
    if (sender.isOn) {
        // 开启订阅通知
        [OneSignal setSubscription:true];
    } else {
        // 关闭订阅通知
        [OneSignal setSubscription:false];
    }
}

@end
