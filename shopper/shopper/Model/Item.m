//
//  Item.m
//  shopper
//
//  Created by Tamás Koródi on 19/12/13.
//  Copyright (c) 2013 Tamás Koródi. All rights reserved.
//

#import "Item.h"

#import "Token.h"
#import "ItemName.h"

@implementation Item

// This returns the name of the Entity it extends (basically the name of the superclass)
+ (NSString *)entityName {
    return @"ItemEntity";
}

// This returns the name of your xcdatamodeld model, without the extension
+ (NSString *)modelName {
    return @"DataModel";
}

+ (NSSet*)tokenizeString:(NSString*)string
{
    NSMutableSet* tokens = NSMutableSet.new;
    NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitPunctuation | NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerJoinNames | NSLinguisticTaggerOmitOther;
    [string enumerateLinguisticTagsInRange:NSMakeRange(0, [string length])
                                    scheme:NSLinguisticTagSchemeTokenType
                                   options:options
                               orthography:nil
                                usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
                                    NSString* tokenName = [[string substringWithRange:tokenRange] lowercaseString];
                                    [tokens addObject:tokenName];
                                }];
    return tokens;
}


- (void)refreshTokensForName
{
    NSMutableSet* tokens = NSMutableSet.new;
    for (NSString* tokenString in [Item tokenizeString:self.name.name]) {
        Token* token = [Token getWithPredicate:[NSPredicate predicateWithFormat:@"token == %@", tokenString] error:NULL];
        if (!token) {
            token = [Token newEntity];
            token.token = tokenString;
        }
        [tokens addObject:token];
    }
    
    self.name.tokens = tokens;
}

- (void)setNameString:(NSString*)name
{
    ItemName* itemName = [ItemName getWithPredicate:[NSPredicate predicateWithFormat:@"name == %@", name]
                                              error:NULL];
    if (!itemName) {
        itemName = [ItemName newEntity];
        itemName.name = name;
    }
    
    self.name = itemName;
    
    [self refreshTokensForName];
}

- (NSString*)nameString
{
    return self.name.name;
}


@end