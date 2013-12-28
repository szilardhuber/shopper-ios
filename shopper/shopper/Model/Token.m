//
//  Token.m
//  shopper
//
//  Created by Tamás Koródi on 19/12/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import "Token.h"

@implementation Token

// This returns the name of the Entity it extends (basically the name of the superclass)
+ (NSString *)entityName {
    return @"TokenEntity";
}

// This returns the name of your xcdatamodeld model, without the extension
+ (NSString *)modelName {
    return @"DataModel";
}

@end
