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
-(float) getXpos
{
    return position.x;
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
@end
