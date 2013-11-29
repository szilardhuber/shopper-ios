//
//  SPMasterViewController.m
//  shopper
//
//  Created by Tamás Koródi on 14/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import "SPMasterViewController.h"

#import "SPDetailViewController.h"

#import "KYPullToActionController.h"
#import "SPInputCell.h"
#import "Item.h"
#import "List.h"

@interface SPMasterViewController () {
    KYPullToActionController* _pullToActionController;
    BOOL _userChange;
    List* _list;
}
@end

@implementation SPMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
    
    [self initialize];
}

- (void)initialize
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (SPDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Navigation controller
    [[self.navigationController navigationBar] setTintColor:[UIColor greenColor]];
    
    // Pull to add
    if (!_pullToActionController) {
        self.pullToActionLabel.frame = CGRectMake(0.0, 0.0,
                                                  self.tableView.frame.size.width,
                                                  self.tableView.rowHeight);
        _pullToActionController = [[KYPullToActionController alloc] initWithScrollView:self.tableView triggerView:self.pullToActionLabel stateChangeHandler:^(UIView *label, BOOL isActive) {
            if (isActive)   self.pullToActionLabel.text = @"Release To Add";
                else        self.pullToActionLabel.text = @"Pull To Add";
        } actionHandler:^{
            [self insertNewObject:self];
        }];
        [self.tableView setDelegate:(id<UITableViewDelegate>)_pullToActionController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.fetchedResultsController = nil;
}

- (void)insertNewObject:(id)sender
{
    //_userChange = YES;
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    Item* newItem = (Item*)[NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
    newItem.orderingID = [NSNumber numberWithUnsignedInteger:[sectionInfo numberOfObjects]];
    newItem.list = _list;
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newitem" forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];
    
    if (cell.item.name == nil) {
        [cell edit];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    _userChange = YES;
    NSUInteger fromRow = fromIndexPath.row;
    NSUInteger toRow = toIndexPath.row;
    NSInteger delta = (fromRow < toRow) ? 1 : -1;
    NSInteger changedOffset = -delta*labs(toRow-fromRow);
    
    // All the other rows
    for (; fromRow != toRow; toRow -= delta) {
        Item* item = [self.fetchedResultsController.fetchedObjects objectAtIndex:toRow];
        item.orderingID = [NSNumber numberWithInteger:item.orderingID.intValue+delta];
    }
    
    // Affected row
    Item* item = [self.fetchedResultsController.fetchedObjects objectAtIndex:fromRow];
    item.orderingID = [NSNumber numberWithInteger:item.orderingID.intValue + changedOffset];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item* item = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    return !item.done.boolValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO kotyo: implement if needed!
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //TODO kotyo: implement if needed!
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    //
    NSEntityDescription *listEntity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest* listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listEntity];
    [listRequest setFetchBatchSize:1];
    NSPredicate* listPredicate = [NSPredicate predicateWithFormat:@"name == %@", @"Main"];
    listRequest.predicate = listPredicate;
    NSError* err = nil;
    _list = (List*)[self.managedObjectContext executeFetchRequest:listRequest error:&err].lastObject;
    if (err)
    {
        NSLog(@"Error while fetching objects: %@", [err description]);
        return nil;
    }
    if (_list == nil) { //create
        _list = (List*)[NSEntityDescription insertNewObjectForEntityForName:[listEntity name] inManagedObjectContext:self.managedObjectContext];
        _list.name = @"Main";
        if (![self.managedObjectContext save:&err]) {
            NSLog(@"Unresolved error %@, %@", err, [err userInfo]);
            abort();
        }
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Set predicate
    NSPredicate* itemPredicate = [NSPredicate predicateWithFormat:@"list == %@", _list];
    fetchRequest.predicate = itemPredicate;
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptorDone = [[NSSortDescriptor alloc] initWithKey:@"done" ascending:YES];
    NSSortDescriptor *sortDescriptorOrderingID = [[NSSortDescriptor alloc] initWithKey:@"orderingID" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptorDone, sortDescriptorOrderingID];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!_userChange) {
        [self.tableView beginUpdates];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (!_userChange) {
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!_userChange) {
        UITableView *tableView = self.tableView;
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (!_userChange) {
        [self.tableView endUpdates];
    }
    _userChange = NO;
    
    NSError* err = nil;
    [self.fetchedResultsController.managedObjectContext save:&err];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Item *item = (Item*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [(SPInputCell*)cell setItem:item];
}


@end
