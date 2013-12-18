//
//  SPSuggestionFetcher.m
//  shopper
//
//  Created by Tamás Koródi on 18/12/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import "SPSuggestionFetcher.h"
#import "SPAppDelegate.h"

#import "Item.h"

@implementation SPSuggestionFetcher
{
    dispatch_queue_t _queue;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        _queue = dispatch_queue_create("SuggestionFetcher", NULL);
    }
    return self;
}

- (NSManagedObjectContext*)managedObjectContext {
    SPAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate managedObjectContext];
}

- (NSArray*)fetchMatchingFor:(NSString*)text
{
    NSEntityDescription *listEntity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest* listRequest = [[NSFetchRequest alloc] init];
    [listRequest setEntity:listEntity];
    [listRequest setFetchLimit:66];
    NSPredicate* listPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", text];
    listRequest.predicate = listPredicate;
    NSError* err = nil;
    NSArray* fetchResult = [self.managedObjectContext executeFetchRequest:listRequest error:&err];
    if (err)
    {
        NSLog(@"Error while fetching objects: %@", [err description]);
        return nil;
    }
    
    NSMutableArray* suggestions = NSMutableArray.new;
    for (Item* item in fetchResult) {
        [suggestions addObject:item.name];
    }
    return suggestions;
}

- (void)giveSuggestionsFor:(NSString*)text
                 byHandler:(void(^)(NSArray *suggestions))handler
{
    dispatch_async(_queue, ^{
        __block NSArray* result = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            result = [self fetchMatchingFor:text];
        });
        handler(result);
    });
}


@end
