//
//  NotificationViewController.m
//  Local
//
//  Created by yanzhen on 16/10/28.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) UIImageView *testImageView;

@end

@implementation NotificationViewController

/*
 定义好了通知UI模板，若要进行使用，还需要再Notification Content扩展中的info.plist文件的NSExtension字典的NSExtensionAttributes字典里进行一些配置，正常情况下，开发者需要进行配置的键有3个，分别如下：
 
 
 1  UNNotificationExtensionCategory                 **设置模板的categoryId，用于与UNNotificationContent对应。** (重要)
    可以设置成数组，这样这一对应多个categoryId
 
 2  UNNotificationExtensionInitialContentSizeRatio  设置自定义通知界面的高度与宽度的比，宽度为固定宽度，在不同设备上有差别，开发者需要根据宽度计算出高度进行设置，系统根据这个比值来计算通知界面的高度。
 
 3  UNNotificationExtensionDefaultContentHidden     是有隐藏系统默认的通知界面。
 */

/*
 不可交互
 
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
#pragma mark - 设置View的大小
//    self.preferredContentSize = CGSizeMake(0, 50);
    
    
    
    _testImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _testImageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_testImageView];
    
}

- (void)didReceiveNotification:(UNNotification *)notification {
    NSLog(@"NNNNNNNN-1  ---%@",notification.request.content.userInfo);
//    NSDictionary *dict = notification.request.content.userInfo;
//    if (dict[@"IMAGE1"]) {
//        NSLog(@"TTTT:===1");
//        
//    }
  
    
    //本地推送
#warning mark - 图片存在一个特殊路径下，如果想要使用必须告诉iOS我们需要使用它，并且在使用完毕之后告诉系统我们使用完毕了。
    //startAccessingSecurityScopedResource
    //stopAccessingSecurityScopedResource
    
    
    if (notification.request.content.attachments.count > 0) {
        UNNotificationAttachment *attschment = notification.request.content.attachments[0];
        NSLog(@"UNNotificationAttachment == :%d",[[NSFileManager defaultManager] fileExistsAtPath:attschment.URL.path]);
        
        
        NSLog(@"UNNotificationAttachment == :%d",[[NSFileManager defaultManager] fileExistsAtPath:attschment.URL.absoluteString]);
        if (attschment.URL.startAccessingSecurityScopedResource) {
            
            NSData *imageData = [NSData dataWithContentsOfFile:attschment.URL.path];
            _testImageView.image = [UIImage imageWithData:imageData];

            [attschment.URL stopAccessingSecurityScopedResource];
        }
        
    }
    
    
}

// 处理---UNNotificationAction
-(void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion{
    NSLog(@"NNNNNNNN-2 --");
    
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
        UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse *)response;
        NSLog(@"TTTT:%@",textResponse.userText);
    }
    
    completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
}



@end
