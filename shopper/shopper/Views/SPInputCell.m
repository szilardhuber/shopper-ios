//
//  SPInputCell.m
//  shopper
//
//  Created by Tamás Koródi on 24/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import "SPInputCell.h"

@implementation SPInputCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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

- (void)setText:(NSMutableString *)text
{
    if (_text != text) {
        _text = text;
    }
    self.inputField.text = text;
}

- (void)setInputField:(UITextField *)inputField
{
    if (_inputField != inputField) {
        _inputField = inputField;
        inputField.delegate = self;
    }
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.text setString:textField.text];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
