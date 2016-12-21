//
//  NotificationViewController.m
//  Notifications
//
//  Created by yanzhen on 16/10/31.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>
@property (nonatomic, strong) UIImageView *testImageView;
@property (nonatomic, strong) UILabel *bodyLabel;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
    _testImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _testImageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_testImageView];
    
    _bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    _bodyLabel.textColor = [UIColor redColor];
    _bodyLabel.backgroundColor = [UIColor yellowColor];
    _bodyLabel.font = [UIFont systemFontOfSize:17];
    _bodyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_bodyLabel];
    
}

- (void)didReceiveNotification:(UNNotification *)notification {
    
    //调试的时候没有打印
//    NSLog(@"TTTT:%@",<#name#>);
    
    if (notification.request.content.attachments.count > 0) {
        UNNotificationAttachment *attschment = notification.request.content.attachments[0];
        if ([attschment.identifier isEqualToString:@"PHOTO"]){
            if (attschment.URL.startAccessingSecurityScopedResource) {
                NSData *imageData = [NSData dataWithContentsOfFile:attschment.URL.path];
                _testImageView.image = [UIImage imageWithData:imageData];
                [attschment.URL stopAccessingSecurityScopedResource];
            }
        }else if ([attschment.identifier isEqualToString:@"AUDIO"]){
            //没有用音频数据做测试
            _testImageView.image = [UIImage imageNamed:@"lan"];
        }else if ([attschment.identifier isEqualToString:@"VIDEO"]){
            //没有用视频数据做测试
            _testImageView.backgroundColor = [UIColor yellowColor];
        }
        
    }else{
        _bodyLabel.text = notification.request.content.body;
        _testImageView.hidden = YES;
        self.preferredContentSize = CGSizeMake(0, 100);
    }
}

-(void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion{
    if ([response isKindOfClass:[UNTextInputNotificationResponse class]]) {
        UNTextInputNotificationResponse *textResponse = (UNTextInputNotificationResponse *)response;
        //在这里不能打印
        self.bodyLabel.text = textResponse.userText;
    }
    completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
}
@end
