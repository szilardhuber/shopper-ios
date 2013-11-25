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

@interface SPMasterViewController () {
    NSMutableArray *_objects;
    KYPullToActionController* _pullToActionController;
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
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:NSMutableString.new atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newitem" forIndexPath:indexPath];
//        return cell;
//    }
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newitem" forIndexPath:indexPath];
    SPInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newitem" forIndexPath:indexPath];

    NSMutableString *string = _objects[indexPath.row];
    [cell setText:string];
    if ([string isEqualToString:@""]) {
        [cell edit];
    }
//    cell.textLabel.text = [object description];
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
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
