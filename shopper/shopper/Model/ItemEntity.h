//
//  ItemEntity.h
//  shopper
//
//  Created by Tamás Koródi on 19/12/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RHManagedObject.h"

@class ListEntity;

@interface ItemEntity : RHManagedObject

@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * orderingID;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) ListEntity *list;

@end
