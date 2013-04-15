//
//  EndGameScene.m
//  PongT2
//
//  Created by Elizabeth Mitchell on 4/1/13.
//
//

#import "EndGameScene.h"
#import "EndGameLayer.h"

@implementation EndGameScene
-(id)init {
    
    self = [super init];
    if (self != nil) {
        //Place holder for any background layer for the menu
        
        
        endGameLayer = [EndGameLayer node];
        
        /* add z index if you add the background layer */
        [self addChild:endGameLayer];
    }
    return self;
    
}
@end
