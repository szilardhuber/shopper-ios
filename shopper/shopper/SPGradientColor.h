//
//  SPGradientColor.h
//  shopzenion
//
//  Created by Szilard Huber on 21/03/14.
//  Copyright (c) 2014 shopzenion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPGradientColor : NSObject

@property UIColor* startColor;
@property UIColor* endColor;
@property int colorCount;
@property CGFloat redStep;
@property CGFloat greenStep;
@property CGFloat blueStep;
@property CGFloat alphaStep;

+(SPGradientColor*)initWithStartColor:(UIColor*)_startColor endColor:(UIColor*)_endColor colorCount:(int)_colorCount;

-(UIColor*)getColorForRow:(NSInteger)index;

@end
