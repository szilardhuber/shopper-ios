//
//  SPInputCell.m
//  shopper
//
//  Created by Tamás Koródi on 24/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import "SPInputCell.h"
#import "Constants.h"

@implementation SPInputCell
{
    UISwipeGestureRecognizer* _swipeRightRecognizer;
    UISwipeGestureRecognizer* _swipeLeftRecognizer;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        _swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rowSwipedRight:)];
        _swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_swipeRightRecognizer];
        _swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rowSwipedLeft:)];
        _swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:_swipeLeftRecognizer];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setupInputFieldText
{
//    NSString* nameString = (_item.name) ? [NSString stringWithFormat:@"%@ - %@", _item.name, _item.orderingID] : @"";
    NSString* nameString = ([_item nameString]) ? [_item nameString] : @"";
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:nameString];
    if (self.item.done.boolValue) {
        [as addAttribute:NSStrikethroughStyleAttributeName
                   value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]
                   range:NSMakeRange(0, nameString.length)];
    }
    _inputField.attributedText = as;

    // Quantity - TODO remove to other method
    NSString* quantityString = ([_item quantityString]) ? [_item quantityString] : @"1";
    NSMutableAttributedString* asQuantity = [[NSMutableAttributedString alloc] initWithString:quantityString];
    _quantity.attributedText = asQuantity;
}

- (void)rowSwipedRight:(id)sender
{
    if (![self.inputField isFirstResponder]) {
        self.item.done = [NSNumber numberWithBool:!self.item.done.boolValue];
        [self setupInputFieldText];
    }
}

- (void)rowSwipedLeft:(id)sender
{
    if (![self.inputField isFirstResponder]) {
        NSIndexPath* deletableIndexPath = [self.controller.tableView indexPathForCell:self];
        [self.controller deleteItemAtIdexPath:deletableIndexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)edit
{
    [self.inputField becomeFirstResponder];
}

#pragma mark - Property manipulations

- (void)setItem:(Item *)item
{
    _item = item;
    [self setupInputFieldText];
}

- (void)setInputField:(MLPAutoCompleteTextField *)inputField
{
    if (_inputField != inputField) {
        _inputField = inputField;
        inputField.delegate = self;
        [inputField setAutoCompleteTableAppearsAsKeyboardAccessory:YES];
        UIColor* bgColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        [inputField setAutoCompleteTableBackgroundColor:bgColor];
        UIColor* borderColor = [UIColor colorWithRed:219./255.
                                               green:222./255.
                                                blue:226./255.
                                               alpha:1.0];
        [inputField setAutoCompleteTableBorderColor:borderColor];
        [inputField setAutoCompleteTableBorderWidth:3.5];
        [inputField setAutoCompleteTableCellTextColor:[UIColor blackColor]];
    }
}

- (void)removeReorderControlIcon:(UIView*)view{
    for (UIView *subview in view.subviews) {
        if([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
            
            // do magic here
            
        }else if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {
            
            // do magic here
            
        }else if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellReorderControl"]) {
            
       	    // do magic here
            
            // example - use the full cell area as touching ground for the drag & drop
            // we'll also remove the move icon
            
            // change the drag & drop touch area frame
            CGRect newFrame = self.frame;
            newFrame.origin.x = 0.0;
            newFrame.origin.y = 0.0;
            newFrame.size.width = DRAG_TARGET_WIDTH;
            subview.frame = newFrame;
            
            // search for the move icon
            for(UIView * subview2 in subview.subviews){
                
                if ([subview2 isKindOfClass: [UIImageView class]]) {
                    // remove the icon
                    [subview2 removeFromSuperview];
                }
                
            }
            
        } else if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellScrollView"]) {
            [self removeReorderControlIcon:subview];
        }
    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.0f];
    [self removeReorderControlIcon:self];
    [UIView commitAnimations];
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return !self.item.done.boolValue;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.item setNameString: textField.text];
    
    if (self.editEndedBlock) {
        self.editEndedBlock(self);
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
