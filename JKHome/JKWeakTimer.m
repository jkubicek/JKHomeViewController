//
//  JKWeakTimer.m
//  JKHome
//
//  Created by Jim Kubicek on 4/23/13.
//
//

#import "JKWeakTimer.h"

@interface JKWeakTimer ()

@property (weak) id target;
@property (assign) SEL selector;
@property (strong) NSTimer *timer;

@end

@implementation JKWeakTimer


+ (id)timerWithTimeInterval:(NSTimeInterval)seconds
                     target:(id)target
                   selector:(SEL)aSelector
                    repeats:(BOOL)repeats
{
    JKWeakTimer *timer = [[self alloc] init];
    timer.timer = [NSTimer timerWithTimeInterval:seconds target:timer selector:@selector(timerDidFire:) userInfo:nil repeats:repeats];
    [[NSRunLoop mainRunLoop] addTimer:timer.timer forMode:NSDefaultRunLoopMode];
    timer.target = target;
    timer.selector = aSelector;
    return timer;
}

- (void)invalidate {
    [self.timer invalidate];
    self.timer = nil;
    self.target = nil;
    self.selector = nil;
}

- (void)timerDidFire:(NSTimer *)timer {
    if (self.target) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self];
        #pragma clang diagnostic pop
    } else {
        [self invalidate];
    }
}

@end
