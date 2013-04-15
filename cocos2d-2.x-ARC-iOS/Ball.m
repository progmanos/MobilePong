//
//  Ball.m
//  PongT2
//
//  Created by Shawney Moore on 2/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
//#import "Math.h"

@implementation Ball

@synthesize didCollide;
@synthesize ballSprite;
@synthesize velocity;
@synthesize prevPosition;

+(id)ballWithParentNode:(CCNode *)parentNode
{
    return[[self alloc] initWithParentNode:parentNode];
}

-(id) initWithParentNode:(CCNode *)parentNode
{
    if((self = [super init]))
    {
        score = FALSE;
        [parentNode addChild:self];
        screenSize = [CCDirector sharedDirector].winSize;
        
        ballSprite = [CCSprite spriteWithFile:@"ball.png"];
        
        // create initial serving position, needs to be refactored
        position = CGPointMake(CCRANDOM_0_1() * screenSize.width, CCRANDOM_0_1() * screenSize.height);
        [self addChild:ballSprite];
        
        [self scheduleUpdate];
            
        srandom(time(NULL));
        
        /* generate inital random angles */
        CGFloat randSelect = random() % 10;
        CGFloat randangle1 = random()%150+30;
        CGFloat randangle2 = random()%330+210;
        CGFloat randangle;
        
        if(randSelect >= 5)
            randangle = randangle1;
        else
            randangle = randangle2;
        
        CGPoint initialvel = [self calcVelocity:MIN_BALL_SPEED withAngle: CC_DEGREES_TO_RADIANS(randangle)];
        velocity.x = initialvel.x;
        velocity.y = initialvel.y;
    }

    
    return self;
}

-(void) update:(ccTime)delta
{
    ballSprite.position = position;
    if(!multiplayer && !score)
        [self moveBall];
    //else if(!score && playerConnected)
    //{
        //[self moveBall];
    //}
    if(position.y < -16)
    {
        score = TRUE;
    }
    
    //pplayer scores and serves ball
    else if(position.y >500)
    {
        score = TRUE;
    }
    else
        score = FALSE;
}



-(CGPoint) getVelocity
{
    return velocity;
}
-(void) setPosition: (CGPoint) p
{
    position = p;
}

-(CGPoint) getPosition
{
    return  position;
}


-(void) moveBall
{
    
    position.x += velocity.x;
    position.y += velocity.y;
    
    
    //Handles bouncing on walls
    if(position.x < 0 || position.x >screenSize.width){
        velocity.x = -velocity.x;}
    
    //AI scores and serves ball
    if(position.y < -16)
    {
        score = TRUE;
        [self AIserveBall];
    }
    
    //pplayer scores and serves ball
    if(position.y >500)
    {
        score = TRUE;
        [self player1serveBall];
    }
    
    if(position.y > 230 && position.y < 350)
        self.didCollide = FALSE;

    
}

//Freezes ball on players side of the screen for 5 seconds
-(void) player1serveBall
{
    
    tempVelocity = velocity;
    
    screenSize = [CCDirector sharedDirector].winSize;
    position = CGPointMake((arc4random()%300) + 1, (screenSize.height/4));
    velocity.x = 0;
    velocity.y = 0;
    
    [self performSelector:@selector(resumeMove) withObject:nil afterDelay:2.0];


}


//Freezes ball on AI side of the screen for 5 seconds
-(void) AIserveBall
{
    
    tempVelocity = velocity;
    
    screenSize = [CCDirector sharedDirector].winSize;
    position = CGPointMake((arc4random()%300) + 1, (screenSize.height - (screenSize.height/4)));
    velocity.x = 0;
    velocity.y = 0;
    [self performSelector:@selector(resumeMove) withObject:nil afterDelay:2.0];

}


//Ball resumes movement
-(void) resumeMove
{
    score = FALSE;
    CGPoint newvel = CGPointMake(tempVelocity.x, tempVelocity.y);
    velocity.x = newvel.x;
    velocity.y = newvel.y;
    tempVelocity = CGPointMake(0, 0);
}


-(float) getXpos
{
    return position.x;
}

-(float) getYpos
{
    return position.y;
}
//subtracts half of ball to get tip of ball as it approaches user
-(CGFloat) tipOfBall{
    return(position.y - (ballSprite.contentSize.height /* ballSprite.scaleY*/)/2);
}

-(float) getDiameter
{
    // use scaleX to account for retina display
    return (ballSprite.contentSize.width * ballSprite.scaleX);
}

//adds half of ball to get tip of ball as it approaches user
-(CGFloat) opponentTipOfBall{
    return(position.y + (ballSprite.contentSize.height /* ballSprite.scaleY*/)/2);
}

-(float) getTopTipY
{
    float diameter = [self getDiameter];
    return (ballSprite.position.y + (diameter/2.0));
}

//adds half of ball to get right of ball to get right tip
-(CGFloat) rightOfBall{
    return(position.x + (ballSprite.contentSize.height /* ballSprite.scaleY*/)/2);
}

-(float) getBottomTipY
{
    float diameter = [self getDiameter];
    return (ballSprite.position.y - (diameter/2.0));
}

//subtracts half of ball to get left of ball to get right tip
-(CGFloat) leftOfBall{
    return(position.x - (ballSprite.contentSize.height /* ballSprite.scaleY*/)/2);
}

-(float) getLeftTipX
{
    float diameter = [self getDiameter];
    return (ballSprite.position.x - (diameter/2.0));
}

//gets x position of the ball when looking at the top or bottom
-(CGFloat) tipOfBallX{
    return  position.x;
}

-(float) getRightTipX
{
    float diameter = [self getDiameter];
    return (ballSprite.position.x + (diameter/2.0));
}

-(CGPoint) calcVelocity: (CGFloat) speed withAngle: (CGFloat) angle
{
    return CGPointMake(speed*cosf(speed), speed*sinf(angle));
}

-(CGFloat) getSpeed
{
    return [self getSpeed:velocity];
}

-(CGFloat) getAngle
{
    return [self getAngle:velocity];
}

-(CGFloat) getSpeed: (CGPoint) velocityVector
{
    return sqrtf(powf(velocityVector.x,2) + powf(velocityVector.y,2));
}

-(CGFloat) getAngle: (CGPoint) velocityVector
{
    return acosf(velocityVector.x / [self getSpeed:velocityVector]);
}

-(CGPoint) reflectStraight: (CGPoint) normVect
{
    //  CGPoint curVector = CGPointMake(position.x - prevPosition.x, position.y - prevPosition.y);
    CGFloat dotproduct = ccpDot(velocity,normVect);
    CGFloat reflectionVectX = velocity.x - 2*normVect.x*dotproduct;
    CGFloat reflectionVectY = velocity.y - 2*normVect.y*dotproduct;
    CGPoint newVelocity = CGPointMake(reflectionVectX, reflectionVectY);
    return newVelocity;
}

-(CGPoint) reflect: (CGPoint) normVect withBlunt:  (BluntFuncBlock) bluntfunc
{
    CGPoint reflectionVect = [self reflectStraight:normVect];
    CGFloat newAngle = [self getAngle:reflectionVect] + bluntfunc(normVect.x);
    CGPoint newVelocity = [self calcVelocity:[self getSpeed:reflectionVect] withAngle:newAngle];
    return newVelocity;
}



@end
