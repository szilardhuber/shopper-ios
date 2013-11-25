//
//  KTPullRefreshController.m
//  shopper
//
//  Created by Tamás Koródi on 19/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>

#import "KYPullToActionController.h"

@implementation KYPullToActionController
{
    UIScrollView* _scrollView;
    UIView* _triggerView;
    BOOL _active;
    BOOL _touchIsActive;
    
    void(^_stateChangeHandker)(UIView*, BOOL);
    void(^_actionHandler)();
}

- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                       triggerView:(UIView*)triggerView
                stateChangeHandler:(void(^)(UIView*, BOOL))stateHandler
                     actionHandler:(void(^)())aHandler;
{
    self = [super init];
    if (self) {
        _stateChangeHandker = stateHandler;
        _actionHandler = aHandler;
        
        _triggerView = UIView.new;
        _triggerView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        _triggerView.frame = CGRectMake(0.0,
                                       -triggerView.frame.size.height,
                                       triggerView.frame.size.width,
                                       triggerView.frame.size.height);
        _triggerView.hidden = YES;
        [_triggerView addSubview:triggerView];
        
        _scrollView = scrollView;
        [_scrollView addGestureRecognizer:self];
        [_scrollView addSubview: _triggerView];
        
        _active = NO;
        
        self.triggerHeight = triggerView.frame.size.height;
        
        // Setup default graphic adjustment filter
        _graphicAdjustmentsHandler = ^(UIView* view, CGFloat fraction) {
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0 / -800.0;
            view.layer.transform = CATransform3DRotate(transform,
                                                       M_PI/2 - M_PI/2 * fraction,
                                                       1.0,
                                                       0.0,
                                                       0.0);
        };
    }
    return self;
}

- (void)dealloc
{
    [_scrollView removeGestureRecognizer:self];
    [_triggerView removeFromSuperview];
}

#pragma mark Gesture recognizer calls
- (void)reset
{
    _touchIsActive = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [super touchesBegan:touches withEvent:event];
    
    _touchIsActive = YES;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [super touchesCancelled:touches withEvent:event];
    
    _touchIsActive = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
{
    [super touchesEnded:touches withEvent:event];
    
    _touchIsActive = NO;
    if ([self fraction] >= 1.0) {
        _actionHandler();
        [self manageScrollState];
        self.state = UIGestureRecognizerStateEnded;
    } else {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer;
{
    return NO;
}
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer;
{
    return NO;
}

#pragma mark - Pull action handling

- (CGFloat)fraction
{
    CGFloat fraction = 0.0;
    CGFloat realOffet = _scrollView.contentOffset.y+_scrollView.contentInset.top;
    if (realOffet < 0.0) {
        fraction = -realOffet / self.triggerHeight;
    }
    
    if (fraction > 1.0)
        fraction = 1.0;
    return fraction;
}

- (void)manageScrollState
{
    CGFloat fraction = [self fraction];

    if (_touchIsActive && fraction > 0.0) {
        _triggerView.hidden = NO;
    } else if (fraction <= 0.0) {
        _triggerView.hidden = YES;
    }
    
    if (!_triggerView.hidden) {
        _graphicAdjustmentsHandler(_triggerView, fraction);
    }
    
    if (fraction >= 1.0 && !_active)
    {
        _active = YES;
        _stateChangeHandker(_triggerView, YES);
    }
    if (fraction < 1.0 && _active)
    {
        _active = NO;
        _stateChangeHandker(_triggerView, NO);
    }
}

#pragma mark - ScrollView Delegate functions

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self manageScrollState];
}

@end
