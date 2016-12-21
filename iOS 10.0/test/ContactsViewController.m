//
//  ContactsViewController.m
//  test
//
//  Created by yanzhen on 16/10/21.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ContactsViewController.h"
#import <Speech/Speech.h>

@interface ContactsViewController ()
@property (nonatomic, strong) UIViewPropertyAnimator *viewPro;
@property (nonatomic, strong) UIView *testView;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithDisplayP3Red:1.0 green:155/255.0 blue:13/255.0 alpha:1.0];
    
    
    
   
}
#pragma mark - openURL
- (void)openURL1{
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        NSLog(@"TTTT:%d",success);
    }];
}

- (void)openURL2{
    NSURL *url = [NSURL URLWithString:@"weixin://session?news"];
    [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @NO} completionHandler:^(BOOL success) {
        NSLog(@"TTTT:%d",success);
    }];
}



#pragma mark - UIViewPropertyAnimator
- (void)viewAnimation{
    _testView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 100, 100)];
    _testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_testView];
    
    //    _viewPro = [UIViewPropertyAnimator runningPropertyAnimatorWithDuration:2.5 delay:1.5 options:UIViewAnimationOptionRepeat animations:^{
    //        _testView.frame = CGRectMake(200, 500, 100, 100);
    //    } completion:^(UIViewAnimatingPosition finalPosition) {
    //
    //    }];
    
    _viewPro = [[UIViewPropertyAnimator alloc] initWithDuration:2.5 curve:UIViewAnimationCurveLinear animations:^{
        _testView.frame = CGRectMake(200, 500, 100, 100);
    }];
    [_viewPro startAnimationAfterDelay:1.0];
}

- (IBAction)pauseAnimation:(id)sender {
    [_viewPro pauseAnimation];
    //调用上面方法之后再调用下面的方法动画会重新开始
    //[_viewPro startAnimation];
}
- (IBAction)startAnimation:(id)sender {
    //?????????????????????????????
    if (_viewPro.state == UIViewAnimatingStateInactive) {
        NSLog(@"无动画状态");
    }else if (_viewPro.state == UIViewAnimatingStateActive){
        NSLog(@"动画进行时");
    }else if (_viewPro.state == UIViewAnimatingStateStopped){
        [_viewPro startAnimation];
    }
}

- (IBAction)stopAnimation:(id)sender {
    [_viewPro stopAnimation:YES];
    //停止之后  不能调用[_viewPro startAnimation];
}
- (IBAction)addAnimation:(id)sender {
    //弹簧效果
    UISpringTimingParameters *sp =[[UISpringTimingParameters alloc] initWithDampingRatio:0.1];
    
    //设置一个动画的效果
//    UICubicTimingParameters *cub =[[UICubicTimingParameters alloc] initWithAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    //durationFactor  给一个默认值 1就可以
    [self.viewPro continueAnimationWithTimingParameters:sp durationFactor:3.0];
}



#pragma mark - Speech
- (void)speech{
    
    //必须让自己的程序支持语音识别
    //隐私政策 NSSpeechRecognitionUsageDescription
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    SFSpeechRecognizer * speech = [[SFSpeechRecognizer alloc] initWithLocale:locale];
    //别把疼你的人弄丢了
    //去大理.mp3
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"1.mp3" withExtension:nil];
    SFSpeechURLRecognitionRequest *speechRequest = [[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
    [speech recognitionTaskWithRequest:speechRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        //如果时间太长的话后面就会无法识别，后面返回失败
        if (error!=nil) {
            
            NSLog(@"语音识别解析失败,%@",error);
        }
        else
        {
            //解析部分的时候也会返回result.bestTranscription.formattedString
            //解析正确
            if (result.isFinal) {
                NSLog(@"---%@",result.bestTranscription.formattedString);
            }
        }
    }];
}

#pragma mark - Tabbar
- (void)tabBar{
    self.navigationController.tabBarItem.badgeValue = @"0";
    //bage背景色
    self.navigationController.tabBarItem.badgeColor = [UIColor redColor];
    //bage文字的颜色
    [self.navigationController.tabBarItem setBadgeTextAttributes:@{NSForegroundColorAttributeName:[UIColor greenColor]} forState:UIControlStateNormal];
}

@end
