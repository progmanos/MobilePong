//
//  MultiplayerScene.m
//  PongT2
//
//  Created by Shawney Moore on 3/18/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MultiplayerScene.h"


@implementation MultiplayerScene


-(id)init {
    self = [super init];
    if (self != nil) {
        multiplayerLayer = [MultiplayerLayer node];
        [self addChild:multiplayerLayer];
    }
    return self;
}
@end
