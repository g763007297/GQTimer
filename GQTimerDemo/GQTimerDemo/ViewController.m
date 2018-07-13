//
//  ViewController.m
//  GQTimerDemo
//
//  Created by 高旗 on 2018/2/22.
//  Copyright © 2018年 gaoqi. All rights reserved.
//

#import "ViewController.h"
#import "GQTimer.h"

@interface ViewController ()

@property (nonatomic, strong) GQTimer *timer;

@property (nonatomic, strong) GQTimer *timers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _timer = [GQTimer timerWithTimerStep:1.0 repeats:YES userInfo:@{@"userinfo":@"123"} withBlock:^(GQTimer *timer) {
        NSLog(@"%@",timer.userInfo);
    }];
//    [_timer resume];
    
    _timers = [GQTimer scheduledTimerWithTimerStep:1.0 repeats:YES userInfo:@{@"userinfo":@"456"} target:self selector:@selector(timerFire:)];
    [_timers resume];
}

- (void)timerFire:(GQTimer *)timer {
    NSLog(@"%@",timer.userInfo);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
