//
//  GameLayer.h
//  PongT2
//
//  Created by Shawney Moore on 2/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Ball.h"
#import "Player.h"
#import "Constants.h"
#import "EndGameScene.h"


@interface GameLayer : CCLayer 
{
    int times;
    
    Ball *ball;
    Player *player;
    Player *opponent;
    CCLabelTTF *opponentRoundLabel;
    CCLabelTTF *playerRoundLabel;
    CCLabelTTF *opponentScoreLabel;
    CCLabelTTF *playerScoreLabel;
    CCLabelTTF *timeLabel;
    CCLabelTTF *highScoreLabel;
    CCLabelTTF *winnerLabel;
    CCLabelTTF *countdownLabel;
    ccTime totalTime;
    NSString *highscore;
    NSString *winner;
    NSUserDefaults *prefs;
    NSInteger *currhighscore;
    NSInteger *currentscore;
    BOOL playerScored;
    CCMenuItemImage* pauseButton;
    CCMenu* menu;
    CGSize screenSize;
    
    int oneThirdOfPlayerPaddle;
    int oneThirdOfOpponentPaddle;
    
}

-(void) setMatchNum1;
-(void) setMatchNum2;
-(void) setMatchNum3;
-(id) init;
-(void) checkCollision;
@end
