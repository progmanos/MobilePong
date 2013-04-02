//
//  MultiplayerOptionScene.m
//  PongT2
//
//  Created by Elizabeth Mitchell on 4/1/13.
//
//

#import "MultiplayerOptionScene.h"
#import "MultiplayerOptionLayer.h"
@implementation MultiplayerOptionScene


-(id)init {
    
    self = [super init];
    
    if (self != nil) {
        //Place holder for any background layer for the menu
        
        
        multiplayerOptionLayer = [MultiplayerOptionLayer node];
        
        /* add z index if you add the background layer */
        [self addChild:multiplayerOptionLayer];
    }
    return self;
    
}
@end
