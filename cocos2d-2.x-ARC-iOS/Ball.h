//
//  Ball.h
//  PongT2
//
//  Created by Shawney Moore on 2/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "math.h"


@interface Ball : CCNode

{
    
    double curAngle;
    double minAngle;
    double maxAngle;
    CGPoint curVelocity;
    CGPoint tempVelocity;
    CGPoint maxVelocity;
    CGPoint minVelocity;
    CGPoint position;
    CCSprite* ballSprite;
    CGSize screenSize;
    BOOL score;
    CGFloat lastPositionY;
    CGFloat lastPositionX;
    
}

@property (nonatomic) BOOL didCollide;
-(void) setMaxVel: (CGPoint) maxVelocity;
-(void) setMinVel: (CGPoint) minVelocity;
-(void) setCurVel: (CGPoint) curVelocity;
-(void) setMinAngle: (double) minAngle;
-(void) setMaxAngle: (double) maxAngle;
-(void) setCurAngle: (double) curAngle;
-(double) getAngle;
-(CGPoint) getVelocity;
-(void) setPosition: (CGPoint) position;
-(CGPoint) getPosition;
-(void) moveBall;
-(void) switchVel;
-(void) player1serveBall;
-(void) AIserveBall;
-(float) getXpos;
-(float) getYpos;
+(id)ballWithParentNode:(CCNode*)parentNode;
-(id)initWithParentNode:(CCNode*)parentNode;
-(CGFloat) tipOfBall;
-(CGFloat) rightOfBall;
-(CGFloat) leftOfBall;
-(CGFloat) tipOfBallX;
-(float) getBallWidth;
-(BOOL) movingRight;
-(CGFloat) opponentTipOfBall;



@end
