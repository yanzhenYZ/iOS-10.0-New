//
//  LocalNotifitions.h
//  UserNotifications
//
//  Created by yanzhen on 16/10/27.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotifitions : NSObject

+ (void)sendNotification;
+ (void)removePendingNotification;
+ (void)removeDeliveredNotifications;
+ (void)getPendingNotification;
+ (void)getDeliveredNotifications;

+ (void)category;

@end
