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
#import "Nextpeer/Nextpeer.h"

@interface GameLayer : CCLayer
{
    Ball *ball;
    Player *player1;
    Player *AIplayer;
    CCLabelTTF *AIscoreLabel;
    CCLabelTTF *player1scoreLabel;
    CCLabelTTF *timeLabel;
    CCLabelTTF *highScoreLabel;
    CCLabelTTF *winnerLabel;
    ccTime totalTime;
    NSString *highscore;
    NSString *winner;
    NSUserDefaults *prefs;
    NSInteger *currhighscore;
    NSInteger *currentscore;
    BOOL playerScored;
    CCMenuItemImage* pauseButton;
    CCMenu* menu;
    
    
}


-(id) init;
-(void)singlePlayerGame;
-(void)multiPlayerGame;
-(void) checkCollisionWithPlayer;
-(void)checkCollisionWithOpponent;
@end
