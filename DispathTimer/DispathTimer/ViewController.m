//
//  ViewController.m
//  DispathTimer
//
//  Created by Weigang on 2018/12/14.
//  Copyright © 2018 samanthena. All rights reserved.
//

#import "ViewController.h"
#import "GCDTimer.h"

@interface ViewController ()
@property (nonatomic, strong) GCDTimer *gcdTimer;

@property (nonatomic, strong) NSMutableArray *timers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)createTimer:(id)sender {
    for (int i=0; i<10; i++) {
        __block GCDTimer *gcdTimer = [[GCDTimer alloc] initWithTimeInterval:arc4random() % 30 + 1 handler:^(dispatch_source_t  _Nonnull timer) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = @"hh:mm:ss";
            NSLog(@"timer[%ld] interval[%.f] %@", gcdTimer.identifier, gcdTimer.timeInterval, [df stringFromDate:[NSDate date]]);
        }];
        [gcdTimer resume];
        [self.timers addObject:gcdTimer];
    }
}

- (IBAction)stopTimer:(id)sender {
    for (GCDTimer *timer in self.timers) {
        [timer stop];
    }
}

@end


