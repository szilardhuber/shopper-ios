//
//  Item.h
//  shopper
//
//  Created by Tamás Koródi on 19/12/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import "ItemEntity.h"

@interface Item : ItemEntity
+ (NSString *)entityName;
+ (NSString *)modelName;

+ (NSSet*)tokenizeString:(NSString*)string;
- (void)refreshTokensForName;

- (void)setNameString:(NSString*)name;
- (NSString*)nameString;
- (NSString*)quantityString;
@end