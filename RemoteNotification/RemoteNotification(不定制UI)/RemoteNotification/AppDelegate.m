//
//  AppDelegate.m
//  RemoteNotification
//
//  Created by yanzhen on 16/10/31.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
//46dfa2a4661af221986c16c4
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        
        entity.categories = [self categories];
        
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    //    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) { //可以添加 定义categories
    //        [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert];
    //    }
    
    [JPUSHService setupWithOption:launchOptions appKey:@"46dfa2a4661af221986c16c4"
                          channel:@"Publish channel"
                 apsForProduction:false];
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];

    
    return YES;
}

- (NSSet *)categories{
    UNTextInputNotificationAction *textAction = [UNTextInputNotificationAction actionWithIdentifier:@"text_action" title:NSLocalizedString(@"回复", nil) options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:[NSString localizedUserNotificationStringForKey:@"发送" arguments:nil] textInputPlaceholder:NSLocalizedString(@"默认文字", nil)];
    
    UNNotificationAction *action_1 = [UNNotificationAction actionWithIdentifier:@"test_action" title:[NSString localizedUserNotificationStringForKey:@"测试" arguments:nil] options:UNNotificationActionOptionForeground];
    
    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"cancel_action" title:[NSString localizedUserNotificationStringForKey:@"取消" arguments:nil] options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"NotificationCategory" actions:@[textAction,action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"myNotificationCategory" actions:@[textAction,action_1,action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    return [NSSet setWithObjects:category,category1, nil];
}


#pragma mark - JPUSHRegisterDelegate
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        //
        //        [rootViewController addNotificationCount];
        NSLog(@"iOS10 前台收到通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
#pragma mark - 推送
    //附加字段包含在userInfo中
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //        NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        //        [rootViewController addNotificationCount];
        NSLog(@"iOS10 收到通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();
}
#pragma mark - deviceToken
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
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
