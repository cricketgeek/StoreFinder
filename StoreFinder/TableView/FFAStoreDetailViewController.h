//
//  StoreDetailViewController.h
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//
#import "FFAStore.h"

@interface FFAStoreDetailViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIImageView *logoImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *cityStateZipLabel;
@property (retain, nonatomic) IBOutlet UIButton *callButton;
@property (nonatomic, retain) FFAStore *store;


- (id)initWithStore:(FFAStore*)aStore;

@end
