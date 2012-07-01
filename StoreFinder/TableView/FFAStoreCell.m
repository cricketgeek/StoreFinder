//
//  FFAStoreCell.m
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//

#import "FFAStoreCell.h"

@implementation FFAStoreCell

@synthesize logoImageView;
@synthesize phoneLabel;
@synthesize addressLabel;

- (void)setLogoImage:(UIImage*)anImage
{
    NSLog(@"setLogoImage: called");
    [UIView beginAnimations:@"setStoreLogo" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    self.logoImageView.image = anImage;

    [UIView commitAnimations];
}

- (void)change
{
    [self.logoImageView setNeedsDisplay];
}

@end
