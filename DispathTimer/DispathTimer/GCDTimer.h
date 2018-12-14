//
//  GCDTimer.h
//  DispathTimer
//
//  Created by Weigang on 2018/12/14.
//  Copyright © 2018 samanthena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^GCDTimerHandler)(dispatch_source_t timer);

@interface GCDTimer : NSObject {
    
}

@property (nonatomic, assign, readonly) NSInteger identifier;
@property (nonatomic, strong, readonly) GCDTimerHandler handler;
@property (nonatomic, assign, readonly) double timeInterval;

- (instancetype)initWithTimeInterval:(double)timeInterval
                             handler:(GCDTimerHandler)handler;
- (void)resume;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
