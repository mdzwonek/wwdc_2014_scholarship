//
//  ExperienceViewController.m
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 11/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "ExperienceViewController.h"
#import "HighschoolViewController.h"
#import "StudiesViewController.h"
#import "FirstJobViewController.h"
#import "LondonViewController.h"
#import "PresentViewController.h"


static const CGFloat TitleContentMultipler = 1.35f;


@interface ExperienceViewController () <UIScrollViewDelegate>

@property (nonatomic) IBOutlet UIView *titleContentView;
@property (nonatomic) IBOutlet UIView *titleBackgroundView;
@property (nonatomic) IBOutlet UIScrollView *scrollView;

@end


@implementation ExperienceViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"experience";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleBackgroundView.layer.shadowOffset = CGSizeZero;
    self.titleBackgroundView.layer.shadowOpacity = 1.0f;
    self.titleBackgroundView.layer.shadowRadius = 3.0f;
    self.titleBackgroundView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2f] CGColor];
    
    [self initializeChildViewControllers];
}

- (void)initializeChildViewControllers {
    
    static const CGFloat timelineOffset = 25.0f;
    
    NSArray *childViewControllers = @[ [[HighschoolViewController alloc] init], [[StudiesViewController alloc] init], [[FirstJobViewController alloc] init],
                                       [[LondonViewController alloc] init], [[PresentViewController alloc] init] ];
    
    for (NSInteger index = 0; index < childViewControllers.count; index++) {
        UIViewController *viewController = childViewControllers[index];
        [self addChildViewController:viewController];
        
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = index * CGRectGetWidth(self.scrollView.frame);
        viewController.view.frame = frame;
        [self.scrollView addSubview:viewController.view];
        
        
        UILabel *titleLabel = [self labelAtIndex:index andText:viewController.title];
        [self.titleContentView addSubview:titleLabel];
        
        UIView *timelineView = [[UIView alloc] init];
        
        frame.size.width = TitleContentMultipler * CGRectGetWidth(self.titleContentView.frame) - CGRectGetWidth(titleLabel.frame) - 2 * timelineOffset;
        frame.size.height = 2.0f;
        frame.origin.x = CGRectGetMaxX(titleLabel.frame) + timelineOffset;
        frame.origin.y = (CGRectGetHeight(self.titleContentView.frame) - CGRectGetHeight(frame)) / 2.0f + 2.0f;
        timelineView.frame = frame;
        timelineView.backgroundColor = [UIColor colorWithRed:0.424 green:0.686 blue:0.604 alpha:1];
        timelineView.layer.cornerRadius = CGRectGetHeight(timelineView.frame) / 2.0f;
        [self.titleContentView addSubview:timelineView];
    }
    
    UILabel *futureLabel = [self labelAtIndex:childViewControllers.count andText:@"future"];
    [self.titleContentView addSubview:futureLabel];
    
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    scrollViewContentSize.width = childViewControllers.count * CGRectGetWidth(self.scrollView.frame);
    self.scrollView.contentSize = scrollViewContentSize;
    
    CGRect frame = self.titleContentView.frame;
    frame.size.width = TitleContentMultipler * childViewControllers.count * CGRectGetWidth(self.view.frame);
    self.titleContentView.frame = frame;
}

- (UILabel *)labelAtIndex:(NSInteger)index andText:(NSString *)text {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0f];
    titleLabel.text = text;
    titleLabel.textColor = [UIColor darkGrayColor];
    
    static const CGFloat offset = 30.0f;
    CGRect frame;
    frame.origin = CGPointMake(TitleContentMultipler * (index * CGRectGetWidth(self.titleContentView.frame) + offset), 0.0f);
    frame.size = self.titleContentView.frame.size;
    titleLabel.frame = frame;
    [titleLabel sizeToFit];
    frame = titleLabel.frame;
    frame.size.height = CGRectGetHeight(self.titleContentView.frame);
    titleLabel.frame = frame;
    return titleLabel;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.titleContentView.frame;
    frame.origin.x = -TitleContentMultipler * scrollView.contentOffset.x;
    self.titleContentView.frame = frame;
}

@end
