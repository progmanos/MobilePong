//
//  MenuScene.m
//  MobilePong2
//
//  Created by Rashad on 2/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "MenuLayer.h"

@implementation MenuScene
-(id)init {
    self = [super init];
    if (self != nil) {
        //Place holder for any background layer for the menu
        
        //Add Menu Layer
        menuLayer = [MenuLayer node];
        
        /* add z index if you add the background layer */
        [self addChild:menuLayer];
    }
    return self;
}


@end
