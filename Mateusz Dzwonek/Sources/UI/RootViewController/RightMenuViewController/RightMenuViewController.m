//
//  RightMenuViewController.m
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 11/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "RightMenuViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>


@interface RightMenuViewController () <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic) IBOutlet UIView *titleShadowView;
@property (nonatomic) IBOutlet UIView *contentView;

@end


@implementation RightMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.titleShadowView.frame;
    frame.origin.y += 0.5f;
    frame.size.height = 0.5f;
    self.titleShadowView.frame = frame;
    
    self.contentView.layer.cornerRadius = 5.0f;
}

- (IBAction)didTapMailButton:(id)sender {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    controller.toRecipients = @[ @"mateusz.dzwonek@gmail.com" ];
    [self presentViewController:controller animated:YES completion:NULL];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)didTapPhoneButton:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"+48609398232" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://+48609398232"]];
    }
}

- (IBAction)didTapLinkedInButton:(id)sender {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:@"linkedin://profile/138915933"];
    if ([application canOpenURL:url]) {
        [application openURL:url];
    } else {
        [application openURL:[NSURL URLWithString:@"http://www.linkedin.com/in/mateuszdzwonek"]];
    }
}

- (IBAction)didTapTwitterButton:(id)sender {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:@"@mateuszdzwonek "];
    
    __weak SLComposeViewController *weakController = controller;
    controller.completionHandler = ^(SLComposeViewControllerResult result) {
        [weakController dismissViewControllerAnimated:YES completion:nil];
    };
        
    [self presentViewController:controller animated:YES completion:Nil];
}

- (IBAction)didTapGitHubButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.github.com/mdzwonek"]];
}

@end
