/** JKHomeViewController is a parent view controller that functions similarly to a tab controller, except with a different navigation experience.
 
 To use, instantiate the `JKHomeViewController`. You are required to populate the four main view controllers.
 
  1. `baseViewController` This VC is the background behind the navigation. It can be as simple as an image or a pattern. Don't try and initiate any navigation from here. It should work, but it'll be ugly.
  2. `topViewController` The VC activated by the top button.
  3. `leftViewController` The VC activated by the left button.
  4. `rightViewController` The VC activated by the right button.
 
 In addition, you'll need to provide four additional images. These images are not cropped, though they are resized to fit within a 44x44px square.
 
  1. `homeButtonImage` This image is initially displayed alone in the bottom of the screen. This image will be cropped to a circle with a black border.
  2. `topViewImage` The image on the top button.
  3. `leftViewImage` The image on the top button.
  4. `rightViewImage` The image on the right button.
 */
#import <UIKit/UIKit.h>

@interface JKHomeViewController : UIViewController

@property (strong, nonatomic) UIImage          *homeButtonImage;
@property (strong, nonatomic) UIViewController *baseViewController;

@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UIImage          *topViewImage;

@property (strong, nonatomic) UIViewController *rightViewController;
@property (strong, nonatomic) UIImage          *rightViewImage;

@property (strong, nonatomic) UIViewController *leftViewController;
@property (strong, nonatomic) UIImage          *leftViewImage;

@end
