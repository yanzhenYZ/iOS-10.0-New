//
//  NotificationService.m
//  NotificationsService
//
//  Created by yanzhen on 16/10/31.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "NotificationService.h"
#import "AFNetworking.h"
#import <UIKit/UIKit.h>

#define VIDEOURL @"http://i.snssdk.com/neihan/video/playback/?video_id=b86b223369ce42b98690d6a63386691e&quality=480p&line=0&is_gif=0.mp4"

//2.6M
#define VIDEOURL1 @"http://i.snssdk.com/neihan/video/playback/?video_id=aa352bf8442848c98544de40467012ad&quality=480p&line=0&is_gif=0.mp4"
//198k
#define VIDEOURL2 @"http://i.snssdk.com/neihan/video/playback/?video_id=1cf7004618e642f3b2bc5c74f50eccc7&quality=480p&line=0&is_gif=0.mp4"

static const NSString *ATTACHMENT = @"AttachmentType";

typedef NS_ENUM(NSUInteger, ATTACHMENTTYPE) {
    ATTACHMENT_TEXT,   //纯文字
    ATTACHMENT_IMAGE, //附加字段有图片的URL
    ATTACHMENT_AUDIO, //附加字段有语音的URL
    ATTACHMENT_VIDEO  //附加字段有视频的URL
};

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

/*
 一：(只有包含该字段，才可以使用本content)mutable-content = 1
 
 
 
 */

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString localizedUserNotificationStringForKey:self.bestAttemptContent.title arguments:nil];
    self.bestAttemptContent.subtitle = [NSString localizedUserNotificationStringForKey:self.bestAttemptContent.subtitle arguments:nil];
    self.bestAttemptContent.body = [NSString localizedUserNotificationStringForKey:self.bestAttemptContent.body arguments:nil];
#warning mark - 没有效果
    //启动图片一直没有效果 ？？？？？
    self.bestAttemptContent.launchImageName = @"lan.png";
    
    //设置之后如果没有效果，重启安装一个程序
    self.bestAttemptContent.sound = [UNNotificationSound soundNamed:@"Audio.wav"];
    
    NSString *type = self.bestAttemptContent.userInfo[ATTACHMENT];
    if (type) {
        [self makeAttachment:type.integerValue];
    }
    //image
    //http://picm.photophoto.cn/015/037/003/0370031016.jpg
    
#pragma mark - 音视频需要一定的下载时间，所以需要下载完成之后才能执行下面的方法(苹果对图片还有下载资源做了一定的限制)
    
//    self.contentHandler(self.bestAttemptContent);
}

- (void)makeAttachment:(NSUInteger)type{
    switch (type) {
        case ATTACHMENT_TEXT:
            [self txt];
            break;
        case ATTACHMENT_IMAGE:
            [self image];
            break;
        case ATTACHMENT_AUDIO:
            [self audio];
            break;
        case ATTACHMENT_VIDEO:
            [self video];
            break;
        default:
            break;
    }
}

- (void)txt{
    NSLog(@"TXTTXTTXTTXT");
}

- (void)image{
    NSURL *imageURL = [NSURL URLWithString:self.bestAttemptContent.userInfo[@"image"]];
    NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
    if (imageData) {
        NSString* imageFilePath = [self saveImageDataToSandBox:imageData];
        if (imageFilePath && imageFilePath.length != 0) {
            UNNotificationAttachment* attachment = [UNNotificationAttachment attachmentWithIdentifier:@"PHOTO" URL:[NSURL URLWithString:[@"file://" stringByAppendingString:imageFilePath]] options:nil error:nil];
#warning mark - 如果路径错误 attachment为空
            if (attachment) {
                self.bestAttemptContent.attachments = @[attachment];
            }
            self.contentHandler(self.bestAttemptContent);
        }
    }
}

- (void)video{
    AFURLSessionManager *session = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.bestAttemptContent.userInfo[@"video"]]];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"NSProgress:%lld = %lld",downloadProgress.totalUnitCount,downloadProgress.completedUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *filePath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        return [filePath URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        UNNotificationAttachment* attachment = [UNNotificationAttachment attachmentWithIdentifier:@"VIDEO" URL:[NSURL URLWithString:[@"file://" stringByAppendingString:filePath.path]] options:nil error:nil];
        if (attachment) {
            self.bestAttemptContent.attachments = @[attachment];
        }
        self.contentHandler(self.bestAttemptContent);
    }];
    [downloadTask resume];
}

- (void)audio{
    //用图片做测试
    NSURL *imageURL = [NSURL URLWithString:self.bestAttemptContent.userInfo[@"audio"]];
    NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
    if (imageData) {
        NSString* imageFilePath = [self saveImageDataToSandBox:imageData];
        if (imageFilePath && imageFilePath.length != 0) {
            UNNotificationAttachment* attachment = [UNNotificationAttachment attachmentWithIdentifier:@"AUDIO" URL:[NSURL URLWithString:[@"file://" stringByAppendingString:imageFilePath]] options:nil error:nil];
            if (attachment) {
                self.bestAttemptContent.attachments = @[attachment];
            }
            self.contentHandler(self.bestAttemptContent);
        }
    }
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    NSLog(@"TTTT:TTTT");
    self.contentHandler(self.bestAttemptContent);
}

- (NSString *)saveImageDataToSandBox:(NSData *)imageData {
    NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString* imageDataFilePath = [NSString stringWithFormat:@"%@/notification_image.png", documentPath];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imageDataFilePath]) {
        [fileManager removeItemAtPath:imageDataFilePath
                                error:nil];
    }
    NSError* error = nil;
    [imageData writeToFile:imageDataFilePath options:NSAtomicWrite error:nil];
    if (!error) {
        return imageDataFilePath;
    }
    return nil;
}


@end
