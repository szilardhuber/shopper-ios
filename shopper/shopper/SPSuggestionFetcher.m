//
//  SPSuggestionFetcher.m
//  shopper
//
//  Created by Tamás Koródi on 18/12/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import "SPSuggestionFetcher.h"
#import "SPAppDelegate.h"

#import "Token.h"
#import "ItemName.h"

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


- (void)giveSuggestionsFor:(NSString*)text
                 byHandler:(void(^)(NSArray *suggestions))handler
{
    dispatch_async(_queue, ^{
        NSMutableArray* subPredicates = NSMutableArray.new;
        for (NSString* tokenName in [Item tokenizeString:text]) {
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"ANY tokens.token BEGINSWITH %@", tokenName];
            [subPredicates addObject:pred];
        }
        NSPredicate* predicate = [NSCompoundPredicate orPredicateWithSubpredicates:subPredicates];
        
        NSError* err = nil;
        NSArray* fetchedResult = [ItemName distinctValuesWithAttribute:@"name"
                                                         predicate:predicate
                                                             error:&err];
        handler(fetchedResult);
    });
    
    
    // KOTYO HACK
    NSArray* tokenArr = [Token fetchAllWithError:NULL];
    for (Token* t in tokenArr) {
        NSMutableArray* items = NSMutableArray.new;
        for (ItemName* i in t.names) {
            [items addObject:i.name];
        }
        NSLog(@"token name: %@, items:[%@]", t.token, items);
    }
    NSLog(@"----------------------------------- Token count: %lu", (unsigned long)[Token countWithError:NULL]);

}


@end
