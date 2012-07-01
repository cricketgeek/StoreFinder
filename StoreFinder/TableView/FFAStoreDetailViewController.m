//
//  StoreDetailViewController.m
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//

#import "FFAStoreDetailViewController.h"

@implementation FFAStoreDetailViewController
@synthesize logoImageView;
@synthesize nameLabel;
@synthesize addressLabel;
@synthesize cityStateZipLabel;
@synthesize store;
@synthesize mapView;

#pragma mark - call

- (void)setupCallButton
{
    UIBarButtonItem *callButton = [[UIBarButtonItem alloc] initWithTitle:@"Call" style:UIBarButtonItemStyleBordered target:self action:@selector(callStore:)];
    self.navigationItem.rightBarButtonItem = callButton;
}

-(void)makeCall:(NSString*)number {
    NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",number];
    NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
    [[UIApplication sharedApplication] openURL:phoneURL];
    [phoneURL release];
    [phoneStr release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self makeCall:[self.store phone]];
    }
}

- (IBAction)callStore:(id)sender {
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Call %@",self.store.name] message:@"Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

#pragma mark - mapview

- (void)zoomToStoreLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.store.location.coordinate, 500, 500);
    [self.mapView setRegion:region animated:YES];
}

- (void)setLocation
{
    if (self.store.location) {
        
        MKPointAnnotation *storePointAnnotation = [[MKPointAnnotation alloc] init];
        storePointAnnotation.coordinate = self.store.location.coordinate;
        [self.mapView addAnnotation:storePointAnnotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    static NSString *StoreViewIdentifier = @"StoreViewIdentifier";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[aMapView 
                                                                  dequeueReusableAnnotationViewWithIdentifier:StoreViewIdentifier];
	if(annotationView == nil)
	{
		annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:StoreViewIdentifier] autorelease];
	}
	
    annotationView.pinColor = MKPinAnnotationColorGreen;    
    annotationView.animatesDrop=TRUE;
    annotationView.canShowCallout = YES;
    
    return annotationView;
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
    [self setupCallButton];
    [self zoomToStoreLocation];
    [self setLocation];
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
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",store.name]];
}

- (void)viewDidUnload
{
    [self setLogoImageView:nil];
    [self setNameLabel:nil];
    [self setAddressLabel:nil];
    [self setCityStateZipLabel:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc {
    [logoImageView release];
    [nameLabel release];
    [addressLabel release];
    [cityStateZipLabel release];
    [mapView release];
    [super dealloc];
}
@end
