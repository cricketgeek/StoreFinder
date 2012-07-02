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
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;

@end
