//
//  KTPullRefreshController.h
//  shopper
//
//  Created by Tamás Koródi on 19/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 * This class is a subclass of UIGesture recognizer.
 * It will register itself into the given UITableView as a Gesture recognizer,
 * but to work properly it is needed to be registered as a UIScrollViewDelegate 
 * to function correctly
 */
@interface KYPullToActionController : UIGestureRecognizer<UIScrollViewDelegate>

@property (copy) void(^graphicAdjustmentsHandler)(UIView* view, CGFloat fraction);
@property (assign) CGFloat triggerHeight;

- (instancetype)initWithScrollView:(UIScrollView*)scrollView
                       triggerView:(UIView*)triggerView
                stateChangeHandler:(void(^)(UIView*, BOOL))stateHandler
                     actionHandler:(void(^)())aHandler;

@end
