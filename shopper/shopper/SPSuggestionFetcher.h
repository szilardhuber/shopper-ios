//
//  SPSuggestionFetcher.h
//  shopper
//
//  Created by Tamás Koródi on 18/12/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface SPSuggestionFetcher : NSObject

- (void)giveSuggestionsFor:(NSString*)text
                 byHandler:(void(^)(NSArray *suggestions))handler;
@end
