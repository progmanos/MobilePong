///Users/rashad/Kobold2D/Kobold2D-2.0.4/Kobold2D.xcworkspace
//  GameLayer.m
//  Pong
//
//  Created by Rashad on 2/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

#define ballSpeedX 4
#define ballSpeedY 4

@implementation GameLayer

+(id) scene {
    CCScene *scene=[CCScene node]; CCLayer* layer=[GameLayer node]; [scene addChild:layer];
    return scene;
}

-(id) init {
    if ((self=[super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        CCSprite *background = [CCSprite spriteWithFile:@"court.png"];
        pongball = [Ball spriteWithFile:@"ball1.png"];
        [self addChild:background z:0 tag:0];
        [self addChild:pongball z:1 tag:1];
        
        CGSize screenSize=[CCDirector sharedDirector].winSize;
        [background setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
        
        pongball.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        pongball.velocity = CGPointMake(ballSpeedX, ballSpeedY);
        [self scheduleUpdate];
    }
    
    return self;
}

-(void)update:(ccTime)delta
{
    pongball.position = CGPointMake(pongball.position.x + pongball.velocity.x, pongball.position.y + pongball.velocity.y);
    if(pongball.position.x < 15 || pongball.position.x > 305)
        pongball.velocity = CGPointMake(-pongball.velocity.x, pongball.velocity.y);
    
    if(pongball.position.y < 15 || pongball.position.y > 445)
        pongball.velocity = CGPointMake(pongball.velocity.x, -pongball.velocity.y);

}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}
@end

