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

#define LOGO_WIDTH 300
#define LOGO_HEIGHT 60

@interface FFAStoreListViewController ()

@end

@implementation FFAStoreListViewController

@synthesize stores;
@synthesize queue=_queue;
@synthesize ffaStoreCell = _ffaStoreCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [_queue cancelAllOperations];
    [_queue release];
    _queue = nil;
    [_ffaStoreCell release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.queue = [[NSOperationQueue alloc] init];
    
    [self.navigationItem setTitle:@"Stores"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    [self setFfaStoreCell:nil];
    [super viewDidUnload];
    self.queue = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    
    //TODO: check for image on the model 
    if (!store.logo) {
        [self.queue addOperationWithBlock:^{
            NSString * logoPath = store.logoURLPath;
            NSURL * logoURL = [NSURL URLWithString:logoPath];
            NSData *imageData = [NSData dataWithContentsOfURL:logoURL];
            NSLog(@"Loaded image data from url %@ size %d",logoPath,[imageData length]);
            
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSLog(@"On mainqueue setting image size %d",[imageData length]);
                
                UIImage *image = [UIImage imageWithData:imageData];
                CGSize itemSize = CGSizeMake(LOGO_WIDTH, LOGO_HEIGHT);
                UIGraphicsBeginImageContext(itemSize);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [image drawInRect:imageRect];
                store.logo = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                FFAStoreCell *cell = (FFAStoreCell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
                //TOOD: set the image on the cell
                cell.logoImageView.image = store.logo;
            }];
        }];        
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
        [[NSBundle mainBundle] loadNibNamed:@"FFAStoreCell" owner:self options:nil];
        cell = self.ffaStoreCell;
        self.ffaStoreCell = nil;
    }
    
    // Configure the cell...
    [self configureCell:cell forIndexPath:indexPath];
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFAStore *store = [self.stores objectAtIndex:indexPath.row];
    FFAStoreDetailViewController *detailViewController = [[FFAStoreDetailViewController alloc] initWithStore:store];
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