#import "JKCircleView.h"
#import <QuartzCore/QuartzCore.h>

@interface JKCircleView ()

@property (strong) UIImageView *imageView;

@end

@implementation JKCircleView

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        // Setup ourselves
        self.backgroundColor = [UIColor yellowColor];
        self.clipsToBounds = YES;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 2.f;

        // Setup our imageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

#pragma mark - 
#pragma mark Properties

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImage *)image {
    return self.imageView.image;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat minSide = MIN(self.frame.size.width, self.frame.size.height) / 2.f;
    self.layer.cornerRadius = minSide;
}

@end
