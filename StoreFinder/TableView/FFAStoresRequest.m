//
//  FFAStoresRequest.m
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//

#import "FFAStoresRequest.h"


#define STORE_JSON_URL @"http://strong-earth-32.heroku.com/stores.aspx"

@implementation FFAStoresRequest

@synthesize request;
@synthesize connection;
@synthesize delegate;
@synthesize receivedData;

+(FFAStoresRequest*)startRequestForStoresWithDelegate:(id<FFAStoresRequestDelegate>)aDelegate
{
    FFAStoresRequest *ffaStoresRequest = [[[FFAStoresRequest alloc] init] autorelease];
    ffaStoresRequest.delegate = aDelegate;
    ffaStoresRequest.request = [NSURLRequest requestWithURL:[NSURL URLWithString:STORE_JSON_URL]];
    ffaStoresRequest.connection = [NSURLConnection connectionWithRequest:ffaStoresRequest.request delegate:ffaStoresRequest];
    if (ffaStoresRequest.connection) {
        ffaStoresRequest.receivedData = [[NSMutableData data] retain];
    } else {
        NSLog(@"Failed to connect to URL");
        //TODO: Inform the user that the connection failed.
    }
    return ffaStoresRequest;
}

- (void)dealloc
{
    self.request = nil;
    self.connection = nil;
    self.receivedData = nil;
    [super dealloc];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    NSLog(@"connection failed with error %@",[error localizedDescription]);
    if (self.delegate) {
        [self.delegate request:self didFailWithError:error];
    }

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (self.delegate) {
        [delegate request:self didFinishWithObject:self.receivedData];
    }
}

@end
