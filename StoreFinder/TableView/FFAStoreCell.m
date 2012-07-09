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

CGRect rectFor1PxStroke(CGRect rect)
{
    return CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1);
}

- (void)drawText:(CGContextRef)context
{
    self.highlighted ? [[UIColor whiteColor] set] : [[UIColor blackColor] set];    
    
    CGContextSaveGState(context);
    CGRect textRect = CGRectMake(10.0, 56.0, 280.0, 50.0);
    CGContextAddRect(context, textRect);
    CGContextClip(context);
    
    [[NSString stringWithFormat:@"%@", self.phone] drawAtPoint:CGPointMake(10.0, 76.0) withFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
    
    [[NSString stringWithFormat:@"%@", self.address] drawAtPoint:CGPointMake(125.0, 76.0) withFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
        
    CGContextRestoreGState(context);
}

- (void)drawBorderRect:(CGContextRef)context
{
    CGColorRef whiteColor = [UIColor whiteColor].CGColor;
    
    CGRect strokeRect = rectFor1PxStroke(CGRectInset(self.bounds, 5.0, 5.0));
    
    CGContextSetStrokeColorWithColor(context, whiteColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);
    
}

- (void)draw1PxStroke:(CGContextRef)context start:(CGPoint)startPoint end:(CGPoint)endPoint color:(CGColorRef)colorRef
{
    CGContextSaveGState(context);
    
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, colorRef);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

- (void)drawSeparator:(CGContextRef)context
{
    CGColorRef separatorColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 
                                                 blue:208.0/255.0 alpha:1.0].CGColor;
    CGPoint startPoint = CGPointMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height - 1);
    CGPoint endPoint = CGPointMake(self.bounds.origin.x + self.bounds.size.width - 1, self.bounds.origin.y + self.bounds.size.height - 1);
    [self draw1PxStroke:context start:startPoint end:endPoint color:separatorColor];
}

- (void)drawGradientBackground:(CGContextRef)context
{
    id whiteColorRef = [UIColor whiteColor].CGColor;
    //id lightGrayColor = [UIColor lightGrayColor].CGColor;
    id lightGrayColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 
                                                 blue:230.0/255.0 alpha:1.0].CGColor;
    NSArray *colors = [NSArray arrayWithObjects:whiteColorRef,lightGrayColor, nil];
    
    CGFloat locations[] = { 0.0, 1.0 };
    CGRect rect = self.bounds;
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(baseSpace, (CFArrayRef)colors, locations);

    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(baseSpace), 
    baseSpace = NULL;    
    
}

- (void)drawLogo:(CGContextRef)context
{
    if (!self.logo) {
        self.logo = [UIImage imageNamed:@"defaultStoreLogo.png"];
    }
    
    [self.logo drawAtPoint:CGPointMake(6.0, 6.0)];
}

- (void)drawMidLine:(CGContextRef)context
{
    CGContextSetLineWidth(context, 1);    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,5.0, 52.0);
    CGPathAddLineToPoint(path, NULL, 315.0, 52.0);
    CGContextAddPath(context, path);
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGPathRelease(path);

}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    [self drawGradientBackground:context];
    [self drawBorderRect:context];
    [self drawText:context];
    [self drawLogo:context];
    //[self drawMidLine:context];
    [self drawSeparator:context];
    
    
}

@end
