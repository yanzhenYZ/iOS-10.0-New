//
//  ViewController.m
//  LocalNotifications
//
//  Created by yanzhen on 16/10/27.
//  Copyright © 2016年 v2tech. All rights reserved.
//

#import "ViewController.h"
#import "LocalNotifitions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [LocalNotifitions sendNotification];
//    [LocalNotifitions category];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
