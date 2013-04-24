`JKHomeViewController` is app home screen that somewhat emulates the features of Facebook Home. Dragging small rounded image around the screen lets the user select one of three icons. Dropping the image on the icon, opens the view controller associated with that icon. 

Installation
============

Download `JKHomeViewController` and drag the following files into your project:

 * `JKHomeViewController.h`
 * `JKHomeViewController.m`
 * `JKCircleView.h`
 * `JKCircleView.m`
 
Make sure the following frameworks are in your project:

 * `GLKit.framework`
 * `CoreGraphics.frameork`

Thats it!

![fake-facebook-home](images/facebook_home_ios.gif)

Usage
=====

Usage is dead simple. Example setup:

```objc
JKHomeViewController *homeVC = [[JKHomeViewController alloc] nil];

// Assume you've got valid UIViewControllers here.
UIViewController *base, *top, *right, *left;

homeVC.baseViewController = base;
homeVC.leftViewController = left;
homeVC.rightViewController = right;
homeVC.topViewController = top;

// Assume you've got valid UIImages here
UIImage *homeImage, *topImage, *rightImage, *leftImage;

homeVC.homeButtonImage = baseImage;
homeVC.leftViewImage = leftImage;
homeVC.rightViewImage = rightImage;
homeVC.topViewImage = topImage;

self.window.rootViewController = self.viewController;
```
