//
//  TokenEntity.h
//  shopper
//
//  Created by Tamás Koródi on 28/12/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RHManagedObject.h"

@class ItemNameEntity;

@interface TokenEntity : RHManagedObject

@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSSet *names;
@end

@interface TokenEntity (CoreDataGeneratedAccessors)

- (void)addNamesObject:(ItemNameEntity *)value;
- (void)removeNamesObject:(ItemNameEntity *)value;
- (void)addNames:(NSSet *)values;
- (void)removeNames:(NSSet *)values;

@end
