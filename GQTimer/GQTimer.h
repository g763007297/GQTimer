//
//  GQTimer.h
//  GQTimerDemo
//
//  Created by 高旗 on 2018/2/22.
//  Copyright © 2018年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GQTimer;

typedef void(^GQTimerBlock)(GQTimer *timer);

typedef enum : NSUInteger {
    GQTimerStateReady = 0,//准备中
    GQTimerStateResume,//运行中
    GQTimerStateSuspend,//暂停
    GQTimerStateBackGround,//在后台
} GQTimerState;

NS_CLASS_AVAILABLE_IOS(4_0)

@interface GQTimer : NSObject

/**
 创建在主线程中回调定时器
 
 param timerStep 单位触发时间   单位秒
 param yesOrNo 是否重复运行
 param timerBlock 回调block
 return GQTimer
 */
+ (instancetype)timerWithTimerStep:(NSTimeInterval)timerStep repeats:(BOOL)yesOrNo withBlock:(GQTimerBlock)timerBlock;

/**
 创建在异步线程回调定时器
 
 param timerStep 单位运行时间   单位秒
 param yesOrNo 是否重复运行
 param timerBlock 回调block
 return GQTimer
 */
+ (instancetype)scheduledTimerWithTimerStep:(NSTimeInterval)timerStep repeats:(BOOL)yesOrNo withBlock:(GQTimerBlock)timerBlock;

/**
 从创建启动起总共运行时间  单位为秒级别
 */
@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;

/**
 定时器状态
 */
@property (nonatomic, assign, readonly) GQTimerState timerState;

/**
 立即恢复计时器
 */
- (void)resume;

/**
 延迟恢复计时器
 
 param timeInterval 秒
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)timeInterval;

/**
 暂停计时器
 */
- (void)suspend;

/**
 销毁计时器
 */
- (void)invalid;

@end
