//
//  SPRowView.m
//  shopzenion
//
//  Created by Szilard Huber on 24/03/14.
//  Copyright (c) 2014 shopzenion. All rights reserved.
//

#import "SPRowView.h"

@implementation SPRowView

- (void)drawRect:(CGRect)rect {
    //[super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect someRect = CGRectMake(0, 0, 15, 15);
    
    // Set the line width to 10 and inset the rectangle by
    // 5 pixels on all sides to compensate for the wider line.
    CGContextSetLineWidth(context, 10);
    CGRectInset(someRect, 5, 5);
    
    [[UIColor redColor] set];
    UIRectFrame(someRect);
}


@end
