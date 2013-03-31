//
//  Player.m
//  PongT2
//
//  Created by Shawney Moore on 2/16/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player

@synthesize paddleSprite;
@synthesize initialPaddleWidth;

+(id)playerWithParentNode:(CCNode *)parentNode
{
    return[[self alloc] initWithParentNode:parentNode];
}

-(id) initWithParentNode:(CCNode *)parentNode
{
    if((self = [super init]))
    {
        [parentNode addChild:self];
        screenSize = [CCDirector sharedDirector].winSize;
        
        paddleSprite = [CCSprite spriteWithFile:@"paddle.png"];
        initialPaddleWidth = [self getPaddleWidth];
        
        paddleSprite.position = CGPointMake(CCRANDOM_0_1() * screenSize.width, CCRANDOM_0_1() * screenSize.height);
        
        score = 0;
        [self addChild:paddleSprite];
        
    
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) setSprite:(CCSprite *)sp
{
    paddleSprite = sp;
}

-(void) setVelocity:(int)v
{
    velocity = v;
}

-(void) update:(ccTime)delta
{
    paddleSprite.position = position;
}

-(CGFloat) getPaddleWidth {
    return (paddleSprite.contentSize.width * paddleSprite.scaleX);
}

-(float) getLeftCornerX {
    return (paddleSprite.position.x - ([self getPaddleWidth]/2));
}

-(float) getRightCornerX {
    return (paddleSprite.position.x + ([self getPaddleWidth]/2));
}

-(void) moveRight
{
    if ((paddleSprite.position.x + ([self getPaddleWidth]/2)) <= screenSize.width) {
        position.x += velocity;
    }
}

-(void) moveLeft
{
    int ScreenLeftEdgeXPos = 0;
    if ((paddleSprite.position.x - ([self getPaddleWidth]/2)) >= ScreenLeftEdgeXPos) {
        position.x -= velocity;
    }
}
-(void) setPosition:(CGPoint)p
{
    position = p;
}
-(void) setXPosition:(CGFloat)p
{
    position.x = p;
}
-(float) getXpos
{
    return position.x;
}

-(float) getYpos
{
    return position.y;
}

-(int) getScore
{
    return score;
}

-(void) updateScore
{
    score += 1;
}

-(void) resetScore
{
    score = 0;
}
-(void) resizePaddleWidth:(float)width  {
    paddleSprite.scaleX = width / paddleSprite.contentSize.width;
}

//first point to the left of center (end of section C)
-(CGFloat) first{
    return (position.x - ((paddleSprite.contentSize.width * paddleSprite.scaleX*.25)/2.0));
}

//first point to the right of center (end of section C)
-(CGFloat) second{
    return (position.x + ((paddleSprite.contentSize.width * paddleSprite.scaleX*.25)/2.0));
}

//second point to the left of center (end of section B)
-(CGFloat) third{
    return (position.x - ((paddleSprite.contentSize.width * paddleSprite.scaleX*.375)/2.0));
}

//second point to the right of center (end of section D)
-(CGFloat) fourth{
    return (position.x + ((paddleSprite.contentSize.width * paddleSprite.scaleX*.375)/2.0));
}

//third point to the left of center (end of section A)
-(CGFloat) fifth
{
    return (position.x - ((paddleSprite.contentSize.width * paddleSprite.scaleX)/2.0));
}

//third point to the right of center (end of section E)
-(CGFloat) sixth
{
    return (position.x + ((paddleSprite.contentSize.width * paddleSprite.scaleX)/2.0));
}

// adds half of height to user paddle to get the top of paddle
-(CGFloat) tipOfPaddle{
    return(position.y + (paddleSprite.contentSize.height/* * paddleSprite.scaleY*/)/2);
}

// adds half of width to user paddle to get the right side of paddle
-(CGFloat) rightOfPaddle{
    return(position.x + (paddleSprite.contentSize.width/* * paddleSprite.scaleY*/)/2);
}

// subtracts half of width to user paddle to get the left side of paddle
-(CGFloat) leftOfPaddle{
    return(position.x - (paddleSprite.contentSize.width/* * paddleSprite.scaleY*/)/2);
}

// subtracts half of height to opponents paddle to get the top of paddle
-(CGFloat) OpponentTipOfPaddle{
    return(position.y - (paddleSprite.contentSize.height/* * paddleSprite.scaleY*/)/2);
    
}



-(BOOL) inSegmentA: (CGFloat) ballposCtr leftPos: (CGFloat) ballposL rightPos: (CGFloat) ballposR
{
    if(ballposR >= [self leftOfPaddle] && ballposCtr < [self third])
        return TRUE;
    else
        return  FALSE;
}

-(BOOL) inSegmentE: (CGFloat) ballposCtr leftPos: (CGFloat) ballposL rightPos: (CGFloat) ballposR
{
    if(ballposL <= [self rightOfPaddle] && ballposCtr > [self fourth])
        return TRUE;
    else
        return FALSE;
}
-(BOOL) inSegmentB: (CGFloat) ballposCtr leftPos: (CGFloat) ballposL rightPos: (CGFloat) ballposR
{
    if(ballposCtr >= [self third] && ballposCtr <= [self first])
        return TRUE;
    else
        return FALSE;
}
-(BOOL) inSegmentD: (CGFloat) ballposCtr leftPos: (CGFloat) ballposL rightPos: (CGFloat) ballposR
{
    if(ballposL <= [self fourth] && ballposCtr >= [self second])
        return TRUE;
    else
        return FALSE;
}
@end
