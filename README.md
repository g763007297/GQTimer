[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/angelcs1990/GQTimer/master/LICENSE)&nbsp;
[![](https://img.shields.io/badge/platform-iOS-brightgreen.svg)](http://cocoapods.org/?q=GQTimer)&nbsp;
[![support](https://img.shields.io/badge/support-iOS6.0%2B-blue.svg)](https://www.apple.com/nl/ios/)&nbsp;

# GQTimer
基于GCD的定时器，自动记录后台运行时间，可统计运行总时长


## 使用CocoaPods导入

1.在 Podfile 中添加 pod 'GQTimer'。
2.执行 pod install 或 pod update。
3.导入 GQTimer.h。

## 使用方式

### 初始化方法：

```objc

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

```

### 属性介绍

```objc

/**
 从创建启动起总共运行时间  单位为秒级别
 */
@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;

/**
 定时器状态 分为4种状态 
 */
@property (nonatomic, assign, readonly) GQTimerState timerState;

typedef enum : NSUInteger {
    GQTimerStateReady = 0,//准备中
    GQTimerStateResume,//运行中
    GQTimerStateSuspend,//暂停
    GQTimerStateBackGround,//在后台
} GQTimerState; //对应定时器状态

```

### Public Method

```objc

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

```

## Level history

(1) 1.0.0

	GitHub添加代码。
	
(2) 1.0.1

	修复当定时器销毁时再suspend定时器会出现野指针的问题
	
(3) 1.0.2
	
	修复延迟resume定时器，同时invalid定时器无效的问题
	
(4) 1.0.3
	
	新增target-selector回调，新增userInfo设置
	
(5) 1.0.4
	
	wait a moment
	
## Support

欢迎指出bug或者需要改善的地方，欢迎提出issues、加Q群交流iOS经验：578841619 ， 我会及时的做出回应，觉得好用的话不妨给个star吧，你的每个star是我持续维护的强大动力。
