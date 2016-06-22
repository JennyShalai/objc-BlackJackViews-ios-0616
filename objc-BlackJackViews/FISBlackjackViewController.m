//
//  FISBlackjackViewController.m
//  objc-BlackJackViews
//
//  Created by Flatiron School on 6/21/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

#import "FISBlackjackViewController.h"

@interface FISBlackjackViewController ()
@property (weak, nonatomic) IBOutlet UILabel *houseCard1;
@property (weak, nonatomic) IBOutlet UILabel *houseCard2;
@property (weak, nonatomic) IBOutlet UILabel *houseCard3;
@property (weak, nonatomic) IBOutlet UILabel *houseCard4;
@property (weak, nonatomic) IBOutlet UILabel *houseCard5;
@property (weak, nonatomic) IBOutlet UILabel *playerCard1;
@property (weak, nonatomic) IBOutlet UILabel *playerCard2;
@property (weak, nonatomic) IBOutlet UILabel *playerCard3;
@property (weak, nonatomic) IBOutlet UILabel *playerCard4;
@property (weak, nonatomic) IBOutlet UILabel *playerCard5;
@property (weak, nonatomic) IBOutlet UILabel *houseStayed;
@property (weak, nonatomic) IBOutlet UILabel *houseBust;
@property (weak, nonatomic) IBOutlet UILabel *houseBlackjack;
@property (weak, nonatomic) IBOutlet UILabel *playerStayed;
@property (weak, nonatomic) IBOutlet UILabel *playerBust;
@property (weak, nonatomic) IBOutlet UILabel *playerBlackjack;
@property (weak, nonatomic) IBOutlet UILabel *winner;
@property (weak, nonatomic) IBOutlet UIButton *hitButton;
@property (weak, nonatomic) IBOutlet UIButton *stayButton;
@property (weak, nonatomic) IBOutlet UILabel *houseWins;
@property (weak, nonatomic) IBOutlet UILabel *houseLosses;
@property (weak, nonatomic) IBOutlet UILabel *playerWins;
@property (weak, nonatomic) IBOutlet UILabel *playerLosses;
@property (weak, nonatomic) IBOutlet UILabel *houseScore;
@property (weak, nonatomic) IBOutlet UILabel *playerScore;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;

@end

@implementation FISBlackjackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hideLabels];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)deal:(id)sender {

    self.winner.text = @"";
    self.dealButton.enabled = NO;
    
    // hide unused labels for now
    [self hideLabels];
    
    // starting new game == making new instance
    self.game = [[FISBlackjackGame alloc] init];
    
    // set deck for new game
    [self.game.deck resetDeck];
    
    // pass 2 card to each player
    [self.game dealNewRound];
    
    // reflect result on app screen
    [self displayPlayersCards];
    
    // check isBlackjack
    if(self.game.player.blackjack) {
        [self playerWin];
        self.playerBlackjack.hidden = NO;
        self.playerBlackjack.text = @"BLACKJACK!";
    } else if(self.game.house.blackjack) {
        [self houseWin];
        self.houseBlackjack.hidden = NO;
        self.houseBlackjack.text = @"BLACKJACK!";
    } else {
        self.hitButton.enabled = YES;
        self.stayButton.enabled = YES;
    }
}

- (IBAction)hit:(id)sender {
    [self.game dealCardToPlayer];
    [self displayPlayersCards];
    if (self.game.player.blackjack) {
        [self playerWin];
        self.playerBlackjack.hidden = NO;
        self.playerBlackjack.text = @"BLACKJACK!";
    } else if(self.game.player.busted) {
        [self houseWin];
        self.playerBust.hidden = NO;
        self.playerBust.text = @"busted!";
    } else {
        if(self.game.house.stayed || (![self.game.house shouldHit])) {
            self.houseStayed.hidden = NO;
            self.houseStayed.text = @"Stay!";
        } else {
            [self.game dealCardToHouse];
            [self displayPlayersCards];
            if(self.game.house.busted) {
                [self playerWin];
                self.houseBust.hidden = NO;
                self.houseBust.text = @"busted!";
            } else if(self.game.house.blackjack) {
                [self houseWin];
                self.houseBlackjack.hidden = NO;
                self.houseBlackjack.text = @"BLACKJACK!";
            }
        }
    }
}



- (IBAction)stay:(id)sender {
    self.hitButton.enabled = NO;
    self.game.player.stayed = YES;
    self.playerStayed.hidden = NO;
    self.playerStayed.text = @"stay";
    
    do {
        if(self.game.house.stayed) {
            if(self.game.player.handscore > self.game.house.handscore) {
                [self playerWin];
            } else {
                [self houseWin];
            }
        } else if(self.game.house.stayed || (![self.game.house shouldHit])) {
            self.houseStayed.hidden = NO;
            self.houseStayed.text = @"Stay!";
        } else {
            [self.game dealCardToHouse];
            [self displayPlayersCards];
            if(self.game.house.busted) {
                [self playerWin];
                self.houseBust.hidden = NO;
                self.houseBust.text = @"busted!";
            } else if(self.game.house.blackjack) {
                [self houseWin];
                self.houseBlackjack.hidden = NO;
                self.houseBlackjack.text = @"BLACKJACK!";
            }
        }
    } while ([self.winner.text isEqualToString:@""] && self.game.player.cardsInHand.count < 6 && self.game.house.cardsInHand.count < 6);
    
}

- (void)hideLabels {
    self.houseCard1.hidden = YES;
    self.houseCard2.hidden = YES;
    self.houseCard3.hidden = YES;
    self.houseCard4.hidden = YES;
    self.houseCard5.hidden = YES;
    self.playerCard1.hidden = YES;
    self.playerCard2.hidden = YES;
    self.playerCard3.hidden = YES;
    self.playerCard4.hidden = YES;
    self.playerCard5.hidden = YES;
    self.houseBust.hidden = YES;
    self.playerBust.hidden = YES;
    self.houseStayed.hidden = YES;
    self.playerStayed.hidden = YES;
    self.houseBlackjack.hidden = YES;
    self.playerBlackjack.hidden = YES;
    self.winner.hidden = YES;
    self.houseScore.hidden = YES;
    self.houseWins.text = @"Wins: 0";
    self.houseLosses.text = @"Losses: 0";
    self.playerWins.text = @"Wins: 0";
    self.playerLosses.text = @"Losses: 0";
    self.playerScore.text = @"Score: 0";
    self.houseScore.text = @"Score: 0";
    
}

- (void)displayPlayersCards {
    self.playerScore.text = [NSString stringWithFormat:@"%lu", self.game.player.handscore];
    self.houseScore.hidden = NO;
    self.houseScore.text = [NSString stringWithFormat:@"%lu", self.game.house.handscore];
    NSUInteger numberCardsInPlayerHand = [self.game.player.cardsInHand count];
    NSUInteger numberCardsInHouseHand = [self.game.house.cardsInHand count];
    switch (numberCardsInPlayerHand) {
        case 2:
            self.playerCard1.hidden = NO;
            self.playerCard2.hidden = NO;
            self.playerCard1.text = ((FISCard *)self.game.player.cardsInHand[0]).cardLabel;
            self.playerCard2.text = ((FISCard *)self.game.player.cardsInHand[1]).cardLabel;
            break;
        case 3:
            self.playerCard1.hidden = NO;
            self.playerCard2.hidden = NO;
            self.playerCard3.hidden = NO;
            self.playerCard1.text = ((FISCard *)self.game.player.cardsInHand[0]).cardLabel;
            self.playerCard2.text = ((FISCard *)self.game.player.cardsInHand[1]).cardLabel;
            self.playerCard3.text = ((FISCard *)self.game.player.cardsInHand[2]).cardLabel;
            break;
        case 4:
            self.playerCard1.hidden = NO;
            self.playerCard2.hidden = NO;
            self.playerCard3.hidden = NO;
            self.playerCard4.hidden = NO;
            self.playerCard1.text = ((FISCard *)self.game.player.cardsInHand[0]).cardLabel;
            self.playerCard2.text = ((FISCard *)self.game.player.cardsInHand[1]).cardLabel;
            self.playerCard3.text = ((FISCard *)self.game.player.cardsInHand[2]).cardLabel;
            self.playerCard4.text = ((FISCard *)self.game.player.cardsInHand[3]).cardLabel;
            break;
        case 5:
            self.playerCard1.hidden = NO;
            self.playerCard2.hidden = NO;
            self.playerCard3.hidden = NO;
            self.playerCard4.hidden = NO;
            self.playerCard5.hidden = NO;
            self.playerCard1.text = ((FISCard *)self.game.player.cardsInHand[0]).cardLabel;
            self.playerCard2.text = ((FISCard *)self.game.player.cardsInHand[1]).cardLabel;
            self.playerCard3.text = ((FISCard *)self.game.player.cardsInHand[2]).cardLabel;
            self.playerCard4.text = ((FISCard *)self.game.player.cardsInHand[3]).cardLabel;
            self.playerCard5.text = ((FISCard *)self.game.player.cardsInHand[4]).cardLabel;
            break;
        default:
            NSLog (@"Looks like something went wrong! Watch out! Gambler!");
            break;
    }
    switch (numberCardsInHouseHand) {
        case 2:
            self.houseCard1.hidden = NO;
            self.houseCard2.hidden = NO;
            self.houseCard1.text = ((FISCard *)self.game.house.cardsInHand[0]).cardLabel;
            self.houseCard2.text = ((FISCard *)self.game.house.cardsInHand[1]).cardLabel;
            break;
        case 3:
            self.houseCard1.hidden = NO;
            self.houseCard2.hidden = NO;
            self.houseCard3.hidden = NO;
            self.houseCard1.text = ((FISCard *)self.game.house.cardsInHand[0]).cardLabel;
            self.houseCard2.text = ((FISCard *)self.game.house.cardsInHand[1]).cardLabel;
            self.houseCard3.text = ((FISCard *)self.game.house.cardsInHand[2]).cardLabel;
            break;
        case 4:
            self.houseCard1.hidden = NO;
            self.houseCard2.hidden = NO;
            self.houseCard3.hidden = NO;
            self.houseCard4.hidden = NO;
            self.houseCard1.text = ((FISCard *)self.game.house.cardsInHand[0]).cardLabel;
            self.houseCard2.text = ((FISCard *)self.game.house.cardsInHand[1]).cardLabel;
            self.houseCard3.text = ((FISCard *)self.game.house.cardsInHand[2]).cardLabel;
            self.houseCard4.text = ((FISCard *)self.game.house.cardsInHand[3]).cardLabel;
            break;
        case 5:
            self.houseCard1.hidden = NO;
            self.houseCard2.hidden = NO;
            self.houseCard3.hidden = NO;
            self.houseCard4.hidden = NO;
            self.houseCard5.hidden = NO;
            self.houseCard1.text = ((FISCard *)self.game.house.cardsInHand[0]).cardLabel;
            self.houseCard2.text = ((FISCard *)self.game.house.cardsInHand[1]).cardLabel;
            self.houseCard3.text = ((FISCard *)self.game.house.cardsInHand[2]).cardLabel;
            self.houseCard4.text = ((FISCard *)self.game.house.cardsInHand[3]).cardLabel;
            self.houseCard5.text = ((FISCard *)self.game.house.cardsInHand[4]).cardLabel;
            break;
        default:
            NSLog (@"Looks like something went wrong! Watch out! House is cheating!");
            break;
    }
}

- (void)houseWin {
    self.dealButton.enabled = YES;
    self.winner.hidden = NO;
    self.winner.text = @"You lose!";
    [self.game incrementWinsAndLossesForHouseWins:YES];
    self.houseWins.text = [NSString stringWithFormat:@"Wins: %lu", self.game.house.wins];
    self.playerLosses.text = [NSString stringWithFormat:@"Losses: %lu", self.game.player.losses];
    self.hitButton.enabled = NO;
    self.stayButton.enabled = NO;
    self.playerScore.hidden = NO;
    
    self.playerScore.text = [NSString stringWithFormat:@"Score: %lu", self.game.player.handscore];
    self.houseScore.hidden = NO;
    self.houseScore.text = [NSString stringWithFormat:@"Score: %lu", self.game.house.handscore];
    
}

- (void)playerWin {
    self.dealButton.enabled = YES;
    self.winner.hidden = NO;
    self.winner.text = @"You win!";
    [self.game incrementWinsAndLossesForHouseWins:NO];
    self.playerWins.text = [NSString stringWithFormat:@"Wins: %lu", self.game.player.wins];
    self.houseLosses.text = [NSString stringWithFormat:@"Losses: %lu", self.game.house.losses];
    self.hitButton.enabled = NO;
    self.stayButton.enabled = NO;
    self.playerScore.hidden = NO;
    self.playerScore.text = [NSString stringWithFormat:@"Score: %lu",self.game.player.handscore];
    self.houseScore.hidden = NO;
    self.houseScore.text = [NSString stringWithFormat:@"Score: %lu",self.game.house.handscore];
}




@end
