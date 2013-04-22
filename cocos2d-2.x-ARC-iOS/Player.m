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
@synthesize playerType;

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
        
        roundScore = 0;
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

-(void) setSpeed:(int)newSpeed
{
    speed = newSpeed;
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
        position.x += speed;
    }
}

-(void) moveLeft
{
    int ScreenLeftEdgeXPos = 0;
    if ((paddleSprite.position.x - ([self getPaddleWidth]/2)) >= ScreenLeftEdgeXPos) {
        position.x -= speed;
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

-(int) getRoundScore
{
    return roundScore;
}

-(void) updateRoundScore
{
    roundScore += 1;
}

-(void) resetRoundScore
{
    roundScore = 0;
}
-(void) resizePaddleWidth:(float)width  {
    paddleSprite.scaleX = width / paddleSprite.contentSize.width;
}


// adds half of height to user paddle to get the top of paddle
// adds half of height to the player's paddle to get the tip center point of the paddle
-(CGFloat) tipOfPaddle{
    CGFloat tip;
    if (playerType == User)
        tip = position.y + (paddleSprite.contentSize.height/* * paddleSprite.scaleY*/)/2;
    else
        tip = position.y - (paddleSprite.contentSize.height/* * paddleSprite.scaleY*/)/2;
    return tip;
}

// adds half of width to player's paddle to get the right half of the paddle
-(CGFloat) rightHalfOfPaddle{
    return(position.x + (paddleSprite.contentSize.width/* * paddleSprite.scaleY*/)/2);
}

// subtracts half of width to player's paddle to get the left half of the paddle
-(CGFloat) leftHalfOfPaddle{
    return(position.x - (paddleSprite.contentSize.width/* * paddleSprite.scaleY*/)/2);
}


-(int) GetCollisionSegment:(CGFloat)ballCtrTip leftPos:(CGFloat)ballposLeft rightPos:(CGFloat)ballRightPos
{
    //define paddle segments ranges
    CGFloat segALeftEdge = paddleSprite.position.x - (paddleSprite.contentSize.width)/2;
    CGFloat segARightEdge = segALeftEdge + 20;
    CGFloat segA[] = {segALeftEdge, segARightEdge};
    CGFloat segB[] = {segARightEdge, segARightEdge + 20};
    CGFloat segC[] = {segB[1], segB[1]+20};
    
    if(ballCtrTip < segA[1] && ballRightPos >= segA[0])  {
        return SegmentA;
    }
    else if(ballCtrTip >= segB[0] && ballCtrTip < segB[1])  {
        return SegmentB;
    }
    else if(ballposLeft <= segC[1] && ballCtrTip >= segC[0])  {
        return SegmentC;
    }
    
    return -1;
}
@end