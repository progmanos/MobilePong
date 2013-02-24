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

@interface GameLayer : CCLayer
{
    Ball *ball1;
    Player *player1;
    Player *AIplayer;
    CCLabelTTF *AIscoreLabel;
    CCLabelTTF *player1scoreLabel;
    CCLabelTTF *timeLabel;
    ccTime totalTime;
    NSUserDefaults *prefs;
}


-(id) init;
@end
