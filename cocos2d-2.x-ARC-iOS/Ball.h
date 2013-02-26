//
//  Ball.h
//  PongT2
//
//  Created by Shawney Moore on 2/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

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

    CGSize screenSize;
    BOOL score;
    CGFloat lastPosition;
    CGFloat baseXVelocity;
}

@property (nonatomic) CCSprite* ballSprite;
@property (nonatomic) BOOL didCollide;
-(void) setCurVel: (CGPoint) curVelocity;
-(CGPoint) getVelocity;
-(void) setPosition: (CGPoint) position;
-(CGPoint) getPosition;
-(void) moveBall;
-(void) updateVelocityA;
-(void) updateVelocityB;
-(void) updateVelocityC;
-(void) updateVelocityD;
-(void) updateVelocityE;
-(void) player1serveBall;
-(void) AIserveBall;
-(float) getXpos;
-(float) getYpos;

// for the bottom and top collision we only need to calculate the y value
// bottom: position.y (center of ball) - radius
// top: position.y (center of ball) + radius
-(float) getTopTipY;
-(float) getBottomTipY;

// we only need to calculate the x values for side collisions
// get the x values by moving outward position.x (+ or -) radius
-(float) getLeftTipX;
-(float) getRightTipX;

-(float) getDiameter;

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
