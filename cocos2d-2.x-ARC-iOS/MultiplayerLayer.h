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
#import "PauseScene.h"


@interface MultiplayerLayer : CCLayer<GameKitHelperProtocol>{
    int times;
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
    BOOL pausePressed;
    BOOL playerDetermined;
    BOOL opponentRecRandNum;
    int ournumber;
    int opponentnumber;
    int countdowntostart;
    
    CCLabelTTF *whichPlayerLabel;
    
}


-(id) init;
-(void)multiPlayerGame;
-(void) checkCollisionWithPlayer;
-(void)checkCollisionWithOpponent;
@end
