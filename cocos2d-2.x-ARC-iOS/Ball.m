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
        
        ballSprite = [CCSprite spriteWithFile:@"ball1.png"];
        ballSprite.position = CGPointMake(CCRANDOM_0_1() * screenSize.width, CCRANDOM_0_1() * screenSize.height);
        [self addChild:ballSprite];
        
        [self scheduleUpdate];
        curVelocity = CGPointMake(5, 5);
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
    
    if(position.x < 0 || position.x >305){
        curVelocity.x = -curVelocity.x;}
    
    if(position.y < -16)
    {
        score = TRUE;
        [self serveBall];
        //position.y = 460;
    // curVelocity.y = -curVelocity.y;
    }
    if(position.y >460)
    {
        curVelocity.y = -curVelocity.y;
    }
    
    if(position.y > 230)
        self.didCollide = FALSE;
    
}

-(void) switchVel
{
    curVelocity.y = -curVelocity.y;
    self.didCollide = TRUE;
}

-(void) serveBall
{
    
    tempVelocity = curVelocity;
    
    for(int i = 0; i<10000000; i++) {
        //i++;
        screenSize = [CCDirector sharedDirector].winSize;
        position = CGPointMake(200, 100);
        curVelocity.x = 0;
        curVelocity.y = 0;
    }
    score = FALSE;
    curVelocity = CGPointMake(-tempVelocity.x, -tempVelocity.y);
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

@end
