#import "JKHomeViewController.h"
#import <GLKit/GLKMath.h>
#import "JKCircleView.h"

#define SHOULD_NEVER_GET_HERE NSAssert(NO, @"Should never get here")

#pragma mark - Constants

// Animations
const CGFloat kAnimationDur = 0.25f;

// Layout
const CGFloat kButtonSize = 44.f;
const CGFloat kBottomPadding = 50.f;
const CGFloat kButtonSpacing = 100.f;

// Magnetism
const CGFloat kMagneticConstant = 30000.f;
const CGFloat kButtonFudgeFactor = 5.f; // If button centers are within this
                                         // distance of each other, they can be
                                         // said to be in the same position.

typedef NS_ENUM(NSUInteger, JKHomeViewButtonType) {
    JKHomeViewButtonLeft,
    JKHomeViewButtonTop,
    JKHomeViewButtonRight
};

#pragma mark - Helper Functions

CGPoint CenterOfRect(CGRect rect) {
    CGFloat x = CGRectGetMidX(rect);
    CGFloat y = CGRectGetMidY(rect);
    return CGPointMake(x, y);
}

GLKVector2 PointToVector(CGPoint point) {
    return GLKVector2Make(point.x, point.y);
}

CGPoint AddPoints(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

CGAffineTransform TopButtonBaseTransform() {
    return CGAffineTransformMakeTranslation(0.f, kButtonSpacing);
}

CGAffineTransform LeftButtonBaseTransform() {
    return CGAffineTransformMakeTranslation(kButtonSpacing, 0.f);
}

CGAffineTransform RightButtonBaseTransform() {
    return CGAffineTransformMakeTranslation(-kButtonSpacing, 0.f);
}

@interface JKHomeViewController ()

// Interface Elements
@property (strong) JKCircleView *bottomButton;
@property (strong) UIImageView *topButton;
@property (strong) UIImageView *rightButton;
@property (strong) UIImageView *leftButton;

// Holds all our secondary circle views
@property (strong) NSArray *secondaryButtons;

// Holds our child view controllers
@property (strong) UIView *childContainerView;
@property (strong) UIViewController *childViewController;

@end

@implementation JKHomeViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor redColor];

    [self configureBaseViewController];
    [self setupButtons];
    [self setupContainerView];
}

- (void)setupButtons {
    /*
     Bottom Button
     */
    JKCircleView *bottomButton = [[JKCircleView alloc] init];
    CGRect bbFrame = CGRectZero;
    bbFrame.size = CGSizeMake(kButtonSize, kButtonSize);
    bottomButton.frame = bbFrame;
    CGPoint bbCenter = CenterOfRect(self.view.bounds);
    bbCenter.y = CGRectGetMaxY(self.view.bounds) - kBottomPadding;
    bottomButton.center = bbCenter;
    bottomButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    [self.view addSubview:bottomButton];
    self.bottomButton = bottomButton;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bottomButtonDidPan:)];
    [bottomButton addGestureRecognizer:panGesture];
    
    /*
     Top Button
     */
    UIImageView *topButton = [[UIImageView alloc] init];
    CGRect tFrame = CGRectZero;
    tFrame.size = CGSizeMake(kButtonSize, kButtonSize);
    topButton.frame = tFrame;
    CGPoint tCenter = CenterOfRect(self.view.bounds);
    tCenter.y = CGRectGetMidY(bottomButton.frame) - kButtonSpacing;
    topButton.center = tCenter;
    topButton.autoresizingMask = bottomButton.autoresizingMask;
    topButton.alpha = 0.f;
    
    [self.view insertSubview:topButton belowSubview:bottomButton];
    self.topButton = topButton;
    
    /*
     Right Button
     */
    UIImageView *rightButton = [[UIImageView alloc] init];
    CGRect rFrame = CGRectZero;
    rFrame.size = CGSizeMake(kButtonSize, kButtonSize);
    rightButton.frame = rFrame;
    CGPoint rCenter = bbCenter;
    rCenter.x += kButtonSpacing;
    rightButton.center = rCenter;
    rightButton.autoresizingMask = bottomButton.autoresizingMask;
    rightButton.alpha = 0.f;
    
    [self.view insertSubview:rightButton belowSubview:bottomButton];
    self.rightButton = rightButton;
    
    /*
     Left Button
     */
    UIImageView *leftButton = [[UIImageView alloc] init];
    CGRect lFrame = CGRectZero;
    lFrame.size = CGSizeMake(kButtonSize, kButtonSize);
    leftButton.frame = lFrame;
    CGPoint lCenter = bbCenter;
    lCenter.x -= kButtonSpacing;
    leftButton.center = lCenter;
    leftButton.autoresizingMask = bottomButton.autoresizingMask;
    leftButton.alpha = 0.f;
    
    [self.view insertSubview:leftButton belowSubview:bottomButton];
    self.leftButton = leftButton;
    
    // Save the secondary buttons to an array
    self.secondaryButtons = @[leftButton, topButton, rightButton];
    
    // Set the button images and the base transformation
    [self resetImages];
    [self resetButtonsToBaseTransform];
}

- (void)setupContainerView {
    /*
     Container View
     */
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    containerView.userInteractionEnabled = NO;
    [self.view addSubview:containerView];
    self.childContainerView = containerView;
}

#pragma mark -
#pragma mark Properties

- (void)setBaseViewController:(UIViewController *)baseViewController {
    if (_baseViewController == baseViewController) return;
    [_baseViewController willMoveToParentViewController:nil];
    if (_baseViewController.isViewLoaded) {
        [_baseViewController.view removeFromSuperview];
    }
    [_baseViewController removeFromParentViewController];
    _baseViewController = baseViewController;
    [self configureBaseViewController];
}

- (void)setLeftViewImage:(UIImage *)leftViewImage {
    if (_leftViewImage == leftViewImage) return;
    _leftViewImage = leftViewImage;
    [self resetImages];
}

- (void)setRightViewImage:(UIImage *)rightViewImage {
    if (_rightViewImage == rightViewImage) return;
    _rightViewImage = rightViewImage;
    [self resetImages];
}

- (void)setTopViewImage:(UIImage *)topViewImage {
    if (_topViewImage == topViewImage) return;
    _topViewImage = topViewImage;
    [self resetImages];
}

- (void)setHomeButtonImage:(UIImage *)homeButtonImage {
    if (_homeButtonImage == homeButtonImage) return;
    _homeButtonImage = homeButtonImage;
    [self resetImages];
}

#pragma mark Private Methods

- (void)animateButtonsOut {
    [UIView animateWithDuration:kAnimationDur animations:^{
        for (UIView *view in self.secondaryButtons) {
            view.transform = CGAffineTransformIdentity;
            view.alpha = 1.f;
        }
    }];
}

- (void)resetButtonsToBaseTransform {
    self.leftButton.transform = LeftButtonBaseTransform();
    self.leftButton.alpha = 0.f;
    self.rightButton.transform = RightButtonBaseTransform();
    self.rightButton.alpha = 0.f;
    self.topButton.transform = TopButtonBaseTransform();
    self.topButton.alpha = 0.f;
}

- (void)checkBottomButtonPositionWithTranslation:(CGPoint)trans {
    // If the bottom button is over another button, open that VC and reset everything
    CGPoint point = AddPoints(self.bottomButton.center, trans);
    for (UIButton *button in self.secondaryButtons) {
        if ([self point:point isOverButton:button]) {
            [self openViewControllerForView:button];
            [self migrateBottomButtonHomeAnimated:YES];
            return;
        }
    }

    // else animate our buttons home
    [self migrateBottomButtonHomeAnimated:YES];
}

- (BOOL)point:(CGPoint)point isOverButton:(UIView *)v {
    GLKVector2 bOrigin = PointToVector(v.center);
    GLKVector2 bOffset = GLKVector2Make(v.transform.tx, v.transform.ty);
    GLKVector2 bPosition = GLKVector2Add(bOrigin, bOffset);
    GLKVector2 pOrigin = PointToVector(point);
    float dist = GLKVector2Distance(bPosition, pOrigin);
    if (dist <= kButtonFudgeFactor)
        return YES;
    else
        return NO;
}

- (void)migrateBottomButtonHomeAnimated:(BOOL)animated {
    void (^animation)() = ^void () {
        self.bottomButton.transform = CGAffineTransformIdentity;
        [self resetButtonsToBaseTransform];
    };

    if (animated) {
        [UIView animateWithDuration:kAnimationDur
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:animation completion:nil];
    } else {
        animation();
    }
}

- (void)moveViewTowardsBottomButton:(UIView *)v {
    // Calculate distance between buttons
    CGPoint bottomCenter = CGPointApplyAffineTransform(self.bottomButton.center, self.bottomButton.transform);
    CGPoint buttonCenter = v.center;

    CGFloat xDist = bottomCenter.x - buttonCenter.x;
    CGFloat yDist = bottomCenter.y - buttonCenter.y;

    CGFloat dist = sqrtf(powf(xDist, 2.f) + powf(yDist, 2.f));

    // Calculate force as a function of distance
    CGFloat force = 1.f / powf(dist, 2.f);
    force = force * kMagneticConstant;
    force = MIN(force, dist);

    // Offset the button V towards the bottom button
    GLKVector2 vB = GLKVector2Make(xDist, yDist);
    GLKVector2 normVB = GLKVector2Normalize(vB);
    GLKVector2 moveV = GLKVector2MultiplyScalar(normVB, force);

    CGAffineTransform t = CGAffineTransformMakeTranslation(moveV.x, moveV.y);
    v.transform = t;
}

- (void)openViewControllerForView:(UIView *)v {
    if (v == self.leftButton) {
        [self activateButton:JKHomeViewButtonLeft];
    } else if (v == self.topButton) {
        [self activateButton:JKHomeViewButtonTop];
    } else if (v == self.rightButton) {
        [self activateButton:JKHomeViewButtonRight];
    }
}

- (void)resetImages {
    self.topButton.image = self.topViewImage;
    self.rightButton.image = self.rightViewImage;
    self.leftButton.image = self.leftViewImage;
    self.bottomButton.image = self.homeButtonImage;
}

- (void)setBottomButtonTranslation:(CGPoint)trans {
    CGAffineTransform t = CGAffineTransformMakeTranslation(trans.x, trans.y);
    self.bottomButton.transform = t;
    [self updateSecondaryButtonLocations];
}

- (void)setChildViewController:(UIViewController *)vc animated:(BOOL)animated {
    [self addChildViewController:vc];
    vc.view.frame = self.childContainerView.bounds;
    [self.childContainerView addSubview:vc.view];
    self.childContainerView.userInteractionEnabled = YES;
    self.childViewController = vc;

    CGAffineTransform t;
    if (vc == self.leftViewController) {
        t = CGAffineTransformMakeTranslation(-self.view.bounds.size.width, 0.f);
    } else if (vc == self.topViewController) {
        t = CGAffineTransformMakeTranslation(0.f, -self.view.bounds.size.height);
    } else if (vc == self.rightViewController) {
        t = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0.f);
    } else {
        SHOULD_NEVER_GET_HERE;
        t = CGAffineTransformIdentity;
    }

    vc.view.transform = t;
    [UIView animateWithDuration:kAnimationDur animations:^{
        vc.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [vc didMoveToParentViewController:self];
    }];
}

- (void)configureBaseViewController {
    // This method can be called from more than just `viewDidLoad`
    // if our view isn't loaded yet, do nothing
    if (self.isViewLoaded && self.baseViewController) {
        [self addChildViewController:self.baseViewController];
        self.baseViewController.view.frame = self.view.bounds;
        [self.view addSubview:self.baseViewController.view];
        [self.view sendSubviewToBack:self.baseViewController.view];
        [self.baseViewController didMoveToParentViewController:self];
    }
}

- (void)resetButtonPositions {
    for (UIButton *button in self.secondaryButtons) {
        button.transform = CGAffineTransformIdentity;
    }
}

- (void)activateButton:(JKHomeViewButtonType)type {
    UIViewController *activatedVC = nil;
    switch (type) {
        case JKHomeViewButtonLeft:
            activatedVC = self.leftViewController;
            break;
        case JKHomeViewButtonRight:
            activatedVC = self.rightViewController;
            break;
        case JKHomeViewButtonTop:
            activatedVC = self.topViewController;
    }
    [self setChildViewController:activatedVC animated:YES];
}

- (void)updateSecondaryButtonLocations {
    for (UIButton *button in self.secondaryButtons) {
        button.transform = CGAffineTransformIdentity;
        [self moveViewTowardsBottomButton:button];
    }
}

#pragma mark Gesture Recognizers

- (void)bottomButtonDidPan:(UIPanGestureRecognizer *)panGesture {
    CGPoint trans = [panGesture translationInView:self.bottomButton];
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            [self animateButtonsOut];
            break;
        case UIGestureRecognizerStateChanged:
            [self setBottomButtonTranslation:trans];
            break;
        case UIGestureRecognizerStateEnded:
            [self checkBottomButtonPositionWithTranslation:trans];
            break;
        default:
            break;
    }
}

#pragma mark - UIViewController

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    self.childContainerView.userInteractionEnabled = NO;
    [self.childViewController willMoveToParentViewController:nil];
    [self.childViewController removeFromParentViewController];

    CGAffineTransform t = CGAffineTransformIdentity;
    if (self.childViewController == self.leftViewController) {
        t = CGAffineTransformMakeTranslation(-self.view.bounds.size.width, 0.f);
    } else if (self.childViewController == self.topViewController) {
        t = CGAffineTransformMakeTranslation(0.f, -self.view.bounds.size.height);
    } else if (self.childViewController == self.rightViewController) {
        t = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0.f);
    } else {
        SHOULD_NEVER_GET_HERE;
    }

    [UIView animateWithDuration:kAnimationDur animations:^{
        self.childViewController.view.transform = t;
    } completion:^(BOOL finished) {
        self.childViewController.view.transform = CGAffineTransformIdentity;
        [self.childViewController.view removeFromSuperview];
        self.childViewController = nil;
    }];
}

@end
