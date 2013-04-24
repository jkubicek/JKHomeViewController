/** Allows you to create a weak timer that doesn't retain it's target. This 
 object **must** be invalidated before you dispose of it, otherwise it'll leak. 
 */

#import <Foundation/Foundation.h>

@interface JKWeakTimer : NSObject

+ (id)timerWithTimeInterval:(NSTimeInterval)seconds
                     target:(id)target
                   selector:(SEL)aSelector
                    repeats:(BOOL)repeats;

- (void)invalidate;

@end
