//
//  LocalNotifitions.m
//  UserNotifications
//
//  Created by yanzhen on 16/10/27.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "LocalNotifitions.h"
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation LocalNotifitions

+ (void)sendNotification{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    // 创建一个本地通知
    UNMutableNotificationContent *content_1 = [[UNMutableNotificationContent alloc] init];
    // 主标题
    content_1.title = [NSString localizedUserNotificationStringForKey:@"推送" arguments:nil];
    // 副标题
    content_1.subtitle = [NSString localizedUserNotificationStringForKey:@"本地推送" arguments:nil];
    content_1.badge = [NSNumber numberWithInteger:3];
    
    
    
    
#pragma mark - 设置通知附件内容
    /*   options
     
    UNNotificationAttachmentOptionsTypeHintKey              //提供附件的类型,可不传
    @{UNNotificationAttachmentOptionsTypeHintKey: (__bridge id)kUTTypeImage}
     
    UNNotificationAttachmentOptionsThumbnailHiddenKey       //是否隐藏缩略图
    UNNotificationAttachmentOptionsThumbnailClippingRectKey //截取图片的部分作为缩略图
    @{UNNotificationAttachmentOptionsThumbnailClippingRectKey: (__bridge id _Nullable)CGRectCreateDictionaryRepresentation(CGRectMake(0.5, 0.5, 0.25 ,0.25))
    //参考http://blog.csdn.net/baidu_25743639/article/details/52839707
     
    UNNotificationAttachmentOptionsThumbnailTimeKey          //选取视频的某一秒作为缩略图
    
    */
    //图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lan" ofType:@"png"];
    NSError  *error;
    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att" URL:[NSURL fileURLWithPath:path] options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey: (__bridge id _Nullable)CGRectCreateDictionaryRepresentation(CGRectMake(0.5, 0.5, 0.25 ,0.25))} error:&error];
    if (error) {
        NSLog(@"attachment error %@", error);
    }
    
//    //
//    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"page" ofType:@"png"];
//    NSError  *error1;
//    UNNotificationAttachment *att1 = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path1] options:nil error:&error1];
//    if (error1) {
//        NSLog(@"attachment error %@", error1);
//    }
    
    
    //音频 ---- 可以直接播放
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Audio" ofType:@"wav"];
//    NSError  *error;
//    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
//    if (error) {
//        NSLog(@"attachment error %@", error);
//    }
    
    //视频 ---- 可以直接播放
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"push" ofType:@"mp4"];
//    NSError  *error;
//    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att" URL:[NSURL fileURLWithPath:path] options:@{UNNotificationAttachmentOptionsThumbnailTimeKey: @10} error:&error];
//    if (error) {
//        NSLog(@"attachment error %@", error);
//    }

#warning amrk - 多个附件只在自定义UI时可以使用
    content_1.attachments = @[att];
    
#warning mark - 没有效果，没有解决办法???
    //没有效果 ？？？
    //有说是图片下拉展示的图片，但是去掉效果不变
    content_1.launchImageName = @"page";
    
    
    content_1.body = [NSString localizedUserNotificationStringForKey:@"点击查看详情" arguments:nil];
    
    content_1.sound = [UNNotificationSound soundNamed:@"Audio.wav"];
    
    /*
     UNTimeIntervalNotificationTrigger ：一定时间后触发
     UNCalendarNotificationTrigger ： 在某月某日某时触发
     UNLocationNotificationTrigger ： 在用户进入或是离开某个区域时触发
     */
    // 设置触发时间
#warning mark - 如果想要重复提醒，间隔时间要大于60s
    UNTimeIntervalNotificationTrigger *trigger_1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    
    //    UNLocationNotificationTrigger
    //    CLRegion
    
    //    NSDateComponents *components = [[NSDateComponents alloc] init];
    //    components.year = 2016;
    //    components.month = 10;
    //    components.day = 27;
    //    components.hour = 10;
    //    components.minute = 35;
    //    components.second = 30;
    //    UNCalendarNotificationTrigger *trigger_2 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];
    
    
    
    
    content_1.userInfo = @{@"user":@"80",@"IMAGE1":@"lan",@"IMAGE2":@"page"};
    content_1.categoryIdentifier = @"----ca";
    
    
    // 创建一个发送请求
    UNNotificationRequest *request_1 = [UNNotificationRequest requestWithIdentifier:@"my_notification" content:content_1 trigger:trigger_1];
    [center addNotificationRequest:request_1 withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Error:%@",error);
    }];

}

+ (void)removePendingNotification{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    //移除没有发出的通知
    [center removePendingNotificationRequestsWithIdentifiers:@[@"my_notification"]];
    //移除全部没有发出的通知
//    [center removeAllPendingNotificationRequests];
}

+ (void)removeDeliveredNotifications{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    //移除已经展示过的通知
    [center removeDeliveredNotificationsWithIdentifiers:@[@"my_notification"]];
    //移除全部展示过的通知
//    [center removeAllDeliveredNotifications];
}

+ (void)getPendingNotification{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
        NSLog(@"SSSS:%@",requests);
    }];
}

+ (void)getDeliveredNotifications{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
        NSLog(@"SSSS:%@",notifications);
    }];
}


//支持3DTouch的使用3DTouch,不支持侧滑
+ (void)category{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    // 创建一个本地通知
    UNMutableNotificationContent *content_1 = [[UNMutableNotificationContent alloc] init];
    content_1.title = [NSString localizedUserNotificationStringForKey:@"推送" arguments:nil];
    content_1.subtitle = [NSString localizedUserNotificationStringForKey:@"本地推送" arguments:nil];
    content_1.badge = [NSNumber numberWithInteger:3];
    content_1.body = [NSString localizedUserNotificationStringForKey:@"点击查看详情" arguments:nil];
    content_1.sound = [UNNotificationSound defaultSound];
    // 设置触发时间
    UNTimeIntervalNotificationTrigger *trigger_1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    content_1.userInfo = @{@"Local":@"YES"};
    
    
    //图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lan" ofType:@"png"];
    NSError  *error;
    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att" URL:[NSURL fileURLWithPath:path] options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey: (__bridge id _Nullable)CGRectCreateDictionaryRepresentation(CGRectMake(0.5, 0.5, 0.25 ,0.25))} error:&error];
    if (error) {
        NSLog(@"attachment error %@", error);
    }

    content_1.attachments = @[att];
    
    
#pragma mark - category
    /*
     UNNotificationActionOptionAuthenticationRequired = (1 << 0),
     UNNotificationActionOptionDestructive = (1 << 1), 取消
     UNNotificationActionOptionForeground = (1 << 2), 启动程序
     */
    
    //点击之后会有输入框 --
    //国际化有点小问题 ？？？？？？？
    UNTextInputNotificationAction *textAction = [UNTextInputNotificationAction actionWithIdentifier:@"text_action" title:NSLocalizedString(@"回复", nil) options:UNNotificationActionOptionAuthenticationRequired textInputButtonTitle:[NSString localizedUserNotificationStringForKey:@"发送" arguments:nil] textInputPlaceholder:NSLocalizedString(@"默认文字", nil)];
    
    UNNotificationAction *action_1 = [UNNotificationAction actionWithIdentifier:@"test_action" title:[NSString localizedUserNotificationStringForKey:@"测试" arguments:nil] options:UNNotificationActionOptionForeground];
    
    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:@"cancel_action" title:[NSString localizedUserNotificationStringForKey:@"取消" arguments:nil] options:UNNotificationActionOptionDestructive];
    
    
    

    /*
     UNNotificationCategoryOptionNone = (0),
     UNNotificationCategoryOptionCustomDismissAction = (1 << 0),
     UNNotificationCategoryOptionAllowInCarPlay = (2 << 0),
     */
    
    //如果自定义UI一定注意Identifier和自定义UI plist文件中UNNotificationExtensionCategory一个保持一致
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"----ca" actions:@[textAction,action_1,action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
//    UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"my_category" actions:@[textAction,action] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    
    NSSet *setting = [NSSet setWithObjects:category, nil];
    [center setNotificationCategories:setting];
    
    //在创建 UNNotificationContent 时把 categoryIdentifier 设置为需要的 category id 即可：
    content_1.categoryIdentifier = @"----ca";
#pragma mark - 远程推送也可以使用 category，只需要在 payload 中添加 category 字段，并指定预先定义的 category id 就可以了

    // 创建一个发送请求
    UNNotificationRequest *request_1 = [UNNotificationRequest requestWithIdentifier:@"my_notification" content:content_1 trigger:trigger_1];
    [center addNotificationRequest:request_1 withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Error:%@",error);
    }];

}















-(void)test{
    /*
     identifier：行为标识符，用于调用代理方法时识别是哪种行为。
     title：行为名称。
     UIUserNotificationActivationMode：即行为是否打开APP。
     authenticationRequired：是否需要解锁。
     destructive：这个决定按钮显示颜色，YES的话按钮会是红色。
     behavior：点击按钮文字输入，是否弹出键盘
     */
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"策略1行为1" options:UNNotificationActionOptionForeground];
    //iOS9实现方法
    //     UIMutableUserNotificationAction * action1 = [[UIMutableUserNotificationAction alloc] init];
    //     action1.identifier = @"action1";
    //     action1.title=@"策略1行为1";
    //     action1.activationMode = UIUserNotificationActivationModeForeground;
    //     action1.destructive = YES;
    
    UNTextInputNotificationAction *action2 = [UNTextInputNotificationAction actionWithIdentifier:@"action2" title:@"策略1行为2" options:UNNotificationActionOptionDestructive textInputButtonTitle:@"textInputButtonTitle" textInputPlaceholder:@"textInputPlaceholder"];
    /*iOS9实现方法
     UIMutableUserNotificationAction * action2 = [[UIMutableUserNotificationAction alloc] init];
     action2.identifier = @"action2";
     action2.title=@"策略1行为2";
     action2.activationMode = UIUserNotificationActivationModeBackground;
     action2.authenticationRequired = NO;
     action2.destructive = NO;
     action2.behavior = UIUserNotificationActionBehaviorTextInput;//点击按钮文字输入，是否弹出键盘
     */
    
    UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"Category1" actions:@[action2,action1] intentIdentifiers:@[@"action1",@"action2"] options:UNNotificationCategoryOptionCustomDismissAction];
    //        UIMutableUserNotificationCategory * category1 = [[UIMutableUserNotificationCategory alloc] init];
    //        category1.identifier = @"Category1";
    //        [category1 setActions:@[action2,action1] forContext:(UIUserNotificationActionContextDefault)];
    
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"策略2行为1" options:UNNotificationActionOptionForeground];
    //        UIMutableUserNotificationAction * action3 = [[UIMutableUserNotificationAction alloc] init];
    //        action3.identifier = @"action3";
    //        action3.title=@"策略2行为1";
    //        action3.activationMode = UIUserNotificationActivationModeForeground;
    //        action3.destructive = YES;
    
    UNNotificationAction *action4 = [UNNotificationAction actionWithIdentifier:@"action4" title:@"策略2行为2" options:UNNotificationActionOptionForeground];
    //        UIMutableUserNotificationAction * action4 = [[UIMutableUserNotificationAction alloc] init];
    //        action4.identifier = @"action4";
    //        action4.title=@"策略2行为2";
    //        action4.activationMode = UIUserNotificationActivationModeBackground;
    //        action4.authenticationRequired = NO;
    //        action4.destructive = NO;
    
    UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"Category2" actions:@[action3,action4] intentIdentifiers:@[@"action3",@"action4"] options:UNNotificationCategoryOptionCustomDismissAction];
    
    //        UIMutableUserNotificationCategory * category2 = [[UIMutableUserNotificationCategory alloc] init];
    //        category2.identifier = @"Category2";
    //        [category2 setActions:@[action4,action3] forContext:(UIUserNotificationActionContextDefault)];
    
    
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category1,category2, nil]];
    
    
    
    
    
    /*iOS9实现方法
     UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects: category1,category2, nil]];
     
     [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
     */

}

@end
