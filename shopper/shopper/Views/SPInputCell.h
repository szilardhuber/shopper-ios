//
//  SPInputCell.h
//  shopper
//
//  Created by Tamás Koródi on 24/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"

@interface SPInputCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (nonatomic, strong) Item *item;

- (void)edit;
@end
