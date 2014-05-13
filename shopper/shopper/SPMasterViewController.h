//
//  SPMasterViewController.h
//  shopper
//
//  Created by Tamás Koródi on 14/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MLPAutoCompleteTextField.h"

@class SPDetailViewController;

@interface SPMasterViewController : UITableViewController
<NSFetchedResultsControllerDelegate, MLPAutoCompleteTextFieldDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) SPDetailViewController *detailViewController;
@property (strong, nonatomic) IBOutlet UILabel *pullToActionLabel;

@end
