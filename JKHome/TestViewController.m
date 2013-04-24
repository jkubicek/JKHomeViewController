//
//  TestViewController.m
//  JKHome
//
//  Created by Jim Kubicek on 4/5/13.
//
//

#import "TestViewController.h"

@interface TestViewController ()

@property (strong, nonatomic) IBOutlet UILabel *label;

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.label.text = self.labelText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
