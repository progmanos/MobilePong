//
//  GameLayer.m
//  PongT2
//
//  Created by Shawney Moore on 2/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
#import "GameLayer.h"



@implementation GameLayer

-(id) init
{
    if ((self = [super init]))
    {
        // get level, set default level if the level key does not exist
        NSInteger level = [self GetLevel];
        
        if (level == 0) {
            NSInteger defaultLevel = 1;
            [self SetLevel:defaultLevel];
        }
        
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        self.isTouchEnabled = YES;
        
        // move this to a header file for use in other classes
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"court.png"];
        [self addChild:background z:0 tag:1];
        
        
        ball1 = [Ball ballWithParentNode:self];
        player1 = [Player playerWithParentNode:self];
        AIplayer = [Player playerWithParentNode:self];
        
        [player1 setPosition:CGPointMake(screenSize.width / 2, 20.0)];
        [AIplayer setPosition:CGPointMake(screenSize.width/2, (screenSize.height - 20))];
        
        AIscoreLabel = [CCLabelTTF labelWithString:@"8" fontName:@"Marker Felt" fontSize:24];
        AIscoreLabel.position = ccp(100, 340);
        [self addChild:AIscoreLabel z:1];
        
        player1scoreLabel = [CCLabelTTF labelWithString:@"8" fontName:@"Marker Felt" fontSize:24];
        player1scoreLabel.position = ccp(240, 160);
        [self addChild:player1scoreLabel z:1];
        
        [player1 setVelocity:(5)];
        [AIplayer setVelocity:(1)];
        
        
        [self scheduleUpdate];
        

        
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        
        
        
    }
	
    return self;
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

-(void) movePlayerLeft
{
    [player1 moveLeft];
}

-(void) movePlayerRight
{
    [player1 moveRight];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
    CGFloat currPaddleWidth = player1.getPaddleWidth;
    if(point.x < (player1.paddleSprite.position.x - (currPaddleWidth/2))) {
        [self schedule:@selector(movePlayerLeft)];
    }
    else {
        [self schedule:@selector(movePlayerRight)];
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self unschedule:@selector(movePlayerLeft)];
    [self unschedule:@selector(movePlayerRight)];
}

-(void) update:(ccTime)delta
{

    
    if([ball1 getYpos] <= 30 && ball1.didCollide == FALSE && ([ball1 getXpos]) > ([player1 getXpos] - 30) && ([ball1 getXpos] < [player1 getXpos] + 30))
    {
        [ball1 switchVel];
        
    }
    if([ball1 getYpos] == 10)
        [player1 updateScore];

    
    if ([AIplayer getXpos] > [ball1 getXpos] && [ball1 getYpos] > 200)
        [AIplayer moveLeft];
    
    if ([AIplayer getXpos] < [ball1 getXpos] && [ball1 getYpos]  > 200)
        [AIplayer moveRight];
    
    
    [AIscoreLabel setString:[NSString stringWithFormat:@"%d", [AIplayer getScore]]];
    [player1scoreLabel setString:[NSString stringWithFormat:@"%d", [player1 getScore]]];
    
    

}

-(NSInteger) GetLevel
{
    NSInteger level = [[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
    return level;
}

-(void) SetLevel:(NSInteger) level
{
    // set level value
    [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"level"];
    
    // save the data
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end



