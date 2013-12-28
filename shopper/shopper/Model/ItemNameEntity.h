//
//  ItemNameEntity.h
//  shopper
//
//  Created by Tamás Koródi on 28/12/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RHManagedObject.h"

@class ItemEntity, TokenEntity;

@interface ItemNameEntity : RHManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *item;
@property (nonatomic, retain) NSSet *tokens;
@end

@interface ItemNameEntity (CoreDataGeneratedAccessors)

- (void)addItemObject:(ItemEntity *)value;
- (void)removeItemObject:(ItemEntity *)value;
- (void)addItem:(NSSet *)values;
- (void)removeItem:(NSSet *)values;

- (void)addTokensObject:(TokenEntity *)value;
- (void)removeTokensObject:(TokenEntity *)value;
- (void)addTokens:(NSSet *)values;
- (void)removeTokens:(NSSet *)values;

@end
