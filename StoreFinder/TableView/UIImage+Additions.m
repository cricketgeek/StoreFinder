//
//  UIImage+Additions.m
//  StoreFinder
//
//  Created by Mark Jones on 7/2/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//

#import "UIImage+Additions.h"

#define LOGO_WIDTH 190
#define LOGO_HEIGHT 40

@implementation UIImage (Additions)

-sizeForCell
{
    CGSize size = CGSizeMake(LOGO_WIDTH, LOGO_HEIGHT);

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    //TODO: deal with different orientations here
    //float ratio = MAX(size.width / self.size.width, size.height / self.size.height);
    CGRect imageRect;
    imageRect = CGRectMake(0,0,size.width,size.height);
    [self drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    return newImage;  
}

@end
