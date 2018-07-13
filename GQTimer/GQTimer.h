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

#pragma init method

/**
 创建在主线程中回调定时器
 
 param timerStep 单位触发时间   单位秒
 param yesOrNo 是否重复运行
 param userInfo 自定义信息
 param timerBlock 回调block
 return GQTimer
 */
+ (instancetype)timerWithTimerStep:(NSTimeInterval)timerStep
                           repeats:(BOOL)yesOrNo
                          userInfo:(NSDictionary *)userInfo
                         withBlock:(GQTimerBlock)timerBlock;

/**
 创建在异步线程回调定时器
 
 param timerStep 单位运行时间   单位秒
 param yesOrNo 是否重复运行
 param userInfo 自定义信息
 param timerBlock 回调block
 return GQTimer
 */
+ (instancetype)scheduledTimerWithTimerStep:(NSTimeInterval)timerStep
                                    repeats:(BOOL)yesOrNo
                                   userInfo:(NSDictionary *)userInfo
                                  withBlock:(GQTimerBlock)timerBlock;

/**
 创建在主线程中回调定时器

 @param timerStep 单位触发时间   单位秒
 @param yesOrNo 是否重复运行
 @param userInfo 自定义信息
 @param aTarget target
 @param aSelector selector
 @return GQTimer
 */
+ (instancetype)timerWithTimerStep:(NSTimeInterval)timerStep
                           repeats:(BOOL)yesOrNo
                          userInfo:(NSDictionary *)userInfo
                            target:(id)aTarget
                          selector:(SEL)aSelector;

/**
 创建在异步线程回调定时器

 @param timerStep 单位触发时间   单位秒
 @param yesOrNo 是否重复运行
 @param userInfo 自定义信息
 @param aTarget target
 @param aSelector selector
 @return GQTimer
 */
+ (instancetype)scheduledTimerWithTimerStep:(NSTimeInterval)timerStep
                                    repeats:(BOOL)yesOrNo
                                   userInfo:(NSDictionary *)userInfo
                                     target:(id)aTarget
                                   selector:(SEL)aSelector;

#pragma avaliable attribute

/**
 从创建启动起总共运行时间  单位为秒级别
 */
@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;

/**
 自定义信息
 */
@property (nonatomic, strong, readonly) NSDictionary *userInfo;

/**
 定时器状态
 */
@property (nonatomic, assign, readonly) GQTimerState timerState;

#pragma public method

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

#pragma DEPRECATED Selector

+ (instancetype)timerWithTimerStep:(NSTimeInterval)timerStep repeats:(BOOL)yesOrNo withBlock:(GQTimerBlock)timerBlock DEPRECATED_MSG_ATTRIBUTE("Use timerWithTimerStep:repeats:userInfo:withBlock instead");

+ (instancetype)scheduledTimerWithTimerStep:(NSTimeInterval)timerStep repeats:(BOOL)yesOrNo withBlock:(GQTimerBlock)timerBlock DEPRECATED_MSG_ATTRIBUTE("Use scheduledTimerWithTimerStep:repeats:userInfo:withBlock instead");

@end
