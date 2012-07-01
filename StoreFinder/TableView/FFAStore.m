//
//  Store.m
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//

#import "FFAStore.h"

@implementation FFAStore

@synthesize name;
@synthesize city;
@synthesize address;
@synthesize state;
@synthesize zip;
@synthesize phone;
@synthesize logoURLPath;
@synthesize logo;
@synthesize location;

+(FFAStore*)storeFromDictionary:(NSDictionary*)dict
{
    FFAStore *store = [[FFAStore alloc] init];
    store.name = [dict objectForKey:@"name"];
    store.address = [dict objectForKey:@"address"];
    store.city = [dict objectForKey:@"city"];
    store.state = [dict objectForKey:@"state"];
    store.zip = [dict objectForKey:@"zipcode"];
    store.logoURLPath = [dict objectForKey:@"storeLogoURL"];
    store.phone = [dict objectForKey:@"phone"];
    NSNumber *lat = [dict objectForKey:@"latitude"];
    NSNumber *lon = [dict objectForKey:@"longitude"];
    
    if (lat && lon) {
        store.location = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
    }
    
    return store;
}

@end
