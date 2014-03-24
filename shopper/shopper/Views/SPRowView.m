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

    CGRect bounds = [self bounds];
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    CGContextSaveGState(context);
    
    CGContextSetLineWidth(context,5);
    CGContextSetRGBStrokeColor(context,1,1,1,1.0);
    CGContextAddArc(context,center.x,center.y,2,0.0,M_PI*2,YES);
    CGContextStrokePath(context);
}


@end
