//
//  FISCardDeck.m
//  OOP-Cards-Model
//
//  Created by Flatiron School on 6/16/16.
//  Copyright © 2016 Al Tyus. All rights reserved.
//

#import "FISCardDeck.h"

@interface FISCardDeck()

@property (strong, nonatomic, readwrite) NSMutableArray *remainingCards;
@property (strong, nonatomic, readwrite) NSMutableArray *dealtCards;

@end

@implementation FISCardDeck

- (instancetype)init {
    self = [super init];
    if(self) {
        _remainingCards = [[NSMutableArray alloc] init];
        _dealtCards = [[NSMutableArray alloc] init];
        [self standartDeck52CardsInit];
    }
    return self;
}

- (void)standartDeck52CardsInit {
    NSMutableArray *ranks = [[FISCard validRanks] mutableCopy];
    NSMutableArray *suits = [[FISCard validSuits] mutableCopy];
    for(NSUInteger i = 0; i < [ranks count]; i++) {
        for(NSUInteger j = 0; j < [suits count]; j++) {
            FISCard *currentCard = [[FISCard alloc] initWithSuit:suits[j] rank:ranks[i]];
            [self.remainingCards addObject:currentCard];
        }
    }
}

- (FISCard *)drawNextCard {
    if(self.remainingCards.count != 0) {
        FISCard *nextCard = self.remainingCards[0];
        [self.remainingCards removeObjectAtIndex:0];
        [self.dealtCards addObject:nextCard];
        return nextCard;
    } else {
        NSLog(@"The card deck is empty");
        return nil;
    }
}

- (void)resetDeck {
    [self gatherDealtCards];
    [self shuffleRemainingCards];
}

- (void)gatherDealtCards {
    [self.remainingCards addObjectsFromArray:self.dealtCards];
    [self.dealtCards removeAllObjects];
}

- (void)shuffleRemainingCards{
    [self gatherDealtCards];
    NSMutableArray *tempDeck = [self.remainingCards mutableCopy];
    NSUInteger counter = [tempDeck count];
    [self.remainingCards removeAllObjects];
    for(NSUInteger i = 0; i < counter; i++) {
        NSUInteger randomPosition = arc4random_uniform((uint32_t) [tempDeck count]);
        [self.remainingCards addObject:tempDeck[randomPosition]];
        [tempDeck removeObjectAtIndex:randomPosition];
    }
}

- (NSString *)description {
    NSString *result = [NSString stringWithFormat:@"count: %lu\ncards:\n", self.remainingCards.count];
    for(NSString *card in self.remainingCards) {
        result = [result stringByAppendingString:card.description];
    }
    NSLog(@"%@", result);
    return result;
    
}


@end

