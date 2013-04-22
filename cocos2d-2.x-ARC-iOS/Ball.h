//
//  Ball.h
//  PongT2
//
//  Created by Shawney Moore on 2/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface Ball : CCNode

{
    
    CGPoint position;
    CGPoint tempVelocity;
    CGSize screenSize;
    BOOL score;
}
@property (nonatomic, assign) CCSprite* ballSprite;
@property (nonatomic) BOOL didCollide;
@property (nonatomic) CGPoint velocity;
@property (nonatomic) CGPoint prevPosition;

/*
 typdef function used for defining the blunt function
 */
typedef CGFloat (^BluntFuncBlock)(CGFloat x);

-(void) setPosition: (CGPoint) position;
-(CGPoint) getPosition;
-(void) moveBall;
-(void) player1serveBall;
-(void) AIserveBall;
-(float) getXpos;
-(float) getYpos;

/*
 Since velocity.x = speed * cos(angle),
 we simply use arccos(velocity.x/speed) to find the angle
 
 Returns ball angle in radians
 */
-(CGFloat) getAngle;

/*
 @velocityVector: CGPoint representation of a velocity vector
 Returns the vector's angle in radians
 */
-(CGFloat) getAngle: (CGPoint) velocityVector;

/*
 speed = magnitude of velocity
 speed = sqrt( velocity.x^2 + velocity.y^2)
 Returns ball speed
 */
-(CGFloat) getSpeed;

/*
 @velocityVector: CGPoint representation of a velocity vector
 Returns the scalar valued speed of the vector
 */
-(CGFloat) getSpeed: (CGPoint) velocityVector;

/*
 @speed: scalar valued speed of the ball, magnitude of velocity
 @angle: angle of movement of the ball
 
 This functions calculates the velocity vector using physics functions
 velocity.x = speed * cos(angle)
 velocity.y = speed * sin(angle)
 
 Returns a velocity vector as a CGPoint
 */
-(CGPoint) calcVelocity: (CGFloat) speed withAngle: (CGFloat) angle;

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

-(CGFloat) opponentTipOfBall;

/*
 returns the regular (straight) reflection vector
 Reflection formula: ResultVector = V - 2 * CrossProduct(DotProduct(V, N),n)
 */
-(CGPoint) reflectStraight:(CGPoint) normVect;

/*
 @normVect: vector normal to the collision point
 @bluntVal: adjust angle with a blunt value
 @speedajVal: adjust speed with a value
 
 Returns the reflection vector with a blunt angle and speed
 */
-(CGPoint) reflect: (CGPoint) normVect withBlunt: (CGFloat) bluntVal andSpeedAdjust: (CGFloat) speedAdjVal;

@end

