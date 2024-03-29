//
//  TableViewController.m
//  StoreFinder
//
//  Created by Mark Jones on 6/30/12.
//  Copyright (c) 2012 Geordie Enterprises LLC. All rights reserved.
//

#import "FFAStoreListViewController.h"

#import "CJSONDeserializer.h"
#import "FFAStore.h"
#import "FFAStoreDetailViewController.h"

#import "UIImage+Additions.h"

#define ROW_HEIGHT 110

@implementation FFAStoreListViewController

@synthesize stores;
@synthesize queue;
@synthesize ffaStoreCell;
@synthesize cellNib;
@synthesize loadedLogos;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [self.queue cancelAllOperations];
    self.queue = nil;
    self.stores = nil;
    self.ffaStoreCell = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loadedLogos = [NSMutableDictionary dictionary];
    self.queue = [[[NSOperationQueue alloc] init] autorelease];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Stores"]];
    self.cellNib = [UINib nibWithNibName:@"FFAStoreCell" bundle:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.stores && !_storeRequest) {
        [self fetchAndParseData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setFfaStoreCell:nil];
    self.queue = nil;
    self.cellNib = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.stores count];
}

- (void)configureCell:(FFAStoreCell*)cell forIndexPath:(NSIndexPath*)indexPath
{
    FFAStore *store = [self.stores objectAtIndex:indexPath.row];
    cell.phoneLabel.text = store.phone;
    cell.addressLabel.text = store.address;
    
    if (!store.logo) {
        if ([self.loadedLogos objectForKey:store.logoURLPath]) {
            store.logo = [self.loadedLogos objectForKey:store.logoURLPath];
            cell.logoImageView.image = store.logo;
        }
        else {
            [self.queue addOperationWithBlock:^{
                NSString * logoPath = store.logoURLPath;
                NSURL * logoURL = [NSURL URLWithString:logoPath];
                NSData *imageData = [NSData dataWithContentsOfURL:logoURL];            
                
                //Load image on mainQueue/main thread
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{ 
                    if (imageData) {
                        UIImage *image = [UIImage imageWithData:imageData];
                        store.logo = [image sizeForCell];
                        
                        FFAStoreCell *cell = (FFAStoreCell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
                        cell.logoImageView.image = store.logo;
                        if (![self.loadedLogos objectForKey:store.logoURLPath]) {
                            [self.loadedLogos setObject:store.logo forKey:store.logoURLPath];
                        }
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];                        
                    }
                }];
            }];
        }        
    }
    else {
        cell.logoImageView.image = store.logo;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoreCell";
    FFAStoreCell *cell = (FFAStoreCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        [self.cellNib instantiateWithOwner:self options:nil];
        cell = self.ffaStoreCell;
        self.ffaStoreCell = nil;
    }
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFAStore *store = [self.stores objectAtIndex:indexPath.row];
    FFAStoreDetailViewController *detailViewController = [[FFAStoreDetailViewController alloc] initWithStore:store];
    [detailViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark - FFAStoresRequest

- (void)fetchAndParseData
{
    _storeRequest = [FFAStoresRequest startRequestForStoresWithDelegate:self];
}

- (void)request:(FFAStoresRequest *)request didFinishWithObject:(id)object
{
    [self.queue addOperationWithBlock:^{
        
        CJSONDeserializer *deserializer = [CJSONDeserializer deserializer];
        deserializer.nullObject = NULL;
        NSError *aError = nil;
        id deserializedObject = [deserializer deserialize:object error:&aError];
        NSArray *storeDicts = [deserializedObject objectForKey:@"stores"];
        [object release];
        NSMutableArray *localStores = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in storeDicts) {
            [localStores addObject:[FFAStore storeFromDictionary:dict]];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.stores = [localStores copy];
            [self.tableView reloadData];
        }];
        
        [localStores release];
    }];
}

- (void)request:(FFAStoresRequest*)request didFailWithError:(NSError*)error
{
    NSLog(@"Error loading json data...");
}

@end
