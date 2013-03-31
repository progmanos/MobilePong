//
//  tutorialScene.m
//  PongT2
//
//  Created by Elizabeth Mitchell on 3/30/13.
//
//

#import "tutorialScene.h"

@implementation tutorialScene
-(id)init {
    
    self = [super init];
    if (self != nil) {
        //Place holder for any background layer for the menu
        
       
        tutorialsLayer = [TutorialLayer node];
        
        /* add z index if you add the background layer */
        [self addChild:tutorialsLayer];
    }
    return self;
    
}



@end
