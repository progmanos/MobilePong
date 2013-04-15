//
//  TutorialLayer.m
//  PongT2
//
//  Created by Elizabeth Mitchell on 3/30/13.
//
//

#import "TutorialLayer.h"

@implementation TutorialLayer
    -(id)init {
        touchHappened  =0;
        self = [super init];
        if (self != nil) {
        self.isTouchEnabled = YES;
        
        // move this to a header file for use in other classes
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        //sets background to court image
        CCSprite *background = [CCSprite spriteWithFile:@"Tutorials Welcome.png"];
        [self addChild:background z:0 tag:1];
            background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        }
        return self;
        
    }

-(void) nextTutorial{
    if(touchHappened  == 0){
        // move this to a header file for use in other classes
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        //sets background to court image
        CCSprite *background = [CCSprite spriteWithFile:@"Tutorials Layout.png"];
        [self addChild:background z:0 tag:1];
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        touchHappened ++;
    }
    else if(touchHappened  == 1){
        // move this to a header file for use in other classes
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        //sets background to court image
        CCSprite *background = [CCSprite spriteWithFile:@"Tutorials Objective.png"];
        [self addChild:background z:0 tag:1];
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        touchHappened ++;
    }
    else if(touchHappened  == 2){
        // move this to a header file for use in other classes
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        //sets background to court image
        CCSprite *background = [CCSprite spriteWithFile:@"Tutorials Goal.png"];
        [self addChild:background z:0 tag:1];
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        touchHappened ++;
    }
    else if(touchHappened  == 3){
       [[CCDirector sharedDirector] popScene];   }
    
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   [self nextTutorial];
}


@end
