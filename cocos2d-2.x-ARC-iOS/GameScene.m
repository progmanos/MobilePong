//
//  GameScene.m
//  MobilePong2
//
//  Created by Rashad on 2/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

-(id)init {
        self = [super init];
        if (self != nil) {
            gameLayer = [GameLayer node];
            [self addChild:gameLayer];
        }
    return self;
}

@end
