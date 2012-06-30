//
//  StoreDetailViewController.m
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//

#import "FFAStoreDetailViewController.h"



@interface FFAStoreDetailViewController ()

@end

@implementation FFAStoreDetailViewController
@synthesize logoImageView;
@synthesize nameLabel;
@synthesize addressLabel;
@synthesize cityStateZipLabel;
@synthesize callButton;
@synthesize store;

#pragma mark - call

- (IBAction)callStore:(id)sender
{
    
}


#pragma mark - lifeCycle

- (id)initWithStore:(FFAStore*)aStore
{
    self = [super initWithNibName:@"FFAStoreDetailViewController" bundle:nil];
    if (!self)
        return nil;
    
    self.store = aStore;

    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",self.store.name];
    self.addressLabel.text = [NSString stringWithFormat:@"%@",self.store.address];
    self.cityStateZipLabel.text = [NSString stringWithFormat:@"%@, %@  %@",self.store.city,self.store.state,self.store.zip];
    if (store.logo) {
        self.logoImageView.image = store.logo;        
    }
}

- (void)viewDidUnload
{
    [self setLogoImageView:nil];
    [self setNameLabel:nil];
    [self setAddressLabel:nil];
    [self setCityStateZipLabel:nil];
    [self setCallButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [logoImageView release];
    [nameLabel release];
    [addressLabel release];
    [cityStateZipLabel release];
    [callButton release];
    [super dealloc];
}
@end
