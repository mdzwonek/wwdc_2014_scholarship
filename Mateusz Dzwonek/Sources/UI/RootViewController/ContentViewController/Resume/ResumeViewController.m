//
//  ResumeViewController.m
//  Mateusz Dzwonek
//
//  Created by Mateusz Dzwonek on 11/04/2014.
//  Copyright (c) 2014 Mateusz Dzwonek. All rights reserved.
//

#import "ResumeViewController.h"
#import "PDFScrollView.h"


@interface ResumeViewController ()

@property (nonatomic) IBOutlet PDFScrollView *pdfScrollView;

@end


@implementation ResumeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"resume";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *pdfURL = [[NSBundle mainBundle] URLForResource:@"Resume" withExtension:@"pdf"];
    
    CGPDFDocumentRef PDFDocument = CGPDFDocumentCreateWithURL((__bridge CFURLRef)pdfURL);
    
    CGPDFPageRef PDFPage = CGPDFDocumentGetPage(PDFDocument, 1);
    [self.pdfScrollView setPDFPage:PDFPage];
    
    CGPDFDocumentRelease(PDFDocument);
}

@end
