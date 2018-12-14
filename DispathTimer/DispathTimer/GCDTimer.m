//
//  GCDTimer.m
//  DispathTimer
//
//  Created by Weigang on 2018/12/14.
//  Copyright © 2018 samanthena. All rights reserved.
//

#import "GCDTimer.h"

@interface GCDTimer()
@property (nonatomic, assign, readwrite) NSInteger identifier;
@property (nonatomic, strong, readwrite) dispatch_queue_t queue;
@property (nonatomic, strong, readwrite) dispatch_source_t timer;
@property (nonatomic, strong, readwrite) GCDTimerHandler handler;
@property (nonatomic, assign, readwrite) double timeInterval;
@end

@implementation GCDTimer

- (instancetype)initWithTimeInterval:(double)timeInterval
                             handler:(GCDTimerHandler)handler {
    self = [super init];
    if (self) {
        static NSInteger __identifier = 0;
        
        self.identifier = __identifier++;
        self.timeInterval = timeInterval;
        self.handler = handler;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResign:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        NSLog(@"%@, timer init...", self);
    }
    return self;
}

- (instancetype)init {
    
    NSAssert(0, @"Should not call this method to create instance. Please use initWithTimeInterval:handler:");
    
    return nil;
}

- (void)resume {
    if (self.timeInterval == 0 || self.handler == nil) {
        NSLog(@"%@, resume failed time interval = %.f handler = %@", self, self.timeInterval, self.handler);
        return;
    }

    [self stopTimer];
    [self createTimer];
    [self resumeTimer];
}

- (void)stop {
    [self stopTimer];
}

// Timer
- (void)createTimer {
    
    self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), (uint64_t)(self.timeInterval *NSEC_PER_SEC), 0);
    // 设置回调
    __weak __typeof(self) weakSelf  = self;
    dispatch_source_set_event_handler(self.timer, ^{
        if (!weakSelf)  {
            if (self.timer) {
                dispatch_source_cancel(self.timer);
                self.timer = nil;
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.handler)
                    self.handler(self.timer);
            });
        }
    });
}

- (void)resumeTimer {
    if (self.timer) {
        NSLog(@"%@, resume timer...", self);
        dispatch_resume(self.timer);// 启动定时器
    }
}

- (void)stopTimer {
    if (self.timer) {
        NSLog(@"%@, stop timer...", self);
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}


- (void)appWillResign:(id)sender{
    NSLog(@"%@, app will resign...", self);
    [self stopTimer];
}

- (void)appDidActive:(id)sender{
    NSLog(@"%@, app did active...", self);
    [self resume];
}

- (void)dealloc{
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    
    NSLog(@"timer dealloc");
}

- (NSString *)description {
    return [NSString stringWithFormat:@"timer[%ld] interval[%.f]", self.identifier, self.timeInterval];
}

@end
