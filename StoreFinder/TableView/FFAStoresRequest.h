//
//  FFAStoresRequest.h
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//
@class FFAStoresRequest;

@protocol FFAStoresRequestDelegate <NSObject>

- (void)request:(FFAStoresRequest*)request didFinishWithObject:(id)object;
- (void)request:(FFAStoresRequest*)request didFailWithError:(NSError*)error;

@end

@interface FFAStoresRequest : NSObject <NSURLConnectionDelegate>

@property (nonatomic, retain) NSURLRequest *request;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) id<FFAStoresRequestDelegate> delegate;
@property (nonatomic, retain) NSMutableData *receivedData;

+(FFAStoresRequest*)startRequestForStoresWithDelegate:(id<FFAStoresRequestDelegate>)aDelegate;

@end
