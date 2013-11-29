//
//  Item.h
//  shopper
//
//  Created by Tamás Koródi on 29/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * orderingID;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSManagedObject *list;

@end
