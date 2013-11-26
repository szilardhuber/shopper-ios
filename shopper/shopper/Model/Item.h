//
//  Item.h
//  shopper
//
//  Created by Tamás Koródi on 26/11/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSNumber * done;

@end
