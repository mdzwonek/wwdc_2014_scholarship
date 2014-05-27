//
//  InternetOfThingsViewController.m
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 13/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "InternetOfThingsViewController.h"


@interface InternetOfThingsViewController ()

@property (nonatomic) IBOutlet UIImageView *screenshotImageView;

@end


@implementation InternetOfThingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenshotImageView.layer.shadowOffset = CGSizeZero;
    self.screenshotImageView.layer.shadowOpacity = 1.0f;
    self.screenshotImageView.layer.shadowRadius = 3.0f;
    self.screenshotImageView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2f] CGColor];
}

@end
