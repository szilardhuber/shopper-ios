//
//  List.h
//  shopper
//
//  Created by Tamás Koródi on 29/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface List : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *items;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)insertObject:(Item *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(Item *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end
