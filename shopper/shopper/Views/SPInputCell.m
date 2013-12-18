//
//  SPInputCell.m
//  shopper
//
//  Created by Tamás Koródi on 24/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import "SPInputCell.h"

@implementation SPInputCell
{
    UISwipeGestureRecognizer* _swipeRecognizer;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        _swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
        _swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_swipeRecognizer];
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
    NSString* nameString = (_item.name) ? _item.name : @"";
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:nameString];
    if (self.item.done.boolValue) {
        [as addAttribute:NSStrikethroughStyleAttributeName
                   value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]
                   range:NSMakeRange(0, nameString.length)];
    }
    _inputField.attributedText = as;
}

- (void)swipeRight:(id)sender
{
    if (![self.inputField isFirstResponder]) {
        self.item.done = [NSNumber numberWithBool:!self.item.done.boolValue];
        [self setupInputFieldText];
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
        [inputField setAutoCompleteFetchRequestDelay:0.33];
        UIColor* borderColor = [UIColor colorWithRed:219./255.
                                               green:222./255.
                                                blue:226./255.
                                               alpha:1.0];
        [inputField setAutoCompleteTableBorderColor:borderColor];
        [inputField setAutoCompleteTableBorderWidth:3.5];
        [inputField setAutoCompleteTableCellTextColor:[UIColor blackColor]];
    }
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return !self.item.done.boolValue;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.item.name = textField.text;

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
