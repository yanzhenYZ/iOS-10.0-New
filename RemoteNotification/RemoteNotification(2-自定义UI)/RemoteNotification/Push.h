//
//  Push.h
//  RemoteNotification
//
//  Created by yanzhen on 16/10/28.
//  Copyright © 2016年 v2tech. All rights reserved.
//

/*
 一：Capalibities - Push Notifications
    Capalibities - Background Modes - remote notifications
 
 二：配置激光推送
 
 三：(必要设置：国际化和附件等)mutable-content = 1
 四：国际化，参考 NotificationService中对title，sunTitle以及body的国际化设置
 
 五： 只有在详情(3DTouch推送内容)里才可以看到自定义UI
 
 六：服务器最好告诉推送的内容是什么类型的
 
 七：**如果想要使用UNNotificationAction必须设置 JPUSHRegisterEntity-categories ---- identifier必须对应自定义UIUNNotificationExtensionCategory字段里的item
 且推送必须设置category**
 
 */
