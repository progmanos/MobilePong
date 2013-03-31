//
//  PauseScene.m
//  PongT2
//
//  Created by Elizabeth Mitchell on 3/31/13.
//
//

#import "PauseScene.h"
#import "PauseLayer.h"
@implementation PauseScene
-(id)init {
    
    self = [super init];
    if (self != nil) {
        //Place holder for any background layer for the menu
        
        
        pauseLayer = [PauseLayer node];
        
        /* add z index if you add the background layer */
        [self addChild:pauseLayer];
    }
    return self;
    
}
@end
