//
//  MultiplayerLayer.h
//  PongT2
//
//  Created by Shawney Moore on 3/18/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Ball.h"
#import "Player.h"
#import "Constants.h"
#import "GameKitHelper.h"

//////sample data//////sample data//////sample data//////sample data//////sample data
typedef enum {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
} GameState;

@interface MultiplayerLayer : CCLayer<GameKitHelperProtocol>{
    Ball *ball;
    Player *player;
    Player *opponent;
    CCLabelTTF *OpponentScoreLabel;
    CCLabelTTF *playerscoreLabel;
    CCLabelTTF *timeLabel;
    CCLabelTTF *countdownLabel;
    CCLabelTTF *winnerLabel;
    ccTime totalTime;
    NSString *countdown;
    NSString *winner;
    NSUserDefaults *prefs;
    NSInteger *currhighscore;
    NSInteger *currentscore;
    BOOL playerScored;
    CCMenuItemImage* pauseButton;
    CCMenu* menu;
    CGSize screenSize;
    
    GameKitHelper* gkHelper;
    
    BOOL player1;
    BOOL player2;
    BOOL playerDetermined;
    BOOL positionReceived;
    BOOL randNumberReceived;
    int ournumber;
    int opponentnumber;
    int countdowntostart;
    
    CCLabelTTF *whichPlayerLabel;
    
    
//////sample data//////sample data//////sample data//////sample data//////sample data
    GameState gameState;
    uint32_t ourRandom;
    BOOL receivedRandom;
    NSString *otherPlayerID;
}


-(id) init;
-(void)multiPlayerGame;
-(void) checkCollisionWithPlayer;
-(void)checkCollisionWithOpponent;
@end
