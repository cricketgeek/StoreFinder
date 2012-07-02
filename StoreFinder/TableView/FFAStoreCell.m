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

- (void)dealloc
{    
    [self.logo release];
    [super dealloc];
}

- (void)setLogoImage:(UIImage*)anImage
{
    NSLog(@"setLogoImage: called");
    self.logo = anImage;
    [self setNeedsDisplay];
}

- (void)drawText:(CGContextRef)context
{
    self.highlighted ? [[UIColor whiteColor] set] : [[UIColor blackColor] set];    
    
    [[NSString stringWithFormat:@"%@", self.phone] drawAtPoint:CGPointMake(10.0, 76.0) withFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
    
    [[NSString stringWithFormat:@"%@", self.address] drawAtPoint:CGPointMake(125.0, 76.0) withFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
    
}

- (void)drawGradientBackground:(CGContextRef)context
{
    CGRect rectangle = CGRectMake(0, 55, 320, 55);
    CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextFillRect(context, rectangle);
    
    CGFloat colors [] = { 
        1.0, 1.0, 1.0, 1.0, 
        0.5, 0.5, 0.5, 1.0
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0,65.0), CGPointMake(320.0, 95.0), 0);
    
}

- (void)drawLogo:(CGContextRef)context
{
    if (!self.logo) {
        self.logo = [UIImage imageNamed:@"defaultStoreLogo.png"];
    }
    
    [self.logo drawAtPoint:CGPointMake(5.0, 5.0)];
}

- (void)drawMidLine:(CGContextRef)context
{
    CGContextSetLineWidth(context, 1);    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,0.0, 52.0);
    CGPathAddLineToPoint(path, NULL, 320.0, 52.0);
    CGContextAddPath(context, path);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    [self drawGradientBackground:context];
    [self drawText:context];
    [self drawLogo:context];
    [self drawMidLine:context];
    
}

@end
