//
//  FFAStoreCell.h
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFAStoreCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *logoImageView;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) UIImage *logo;


- (void)setLogoImage:(UIImage*)anImage;

@end
