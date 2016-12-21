//
//  UserNotification.m
//  LocalNotifications
//
//  Created by yanzhen on 16/10/27.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "UserNotification.h"
#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface UserNotification ()<UNUserNotificationCenterDelegate>

@end

@implementation UserNotification

- (void)requestAuthorization{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //必须要写这句话，不然无法会的deviceToken
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionBadge  | UNAuthorizationOptionSound | UNAuthorizationOptionAlert;
    
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //用户同意推送
            NSLog(@"TTTT:YES");
        }else{
            //第一次启动表示用户不同意推送
            //以后可以提示用户打开推送
            NSLog(@"TTTT:NO");
        }
    }];
    
    //    [center setNotificationCategories:]
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
            //系统给出提示时，用户还没有做出选择
            NSLog(@"UNAuthorizationStatusNotDetermined");
        }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
            //用户不同意接收通知
            NSLog(@"UNAuthorizationStatusDenied");
        }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
            //用户同意接收通知
            NSLog(@"UNAuthorizationStatusAuthorized");
        }
    }];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
}

#pragma mark - UNUserNotificationCenterDelegate
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    UNNotificationPresentationOptions options = UNNotificationPresentationOptionBadge  | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert;
    
    completionHandler(options);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSLog(@"userInfo--%@",response.notification.request.content.userInfo);
    NSLog(@"identifier--%@",response.notification.request.identifier);
    completionHandler();

#warning mark - 自定义UI时可以使用特定路径下推送的资源 这里不可以使用
    //猜想：本地推送的附件，存在于自身的Bundle之中，不需要的特定目录下去取
    
    //startAccessingSecurityScopedResource
    //stopAccessingSecurityScopedResource
    //图片存在一个特殊路径下，如果想要使用必须告诉iOS我们需要使用它，并且在使用完毕之后告诉系统我们使用完毕了。
    //视频数据
    UNNotificationAttachment *attachment = response.notification.request.content.attachments[0];
    
    //音频数据
    
//    UNNotificationAttachment *attachment = response.notification.request.content.attachments[0];
//    NSLog(@"TTTT:%@",attachment);

    /* UI
    /var/mobile/Library/SpringBoard/PushStore/Attachments/com.v2tech.LocalNotifications/9d25ebaeedc71b7343cadc66c350cb1e9893a042.png
     
     /var/mobile/Library/SpringBoard/PushStore/Attachments/com.v2tech.LocalNotifications/9d25ebaeedc71b7343cadc66c350cb1e9893a042.png
     */
    
    
    
    
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    ViewController *vc = (ViewController *)keyWindow.rootViewController;
    if (attachment.URL.startAccessingSecurityScopedResource) {
        
        NSData *imageData = [NSData dataWithContentsOfFile:attachment.URL.path];
        NSLog(@"TTTT:%@",imageData);
        vc.imageView.image = [UIImage imageWithData:imageData];
        
        [attachment.URL stopAccessingSecurityScopedResource];
    }
    
    
#pragma mark - 带有category
    [center getNotificationCategoriesWithCompletionHandler:^(NSSet<UNNotificationCategory *> * _Nonnull categories) {
        for (UNNotificationCategory *category in categories) {
            if ([category.identifier isEqualToString:@"my_category"] && [response.notification.request.content.categoryIdentifier isEqualToString:@"my_category"]) {
                for (UNNotificationAction *action in category.actions) {
                    if ([action.identifier isEqualToString:@"text_action"]) {
                        if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
                            UNTextInputNotificationResponse *textRespose = (UNTextInputNotificationResponse *)response;
                            //获取用户输入的文字
                            //获取用户输入的文字 用户输入文字但是不启动APP,这里也可以执行
                            NSLog(@"TTTT:%@",textRespose.userText);
                        }
                    }
                }
            }
        }
    }];
}


@end
