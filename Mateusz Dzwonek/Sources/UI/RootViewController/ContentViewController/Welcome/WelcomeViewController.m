//
//  WelcomeViewController.m
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 14/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "WelcomeViewController.h"


@interface WelcomeViewController ()

@property (nonatomic) IBOutlet UIButton *startButton;

@end


@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startButton.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.startButton.layer.borderWidth = 1.0f;
    self.startButton.layer.cornerRadius = 3.0f;
}

- (IBAction)didTapStartButton:(id)sender {
    if (self.didTapStartButtonBlock != NULL) {
        self.didTapStartButtonBlock();
    }
}

@end
