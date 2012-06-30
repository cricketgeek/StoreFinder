//
//  TableViewController.h
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//
#import "FFAStoresRequest.h"
#import "FFAStoreCell.h"

@interface FFAStoreListViewController : UITableViewController <FFAStoresRequestDelegate> {
    FFAStoresRequest *_storeRequest;
}

@property (nonatomic, retain) NSArray *stores;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (retain, nonatomic) IBOutlet FFAStoreCell *ffaStoreCell;

@end
