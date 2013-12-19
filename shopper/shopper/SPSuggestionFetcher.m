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

- (NSArray*)fetchMatchingFor:(NSString*)text
{
    NSError* err = nil;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", text];
    NSArray* fetchedResult = [Item fetchWithPredicate:predicate
                                       sortDescriptor:nil
                                            withLimit:66
                                                error:&err];
    if (err)
    {
        NSLog(@"Error while fetching objects: %@", [err description]);
        return nil;
    }

    NSMutableArray* suggestions = NSMutableArray.new;
    for (Item* item in fetchedResult) {
        [suggestions addObject:item.name];
    }
    return suggestions;
}

- (void)giveSuggestionsFor:(NSString*)text
                 byHandler:(void(^)(NSArray *suggestions))handler
{
    dispatch_async(_queue, ^{
        NSArray* result = nil;
        result = [self fetchMatchingFor:text];
        handler(result);
    });
}


@end
