//
//  LeftMenuViewController.m
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 11/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "LeftMenuViewController.h"
#import <MDSDK/MDSDK.h>


@interface TouchesPassingView : UIView

@property (nonatomic) IBOutlet UIButton *button;

@end


@implementation TouchesPassingView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return CGRectContainsPoint(self.button.frame, point);
}

@end


static const CGFloat MenuTransformationDelay = 0.0f;
static const CGFloat MenuTransformationMinAngle = DEGREES_TO_RADIANS(30.0f);
static const CGFloat MenuTransformationMaxAngle = DEGREES_TO_RADIANS(90.0f);
static const CGFloat MenuTransformationMaxTranslationX = -50.0;
static const CGFloat MenuTransformationMaxTranslationZ = 150.0;
static const CGFloat MenuTransformationM34 = 1.0f / -1500.0f;


@interface LeftMenuViewController ()

@property (nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic) IBOutlet UILabel *usernameLabel;

@end


@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO
    self.usernameLabel.text = @"Mateusz";
    self.profileImageView.image = [UIImage imageNamed:@"img_profile"];
    
    self.profileImageView.layer.borderWidth = 2.0f;
    self.profileImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageView.layer.cornerRadius = CGRectGetWidth(self.profileImageView.frame) / 2.0f;
    
    [self setAnchorPoints];
}

- (void)setAnchorPoints {
    CGFloat rotationArmPostionX = -CGRectGetWidth(self.view.frame);
    for (UIView *view in self.view.subviews) {
        CALayer *layer = view.layer;
        
        CGFloat distanceToArm = rotationArmPostionX - CGRectGetMinX(view.frame);
        CGFloat relativeDistance = distanceToArm / CGRectGetWidth(view.frame);
        
        CGRect frame = view.frame;
        layer.anchorPoint = CGPointMake(relativeDistance, layer.anchorPoint.y);
        view.frame = frame;
    }
}

- (void)applyMenuTransformations:(CGFloat)percentage {
    CGFloat delayedPercentage = 1.0f - (percentage - MenuTransformationDelay) / (1.0f - MenuTransformationDelay);
    
    for (NSInteger index = 0; index < self.view.subviews.count; index++) {
        UIView *view = [self.view.subviews objectAtIndex:index];
        CALayer *layer = view.layer;
        
        CGFloat viewPercentage = (float) (self.view.subviews.count - 1 - index) / (float) (self.view.subviews.count - 1);
        CGFloat angle = delayedPercentage * ((MenuTransformationMaxAngle - MenuTransformationMinAngle) * viewPercentage + MenuTransformationMinAngle);
        CGFloat translationX = delayedPercentage * MenuTransformationMaxTranslationX;
        CGFloat translationZ = delayedPercentage * MenuTransformationMaxTranslationZ;
        
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = MenuTransformationM34;
        transform = CATransform3DRotate(transform, angle, 0.0f, -1.0f, 0.0f);
        transform = CATransform3DTranslate(transform, translationX, 0.0f, translationZ);
        layer.transform = transform;
    }
}

- (IBAction)didTapExperienceButton:(id)sender {
    if (self.didTapExperienceButtonBlock != NULL) {
        self.didTapExperienceButtonBlock();
    }
}

- (IBAction)didTapResumeButton:(id)sender {
    if (self.didTapResumeButtonBlock != NULL) {
        self.didTapResumeButtonBlock();
    }
}

- (IBAction)didTapHobbiesBlock:(id)sender {
    if (self.didTapHobbiesButtonBlock != NULL) {
        self.didTapHobbiesButtonBlock();
    }
}

- (IBAction)didTapAppleBugsButton:(id)sender {
    if (self.didTapAppleBugsButtonBlock != NULL) {
        self.didTapAppleBugsButtonBlock();
    }
}


@end
