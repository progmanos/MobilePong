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

+(id)ballWithParentNode:(CCNode *)parentNode
{
    return[[self alloc] initWithParentNode:parentNode];
}

-(id) initWithParentNode:(CCNode *)parentNode
{
    if((self = [super init]))
    {
        score = FALSE;
        resumeMove = FALSE;
        [parentNode addChild:self];
        screenSize = [CCDirector sharedDirector].winSize;
        
        ballSprite = [CCSprite spriteWithFile:@"ball.png"];
        
        // create initial serving position, needs to be refactored
        position = CGPointMake(CCRANDOM_0_1() * screenSize.width, CCRANDOM_0_1() * screenSize.height);
        [self addChild:ballSprite];
        
        [self scheduleUpdate];
            
        curVelocity = CGPointMake(4, 4);
        
        baseXVelocity = 4;
//        [self player1serveBall];
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
}


-(void) setCurVel: (CGPoint) crV
{
    curVelocity = crV;
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
    if(position.x < 5 || position.x >screenSize.width-5){
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
    
    if(resumeMove)
        [self performSelector:@selector(resumeMove) withObject:nil afterDelay:2.0];

    
}

//Freezes ball on players side of the screen for 5 seconds
-(void) player1serveBall
{
    
    tempVelocity = curVelocity;
    
    screenSize = [CCDirector sharedDirector].winSize;
    position = CGPointMake((arc4random()%300) + 1, (screenSize.height/4));
    curVelocity.x = 0;
    curVelocity.y = 0;
    resumeMove = TRUE;
    
    //[self performSelector:@selector(resumeMove) withObject:nil afterDelay:2.0];


}


//Freezes ball on AI side of the screen for 5 seconds
-(void) AIserveBall
{
    
    tempVelocity = curVelocity;
    
    screenSize = [CCDirector sharedDirector].winSize;
    position = CGPointMake((arc4random()%300) + 1, (screenSize.height - (screenSize.height/4)));
    curVelocity.x = 0;
    curVelocity.y = 0;
    resumeMove = TRUE;
    //[self performSelector:@selector(resumeMove) withObject:nil afterDelay:2.0];

}


//Ball resumes movement
-(void) resumeMove
{
    score = FALSE;
    curVelocity = CGPointMake(tempVelocity.x, tempVelocity.y);
    tempVelocity = CGPointMake(0, 0);
    resumeMove = FALSE;
}


//changes x velocity by 30%
-(void) updateVelocityA
{
    curVelocity.y = - curVelocity.y;
    curVelocity.x = -baseXVelocity*1.3;
    
}

//changes x velocity by 15%
-(void) updateVelocityB
{
    curVelocity.y = - curVelocity.y;
    curVelocity.x = -baseXVelocity*1.15;
}


-(void) updateVelocityC
{
    curVelocity.y = - curVelocity.y;
    if(curVelocity.x > 0)
        curVelocity.x = baseXVelocity;
    else
        curVelocity.x = -baseXVelocity;
}

//changes x velocity by 15%
-(void) updateVelocityD
{
    curVelocity.y = - curVelocity.y;
    
    curVelocity.x = baseXVelocity*1.15;
}

//changes x velocity by 30%
-(void) updateVelocityE
{
    curVelocity.y = - curVelocity.y;
    
    curVelocity.x = baseXVelocity*1.3;
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

//method not working trying to figure out a way to track directions of ball but it changes when it is headed toward user so this does not work... i think
-(BOOL) movingRight{
    if (lastPosition<position.x){
        return true;
    }
    else{
        return false;
    }
    
    
}
-(void)setVelocity:(CGPoint)newVel
{
    curVelocity.x = newVel.x;
    curVelocity.y = newVel.y;
}



@end
