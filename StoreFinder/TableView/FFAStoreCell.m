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
@synthesize phone;
@synthesize address;
@synthesize logo;

- (void)setLogoImage:(UIImage*)anImage
{
    NSLog(@"setLogoImage: called");
//    [UIView beginAnimations:@"setStoreLogo" context:nil];
//    [UIView setAnimationDuration:0.3];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

    self.logoImageView.image = anImage;
    self.logo = anImage;
    
    // [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
//    [UIView commitAnimations];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGRect rectangle = CGRectMake(0, 65, 320, 55);
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextFillRect(context, rectangle);
    
//    CGFloat colors [] = { 
//        1.0, 1.0, 1.0, 1.0, 
//        1.0, 0.9, 0.8, 1.0
//    };
//    
//    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
//    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
//
//    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0,65.0), CGPointMake(320.0, 95.0), 0);
    
    self.highlighted ? [[UIColor whiteColor] set] : [[UIColor blackColor] set];    
    
    [[NSString stringWithFormat:@"%@", self.phone] drawAtPoint:CGPointMake(5.0, 86.0) withFont:[UIFont systemFontOfSize:12.0]];
    
    [[NSString stringWithFormat:@"%@", self.address] drawAtPoint:CGPointMake(115.0, 86.0) withFont:[UIFont systemFontOfSize:12.0]];
    
    if (!self.logo) {
        self.logo = [UIImage imageNamed:@"defaultStoreLogo.png"];
    }
    
    [self.logo drawAtPoint:CGPointMake(5.0, 5.0)];

    CGContextSetLineWidth(context, 2);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,0.0, 65.0);
    CGPathAddLineToPoint(path, NULL, 320.0, 65.0);
    CGContextAddPath(context, path);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);


    
}

@end
