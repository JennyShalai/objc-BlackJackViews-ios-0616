//
//  FISBlackjackPlayer.m
//  BlackJack
//
//  Created by Flatiron School on 6/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackPlayer.h"

@implementation FISBlackjackPlayer

- (instancetype)init {
    return [self initWithName:@""];
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        _cardsInHand = [[NSMutableArray alloc] init];
        _aceInHand = NO;
        _blackjack = NO;
        _busted = NO;
        _stayed = NO;
        _handscore = 0;
        _wins = 0;
        _losses = 0;
    }
    return self;
}

- (NSString *)description {
    NSString *customDescription = [NSString stringWithFormat:@"name: %@\ncards: %@\nhandscore: %li\nace: %d\nblackjack: %d\nbusted: %d\nstayed: %d\nwins: %li\nlosses: %li", self.name, self.cardsInHand, self.handscore, self.aceInHand, self.blackjack, self.busted, self.stayed, self.wins, self.losses];
    return customDescription;
}

- (void)resetForNewGame {
    [self.cardsInHand removeAllObjects];
    self.handscore = 0;
    self.aceInHand = NO;
    self.stayed = NO;
    self.blackjack = NO;
    self.busted = NO;
}

- (void)acceptCard:(FISCard *)card {
    // add card to hand
    [self.cardsInHand addObject:card];
    
    // add card value to current score in hand
    self.handscore = self.handscore + card.cardValue;
    if([card.rank isEqualToString:@"A"] && self.handscore < 12) {
        self.handscore += 10;
    }
    
    // mark if carrent card is "A"
    if([card.rank isEqualToString:@"A"]) {
        self.aceInHand = YES;
    }
    
    // mark if current card makes it a blackjack
    if(self.cardsInHand.count == 2 && self.handscore == 21) {
        self.blackjack = YES;
    }
    
    // mark if current card makes it a busted
    if(self.handscore > 21) {
        self.busted = YES;
    }
}

- (BOOL)shouldHit {
    if(self.handscore > 16) {
        self.stayed = YES;
        return NO;
    }
    return YES;
}


@end
