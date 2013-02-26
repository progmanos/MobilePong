//
//  Ball.m
//  PongT2
//
//  Created by Shawney Moore on 2/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"


@implementation Ball

@synthesize didCollide;
@synthesize ballSprite;

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
        curVelocity = CGPointMake(4, 4);
        
    }

    
    return self;
}

-(void) update:(ccTime)delta
{
    
    ballSprite.position = position;
    
    if(!score)
    {
        [self moveBall];
    }
}

-(void) setMaxVel: (CGPoint) mxV
{
    maxVelocity = mxV;
}

-(void) setMinVel: (CGPoint) mnV
{
    minVelocity = mnV;
}

-(void) setCurVel: (CGPoint) crV
{
    curVelocity = crV;
}

-(void) setMinAngle: (double) mnA
{
    minAngle = mnA;
}

-(void) setMaxAngle: (double) mxA
{
    maxAngle = mxA;
}
-(void) setCurAngle: (double) crA
{
    curAngle = crA;
}
-(double) getAngle
{
    return curAngle;
}
-(CGPoint) getVelocity
{
    return curVelocity;
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
    
    position.x += curVelocity.x;
    position.y += curVelocity.y;
    
    
    //Handles bouncing on walls
    if(position.x < 0 || position.x >screenSize.width){
        curVelocity.x = -curVelocity.x;}
    
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

-(void) switchVel
{
    curVelocity.y = -curVelocity.y;
    self.didCollide = TRUE;
}


//Freezes ball on players side of the screen for 5 seconds
-(void) player1serveBall
{
    
    tempVelocity = curVelocity;
    
    screenSize = [CCDirector sharedDirector].winSize;
    position = CGPointMake((arc4random()%300) + 1, (screenSize.height/4));
    curVelocity.x = 0;
    curVelocity.y = 0;
    
    [self performSelector:@selector(resumeMove) withObject:nil afterDelay:2.0];


}


//Freezes ball on AI side of the screen for 5 seconds
-(void) AIserveBall
{
    
    tempVelocity = curVelocity;
    
    screenSize = [CCDirector sharedDirector].winSize;
    position = CGPointMake((arc4random()%300) + 1, (screenSize.height - (screenSize.height/4)));
    curVelocity.x = 0;
    curVelocity.y = 0;
    [self performSelector:@selector(resumeMove) withObject:nil afterDelay:2.0];

}


//Ball resumes movement
-(void) resumeMove
{
    score = FALSE;
    curVelocity = CGPointMake(tempVelocity.x, tempVelocity.y);
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

-(float) getDiameter
{
    // use scaleX to account for retina display
    return (ballSprite.contentSize.width * ballSprite.scaleX);
}

-(float) getTopTipY
{
    float diameter = [self getDiameter];
    return (ballSprite.position.y + (diameter/2.0));
}

-(float) getBottomTipY
{
    float diameter = [self getDiameter];
    return (ballSprite.position.y - (diameter/2.0));
}

-(float) getLeftTipX
{
    float diameter = [self getDiameter];
    return (ballSprite.position.x - (diameter/2.0));
}

-(float) getRightTipX
{
    float diameter = [self getDiameter];
    return (ballSprite.position.x + (diameter/2.0));
}

@end
