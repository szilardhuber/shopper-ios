//
//  SPMasterViewController.m
//  shopper
//
//  Created by Tamás Koródi on 14/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import "SPMasterViewController.h"

#import "KYPullToActionController.h"
#import "SPInputCell.h"
#import "SPSuggestionFetcher.h"
#import "Item.h"
#import "ItemName.h"
#import "List.h"
#import "ListTableViewCell.h"
#import "SPGradientColor.h"

@interface SPMasterViewController () {
    KYPullToActionController* _pullToActionController;
    BOOL _userChange;
    List* _mainList;
    SPSuggestionFetcher* _suggestionfetcher;
    SPGradientColor* _gradientColor;
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
    _suggestionfetcher = SPSuggestionFetcher.new;
    UIColor *endColor = [UIColor colorWithRed:0.28235294117647 green:0.41960784313725 blue:0.03137254901961 alpha:0.8];
    UIColor *startColor = [UIColor colorWithRed:0.43529411764706 green:0.64705882352941 blue:0.06274509803922 alpha:0.8];
    _gradientColor = [SPGradientColor initWithStartColor:startColor endColor:endColor colorCount:5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_lock_HR"] style: UIBarButtonItemStylePlain target:self action:@selector(lockScreen:)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (SPDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // Navigation controller
    [[self.navigationController navigationBar] setTintColor:[UIColor greenColor]];
    [[self.navigationController navigationBar] setBarTintColor:[UIColor colorWithRed:0.133 green:0.133 blue:0.133 alpha:1]]; /*#222222*/
    [[self.navigationController navigationBar] setTranslucent:NO];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shopzenion"]];
    
    // Override table view default display settings
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1.0];
    
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

- (void)lockScreen:(id)sender
{
    
}

- (void)insertNewObject:(id)sender
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];

    Item* newItem = [Item newEntity];
    newItem.orderingID = [NSNumber numberWithUnsignedInteger:[sectionInfo numberOfObjects]];
    newItem.list = _mainList;
    [Item commit];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [_gradientColor getColorForRow:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // KOTYO hack - remove it later
//    self.title = [NSString stringWithFormat:@"[shopzenion] - %lu", (unsigned long)[_list.items count]];

    SPInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:@"newitem" forIndexPath:indexPath];
    inputCell.backgroundColor = [_gradientColor getColorForRow:indexPath.row];

    [self configureCell:inputCell atIndexPath:indexPath];
    
    if (inputCell.item.name == nil) {
        [inputCell edit];
    }
    return inputCell;
//    else {
//        Item *item = (Item*)[self.fetchedResultsController objectAtIndexPath:indexPath];
//        ListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:@"listitem" forIndexPath:indexPath];
//        listCell.name.backgroundColor = [UIColor greenColor];
//        listCell.name.text = item.name.name;
//        return listCell;
//    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteItemAtIdexPath:indexPath];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    _userChange = YES;
    NSInteger movement = [self moveItemsFromRow:fromIndexPath.row toRow:toIndexPath.row];
    
    Item* affectedItem = [self.fetchedResultsController.fetchedObjects objectAtIndex:[fromIndexPath row]];
    if (movement > 0) {
        Item* prevItem = [self.fetchedResultsController.fetchedObjects objectAtIndex:[toIndexPath row]];
        if (prevItem.done.boolValue) {
            affectedItem.done = [NSNumber numberWithBool:YES];
        }
    }
    if (movement < 0) {
        Item* nextItem = [self.fetchedResultsController.fetchedObjects objectAtIndex:[toIndexPath row]];
        if (!nextItem.done.boolValue) {
            affectedItem.done = [NSNumber numberWithBool:NO];
        }
    }

    SPInputCell *cell = (SPInputCell*)[tableView cellForRowAtIndexPath:fromIndexPath];
    cell.backgroundColor = [_gradientColor getColorForRow:toIndexPath.row];
}

// Ret Value: -1 - moved up; 0 - stayed in place; 1 - moved down
- (NSInteger)moveItemsFromRow:(NSUInteger)fromRow toRow:(NSUInteger)toRow
{
    NSInteger movement = 0;
    NSInteger delta = (fromRow < toRow) ? 1 : -1;
    NSInteger changedOffset = -delta*labs(toRow-fromRow);
    
    // Affected row
    Item* affectedItem = [self.fetchedResultsController.fetchedObjects objectAtIndex:fromRow];
    affectedItem.orderingID = [NSNumber numberWithInteger:affectedItem.orderingID.intValue + changedOffset];
    if (toRow > fromRow) {
        movement = 1;
    }
    if (toRow < fromRow) {
        movement = -1;
    }
    
    // All the other rows
    for (NSUInteger currentRow = toRow; fromRow != currentRow; currentRow -= delta) {
        Item* item = [self.fetchedResultsController.fetchedObjects objectAtIndex:currentRow];
        item.orderingID = [NSNumber numberWithInteger:item.orderingID.intValue+delta];
    }
    return movement;
}

// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    Item* item = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
//    return !item.done.boolValue;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO kotyo: implement if needed!
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    // -- Create a placeholder list if needed
    if (!_mainList) {
        _mainList = [List getWithPredicate:[NSPredicate predicateWithFormat:@"name == %@", @"Main"] error:NULL];
        if (!_mainList) {
            _mainList = [List newEntity];
            _mainList.name = @"Main";
            [List commit];
        }
    }
    
    NSManagedObjectContext* context = [Item managedObjectContextForCurrentThreadWithError:NULL];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [Item entityDescriptionWithError:NULL];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setRelationshipKeyPathsForPrefetching:@[@"name.name"]];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Set predicate
    NSPredicate* itemPredicate = [NSPredicate predicateWithFormat:@"list == %@", _mainList];
    fetchRequest.predicate = itemPredicate;
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptorOrderingID = [[NSSortDescriptor alloc] initWithKey:@"orderingID" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptorOrderingID]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Master"];
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
    Item* changedItem = (Item*)anObject;
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
    
    // No matter if it is a user change we should check and update position if needed
    if (type == NSFetchedResultsChangeUpdate) {
        [self updateItemPositionAccordingDoneStatus:changedItem];
    }
}

- (void)updateItemPositionAccordingDoneStatus:(Item*)item
{
    NSArray* items = self.fetchedResultsController.fetchedObjects;
    NSIndexPath* currentIndex = [self.fetchedResultsController indexPathForObject:item];
    NSIndexPath* lastUnfinishedIndex = currentIndex;
    
    if ([item.done boolValue]) {
        // Find the last unfinished row from the bottom
        for (NSInteger idx = [items count]-1; idx >= 0; --idx) {
            Item* currentItem = items[idx];
            lastUnfinishedIndex = [self.fetchedResultsController indexPathForObject:currentItem];
            if (![currentItem.done boolValue]) {
                break;
            }
        }
    } else {
        // Find the last unfinished row from the top
        for (NSInteger idx = 0; idx < [items count]; ++idx) {
            Item* currentItem = items[idx];
            lastUnfinishedIndex = [self.fetchedResultsController indexPathForObject:currentItem];
            if ([currentItem.done boolValue]) {
                break;
            }
        }
    }
    
    if (([currentIndex row] > [lastUnfinishedIndex row] && ![item.done boolValue]) ||
        ([currentIndex row] < [lastUnfinishedIndex row] && [item.done boolValue])) {
        [self moveItemsFromRow:[currentIndex row] toRow:[lastUnfinishedIndex row]];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (!_userChange) {
        [self.tableView endUpdates];
    }
    // kotyo hack
    else {
        [self.tableView reloadData];
    }
    
    for (SPInputCell* cell in self.tableView.visibleCells)
    {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
        cell.backgroundColor = [_gradientColor getColorForRow:indexPath.row];
    }
    
    // KOTYO hack - remove it later
    self.title = [NSString stringWithFormat:@"[shopzenion] - %lu [%lu]", (unsigned long)[self.fetchedResultsController.fetchedObjects count], (unsigned long)[_mainList.items count]];
    
    _userChange = NO;
    
    [Item commit];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Item *item = (Item*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    SPInputCell* inputCell = (SPInputCell*)cell;
    
    [inputCell setItem:item];
    inputCell.editEndedBlock = ^(SPInputCell* cell) {
        if (cell.item.name.name == nil || [cell.item.name.name isEqualToString:@""]) {
            NSIndexPath* deletableIndexPath = [self.tableView indexPathForCell:cell];
            [self deleteItemAtIdexPath:deletableIndexPath];
        }
    };
}

- (void)deleteItemAtIdexPath:(NSIndexPath*)indexPath
{
    // Decrase the ordering number before the deletable element
    for (NSInteger currentIndex = indexPath.row-1;
         currentIndex >= 0;
         --currentIndex)
    {
        Item *item = [self.fetchedResultsController.fetchedObjects objectAtIndex:currentIndex];
        item.orderingID = [NSNumber numberWithInteger:item.orderingID.intValue-1];
    }
    
    // Delete the element
    Item* deletableItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [deletableItem delete];
}

#pragma mark - MLP Autocompletion Text Field data source
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void(^)(NSArray *suggestions))handler
{
    [_suggestionfetcher giveSuggestionsFor:string
                                 byHandler:handler];
}

@end

