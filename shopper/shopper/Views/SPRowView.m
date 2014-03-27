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
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGRect bounds = [self bounds];
    
    // Draw drag icon
    CGPoint centerDrag;
    centerDrag.x = 14;
    centerDrag.y = bounds.origin.y + bounds.size.height / 2.0;
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context,5);
    CGContextSetRGBFillColor(context,1,1,1,1.0);
    CGContextAddArc(context,centerDrag.x,centerDrag.y,2,0.0,M_PI*2,YES);
    CGContextFillPath(context);
    
    // Draw circle around quantity
    CGContextSetLineWidth(context,1);
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);
    CGContextAddArc(context,centerDrag.x + 39,centerDrag.y,14,0.0,M_PI*2,YES);

    CGContextStrokePath(context);
}


@end
