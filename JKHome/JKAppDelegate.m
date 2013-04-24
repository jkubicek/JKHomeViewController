//
//  JKAppDelegate.m
//  JKHome
//
//  Created by Jim Kubicek on 4/4/13.
//
//

#import "JKAppDelegate.h"
#import "TestViewController.h"
#import "JKHomeViewController.h"
#import "BaseViewController.h"

@implementation JKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    JKHomeViewController *homeVC = [[JKHomeViewController alloc] initWithNibName:nil bundle:nil];

    BaseViewController *baseVC = [[BaseViewController alloc] init];
    homeVC.baseViewController = baseVC;
    homeVC.homeButtonImage = [UIImage imageNamed:@"me.png"];

    TestViewController *t1 = [[TestViewController alloc] init];
    t1.labelText = @"Drink Beer Erryday";
    homeVC.leftViewController = t1;
    homeVC.leftViewImage = [UIImage imageNamed:@"Beer.png"];

    TestViewController *t2 = [[TestViewController alloc] init];
    t2.labelText = @"They see me rollin' They hatin'";
    homeVC.rightViewController = t2;
    homeVC.rightViewImage = [UIImage imageNamed:@"Biker.png"];

    TestViewController *t3 = [[TestViewController alloc] init];
    t3.labelText = @"Big Shrimpin'";
    homeVC.topViewController = t3;
    homeVC.topViewImage = [UIImage imageNamed:@"Shrimp.png"];

    self.viewController = homeVC;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
