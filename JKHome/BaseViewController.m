//
//  BaseViewController.m
//  JKHome
//
//  Created by Jim Kubicek on 4/23/13.
//
//

#import "BaseViewController.h"
#import "JKWeakTimer.h"

@interface BaseViewController ()

// Interface Elements
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

// Private Properties
@property (strong) JKWeakTimer *timer;

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.timer = [JKWeakTimer timerWithTimeInterval:1 target:self selector:@selector(timerDidFire:) repeats:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self.timer invalidate];
}

#pragma mark - 
#pragma mark Private Instance Methods

- (void)timerDidFire:(JKWeakTimer *)timer {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle:NSDateFormatterShortStyle];
    [df setDateStyle:NSDateFormatterNoStyle];
    NSString *time = [df stringFromDate:[NSDate date]];

    self.timeLabel.text = time;
}

@end
