//
//  SPDetailViewController.h
//  shopper
//
//  Created by Tamás Koródi on 14/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
