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
}

@property (nonatomic) CCSprite* ballSprite;
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



@end
