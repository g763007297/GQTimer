//
//  GQTimer.m
//  GQTimerDemo
//
//  Created by 高旗 on 2018/2/22.
//  Copyright © 2018年 gaoqi. All rights reserved.
//

#import "GQTimer.h"

//强弱引用
#ifndef GQWeakify
#define GQWeakify(object) __weak __typeof__(object) weak##_##object = object
#endif

#ifndef GQStrongify
#define GQStrongify(object) __typeof__(object) object = weak##_##object
#endif


#define GQDispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
    block();\
} else {\
    dispatch_async(dispatch_get_main_queue(), block);\
}

@interface GQTimer()

@property (nonatomic, strong) dispatch_source_t   timer;

@property (nonatomic, strong) dispatch_block_t    resumeBlock;

@property (nonatomic,strong)  NSDate              *beforeDate; // 上次进入后台时间

@property (nonatomic, assign) NSTimeInterval      timerStep;//

@property (nonatomic, strong) GQTimerBlock        timerBlock;

@property (nonatomic, assign) BOOL                scheduled;//是否需要异步

@property (nonatomic, assign) BOOL                repeats;//是否需要重复

@property (nonatomic, assign) NSTimeInterval      delay;//延迟时间

@property (nonatomic, assign) NSTimeInterval timeInterval;//秒级别  总共运行时间

@property (nonatomic, assign) GQTimerState timerState;

@end

@implementation GQTimer

@synthesize timerState = _timerState;

+ (instancetype)timerWithTimerStep:(NSTimeInterval)timerStep
                           repeats:(BOOL)yesOrNo
                         withBlock:(GQTimerBlock)timerBlock {
    GQTimer *timer = [[GQTimer alloc] init];
    timer.timerStep = timerStep;
    timer.timerBlock = timerBlock;
    timer.repeats = yesOrNo;
    return timer;
}

+ (instancetype)scheduledTimerWithTimerStep:(NSTimeInterval)timerStep
                                    repeats:(BOOL)yesOrNo
                                  withBlock:(GQTimerBlock)timerBlock {
    GQTimer *timer = [[GQTimer alloc] init];
    timer.timerStep = timerStep;
    timer.timerBlock = timerBlock;
    timer.scheduled = YES;
    timer.repeats = yesOrNo;
    return timer;
}

#pragma mark -- life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timerState = GQTimerStateReady;
        self.scheduled = NO;
        self.delay = 0;
        self.timerStep = 1;
        self.repeats = NO;
        [self setupNotification];
    }
    return self;
}

- (void)dealloc {
    [self invalid];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark -- public method

- (void)resume {
    if (self.timerState != GQTimerStateResume) {
        self.timerState = GQTimerStateResume;
        dispatch_resume(self.timer);
    }
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)timeInterval {
    if (self.timerState != GQTimerStateResume) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC));
        GQWeakify(self);
        _resumeBlock = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            GQStrongify(self);
            [self resume];
            self->_resumeBlock = nil;
        });
        dispatch_after(popTime, dispatch_get_main_queue(), _resumeBlock);
    }
}

- (void)suspend {
    if (self.timerState != GQTimerStateSuspend && _timer) {
        self.timerState = GQTimerStateSuspend;
        dispatch_suspend(self.timer);
    }
}

- (void)invalid {
    if (nil != _resumeBlock) {
        dispatch_block_cancel(_resumeBlock);
        _resumeBlock = nil;
    }
    if (nil != _timer) {
        if (self.timerState != GQTimerStateResume) {
            [self resume];
        }
        dispatch_source_cancel(_timer);
        _timer = nil;
        self.timeInterval = 0;
        self.timerState = GQTimerStateReady;
    }
}

#pragma mark -- private method

-(void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

/**
 *  进入后台记录当前时间
 */
-(void)enterBackground {
    if (self.timerState == GQTimerStateResume) {
        [self suspend];
        self.timerState = GQTimerStateBackGround;
        _beforeDate = [NSDate date];
    }
}

/**
 *  返回前台时更新倒计时值
 */
-(void)enterForeground {
    if (self.timerState == GQTimerStateBackGround) {
        NSDate * now = [NSDate date];
        int interval = (int)ceil([now timeIntervalSinceDate:_beforeDate]);
        [self countDown:interval];
        [self resumeTimerAfterTimeInterval:self.timerStep];
    }
}

- (void)countDown:(NSTimeInterval)timerInterval {
    _timeInterval += timerInterval;
    if (_scheduled) {
        if (_timerBlock) {
            _timerBlock(self);
        }
    } else {
        GQDispatch_main_async_safe(^{
            if (_timerBlock) {
                _timerBlock(self);
            }
        });
    }
}

#pragma mark -- lazy load

- (GQTimerState)timerState {
    @synchronized(self) {
        return _timerState;
    }
}

- (void)setTimerState:(GQTimerState)timerState {
    @synchronized(self) {
        [self willChangeValueForKey:@"timerState"];
        _timerState = timerState;
        [self didChangeValueForKey:@"timerState"];
    }
}

- (dispatch_source_t)timer {
    if (!_timer) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        // 创建一个定时器(dispatch_source_t本质还是个OC对象,创建出来的对象需要强引用)
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delay * NSEC_PER_SEC));
        
        uint64_t interval = _timerStep * NSEC_PER_SEC;
        dispatch_source_set_timer(_timer, start, interval, 0); // NSEC_PER_SEC 纳秒
        GQWeakify(self);
        dispatch_source_set_event_handler(_timer, ^{
            weak_self.repeats ? nil : [weak_self invalid];
            [weak_self countDown:weak_self.timerStep];
        });
    }
    return _timer;
}

@end
