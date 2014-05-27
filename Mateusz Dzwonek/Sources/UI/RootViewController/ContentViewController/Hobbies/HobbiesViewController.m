//
//  HobbiesViewController.m
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 11/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "HobbiesViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "ESTBeaconManager.h"
#import "ESTBeaconRegion.h"
#import <MDSDK/MDSDK.h>
#import "RootViewController.h"
#import "InternetOfThingsViewController.h"
#import "RunningViewController.h"


#define ESTIMOTE_PROXIMITY_UUID             [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]
#define ESTIMOTE_MACBEACON_PROXIMITY_UUID   [[NSUUID alloc] initWithUUIDString:@"08D4A950-80F0-4D42-A14B-D53E063516E6"]
#define ESTIMOTE_IOSBEACON_PROXIMITY_UUID   [[NSUUID alloc] initWithUUIDString:@"8492E75F-4FD6-469D-B132-043FE94921D8"]


@interface HobbiesViewController () <ESTBeaconManagerDelegate>

@property (nonatomic) IBOutlet UIView *internetOfThingsDialog;
@property (nonatomic) IBOutlet UIView *internetOfThingsDialogContent;
@property (nonatomic) IBOutlet UIView *internetOfThingsDialogShadow;

@property (nonatomic) IBOutlet UIView *runningDialog;
@property (nonatomic) IBOutlet UIView *runningDialogContent;
@property (nonatomic) IBOutlet UIView *runningDialogShadow;
@property (nonatomic) IBOutlet UILabel *runningDialogLabel;

@property (nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;

@property (nonatomic) ESTBeaconManager *beaconManager;

@property (nonatomic) CMStepCounter *stepCounter;
@property (nonatomic) NSOperationQueue *operationQueue;

@end


@implementation HobbiesViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"hobbies";
        self.operationQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIImageView *imageView in self.imageViews) {
        imageView.image = [imageView.image imageTintedWithColor:[UIColor darkGrayColor]];
    }
}

- (IBAction)didTapInternetOfThingsButton:(id)sender {
    [self showDialog:self.internetOfThingsDialog withContent:self.internetOfThingsDialogContent andShadow:self.internetOfThingsDialogShadow];
    [self startRangingEstimoteBeacons];
}

- (IBAction)didTapRunningButton:(id)sender {
    [self showDialog:self.runningDialog withContent:self.runningDialogContent andShadow:self.runningDialogShadow];
    [self startTrackingSteps];
}

- (IBAction)didTapInternetOfThingsShadow:(id)sender {
    [self hideDialog:self.internetOfThingsDialog withContent:self.internetOfThingsDialogContent andShadow:self.internetOfThingsDialogShadow];
    [self stopRangingEstimoteBeacons];
}

- (IBAction)didTapRunningDialogShadow:(id)sender {
    [self hideDialog:self.runningDialog withContent:self.runningDialogContent andShadow:self.runningDialogShadow];
    [self stopTrackingSteps];
}

- (IBAction)didTapInternetOfThingsSkipButton:(id)sender {
    [self stopRangingEstimoteBeacons];
    [self hideDialog:self.internetOfThingsDialog withContent:self.internetOfThingsDialogContent andShadow:self.internetOfThingsDialogShadow];
    [self presentInternetOfThingsViewController];
}

- (IBAction)didTapRunningSkipButton:(id)sender {
    [self stopTrackingSteps];
    [self hideDialog:self.runningDialog withContent:self.runningDialogContent andShadow:self.runningDialogShadow];
    [self presentRunningViewController];
}

- (void)showDialog:(UIView *)dialog withContent:(UIView *)content andShadow:(UIView *)shadow {
    UIWindow *window = self.view.window;
    RootViewController *rootViewController = (RootViewController *) window.rootViewController;
    [rootViewController fadeOutWithDuration:0.3];
    
    shadow.alpha = 0.0f;
    
    dialog.frame = window.bounds;
    [window addSubview:dialog];
    
    CGRect frame = content.frame;
    frame.origin.y = CGRectGetHeight(dialog.frame);
    content.frame = frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        shadow.alpha = 1.0f;
        content.frame = CGRectOffset(content.frame, 0.0f, -CGRectGetHeight(content.frame));
    }];
}

- (void)hideDialog:(UIView *)dialog withContent:(UIView *)content andShadow:(UIView *)shadow {
    UIWindow *window = self.view.window;
    RootViewController *rootViewController = (RootViewController *) window.rootViewController;
    [rootViewController fadeInWithDuration:0.3];
    
    [UIView animateWithDuration:0.3 animations:^{
        shadow.alpha = 0.0f;
        content.frame = CGRectOffset(content.frame, 0.0f, CGRectGetHeight(content.frame));
    } completion:^(BOOL finished) {
        [dialog removeFromSuperview];
    }];
}

- (void)presentInternetOfThingsViewController {
    InternetOfThingsViewController *viewController = [[InternetOfThingsViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)presentRunningViewController {
    RunningViewController *viewController = [[RunningViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - Estimote presence

- (void)startRangingEstimoteBeacons {
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    for (NSUUID *uuid in @[ ESTIMOTE_PROXIMITY_UUID, ESTIMOTE_MACBEACON_PROXIMITY_UUID, ESTIMOTE_IOSBEACON_PROXIMITY_UUID ]) {
        ESTBeaconRegion *region = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        [self.beaconManager startRangingBeaconsInRegion:region];
    }
}

- (void)stopRangingEstimoteBeacons {
    self.beaconManager = nil;
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region {
    if (beacons.count > 0) {
        [self stopRangingEstimoteBeacons];
        [self hideDialog:self.internetOfThingsDialog withContent:self.internetOfThingsDialogContent andShadow:self.internetOfThingsDialogShadow];
        [self presentInternetOfThingsViewController];
    }
}

- (void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"locationManager: rangingBeaconsDidFailForRegion: withError:%@", error);
}


#pragma mark - Trackings steps

- (void)startTrackingSteps {
    if (![CMStepCounter isStepCountingAvailable]) {
        NSString *message = @"You won't be able to use this feature because your device doesn't have M7 chip. Please tap the skip button.";
        [[[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    
    self.stepCounter = [[CMStepCounter alloc] init];
    [self.stepCounter startStepCountingUpdatesToQueue:self.operationQueue updateOn:1 withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger stepsLeft = MAX(10 - numberOfSteps, 0);
            self.runningDialogLabel.text = [NSString stringWithFormat:@"To show the content you have to walk %ld steps", (long)stepsLeft];
            if (stepsLeft == 0) {
                [self stopTrackingSteps];
                [self hideDialog:self.runningDialog withContent:self.runningDialogContent andShadow:self.runningDialogShadow];
                [self presentRunningViewController];
            }
        });
    }];
}

- (void)stopTrackingSteps {
    [self.stepCounter stopStepCountingUpdates];
    self.stepCounter = nil;
}

@end
