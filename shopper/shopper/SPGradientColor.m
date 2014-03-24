//
//  SPGradientColor.m
//  shopzenion
//
//  Created by Szilard Huber on 21/03/14.
//  Copyright (c) 2014 shopzenion. All rights reserved.
//

#import "SPGradientColor.h"

@implementation SPGradientColor

-(UIColor*)getColorForRow:(NSInteger)index
{
    const CGFloat* startComponents = CGColorGetComponents(_startColor.CGColor);
    CGFloat red = startComponents[0] + index * self.redStep;
    CGFloat green = startComponents[1] + index * self.greenStep;
    CGFloat blue = startComponents[2] + index * self.blueStep;
    CGFloat alpha = startComponents[3] + index * self.alphaStep;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(SPGradientColor*)initWithStartColor:(UIColor*)_startColor endColor:(UIColor*)_endColor colorCount:(int)_colorCount
{
    SPGradientColor* gradient = [SPGradientColor new];
    gradient.startColor = _startColor;
    gradient.endColor = _endColor;
    gradient.colorCount = _colorCount;

    const CGFloat* startComponents = CGColorGetComponents(_startColor.CGColor);
    const CGFloat* endComponents = CGColorGetComponents(_endColor.CGColor);
    gradient.redStep = (endComponents[0] - startComponents[0]) / _colorCount;
    gradient.greenStep = (endComponents[1] - startComponents[1]) / _colorCount;
    gradient.blueStep = (endComponents[2] - startComponents[2]) / _colorCount;
    gradient.alphaStep = (endComponents[3] - startComponents[3]) / _colorCount;
    
    return gradient;
}



@end
