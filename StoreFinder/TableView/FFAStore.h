//
//  Store.h
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface FFAStore : NSObject
@property (nonatomic, retain) UIImage *logo;
@property (nonatomic, retain) NSString *logoURLPath;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) CLLocation *location;

+(FFAStore*)storeFromDictionary:(NSDictionary*)dict;

@end
