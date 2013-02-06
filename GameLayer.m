//
//  GameLayer.m
//  Pong
//
//  Created by Rashad on 2/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"


@implementation GameLayer

+(id) scene {
    CCScene *scene=[CCScene node]; CCLayer* layer=[GameLayer node]; [scene addChild:layer];
    return scene;
}

-(id) init {
    if ((self=[super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        pongball = [Ball spriteWithFile:@"ball1.png"];
        [self addChild:pongball z:0 tag:1];
        
        CGSize screenSize=[CCDirector sharedDirector].winSize;
       
        
        pongball.position=CGPointMake(screenSize.width / 2, screenSize.height / 2);
    }
    return self;
}

-void

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}
@end

