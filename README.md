# DispatchTimer
A GCD timer that created by Objective C. It will stop in the background and resume when app active.

## How to use
```
GCDTimer *gcdTimer = [[GCDTimer alloc] initWithTimeInterval:10 handler:^(dispatch_source_t  _Nonnull timer) {
            // do your schedule things
        }];
```
