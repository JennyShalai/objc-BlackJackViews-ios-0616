//
//  FISBlackjackGame.m
//  BlackJack
//
//  Created by Flatiron School on 6/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackGame.h"
#import "FISCardDeck.h"

@implementation FISBlackjackGame

- (instancetype)init {
    self = [super init];
    if(self) {
        _deck = [[FISCardDeck alloc] init];
        _house = [[FISBlackjackPlayer alloc] initWithName:@"House"];
        _player = [[FISBlackjackPlayer alloc] initWithName:@"Player"];
    }
    return self;
}

- (void)playBlackjack {
    
}

- (void)dealNewRound {
    [self dealCardToPlayer];
    [self dealCardToHouse];
    [self dealCardToPlayer];
    [self dealCardToHouse];
}

- (void)dealCardToPlayer {
    FISCard *card = [self.deck drawNextCard];
    [self.player acceptCard:card];
}

- (void)dealCardToHouse {
    FISCard *card = [self.deck drawNextCard];
    [self.house acceptCard:card];
}

- (void)processPlayerTurn {
    if([self.player shouldHit] && !(self.player.busted) && !(self.player.stayed)) {
        [self dealCardToPlayer];
    }
}

- (void)processHouseTurn {
    if([self.house shouldHit] && !(self.house.busted) && !(self.house.stayed)) {
        [self dealCardToHouse];
    }
}

- (BOOL)houseWins {
    if(self.house.busted || (self.player.handscore > self.house.handscore) || (self.player.blackjack && self.house.blackjack)) {
        return NO;
    }
    if(self.player.busted || (self.player.handscore < self.house.handscore) || (self.player.handscore == self.house.handscore)) {
        return YES;
    }
    return NO;
}

- (void)incrementWinsAndLossesForHouseWins:(BOOL)houseWins {
    if(houseWins) {
        self.house.wins += 1;
        self.player.losses += 1;
    } else {
        self.house.losses += 1;
        self.player.wins += 1;
    }
}


@end
