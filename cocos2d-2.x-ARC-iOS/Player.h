//
//  Player.h
//  PongT2
//
//  Created by Shawney Moore on 2/16/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCNode
{
    int score;
    int velocity;
    CGPoint position;
    CCSprite* paddleSprite;
    CGSize screenSize;
}

-(void) setSprite: (CCSprite*) paddleSprite;
-(void) setVelocity: (int) velocity;
-(void) moveRight;
-(void) moveLeft;
-(void) setPosition:(CGPoint)position;
-(float) getXpos;
+(id)playerWithParentNode:(CCNode*)parentNode;
-(id)initWithParentNode:(CCNode*)parentNode;
-(int) getScore;
-(void) updateScore;



@end
