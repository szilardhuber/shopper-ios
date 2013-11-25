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

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.done = NO;
    _inputField.attributedText = nil;
}

- (void)swipeRight:(id)sender
{
    self.done = !self.done;
    NSMutableAttributedString* as = [[NSMutableAttributedString alloc] initWithString:_inputField.text];
    if (self.done) {
        [as addAttribute:NSStrikethroughStyleAttributeName
                   value:[NSNumber numberWithInteger:NSUnderlinePatternSolid | NSUnderlineStyleSingle]
                   range:NSMakeRange(0, _inputField.text.length)];
    }
    _inputField.attributedText = as;
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
