//
//  EndGameLayer.m
//  PongT2
//
//  Created by Elizabeth Mitchell on 4/1/13.
//
//

#import "EndGameLayer.h"

@implementation EndGameLayer
-(void) displayMenu
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCLabelTTF *resumelabel = [CCSprite spriteWithFile:@"newgameBut.png"];//[CCLabelTTF labelWithString:@"Play Again" fontName:@"Arial" fontSize:32];
    CCMenuItemFont *resumeGameItemLabel = [CCMenuItemFont itemWithLabel:resumelabel target:self selector:@selector(returnToGame)];
    
    CCLabelTTF *mainMenuLabel = [CCSprite spriteWithFile:@"MainMenuBut.png"];//[CCLabelTTF labelWithString:@"Main Menu" fontName:@"Arial" fontSize:32];
    mainMenuLabel.color = ccRED;
    
    CCMenuItemFont *mainMenuGameItemLabel = [CCMenuItemFont itemWithLabel:mainMenuLabel target:self selector:@selector(returnToMainMenu)];
    
    
    
    
    pauseMenu = [CCMenu
                 menuWithItems:resumeGameItemLabel,mainMenuGameItemLabel, nil];
    
    [pauseMenu alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
    [pauseMenu setPosition:
     ccp(screenSize.width / 2.0f,
         screenSize.height / 2.0f)];
    
    [self addChild:pauseMenu z:1];
}



-(id)init {
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *background =
        [CCSprite spriteWithFile:@"gameover.png"];
        [background setPosition:ccp(screenSize.width/2,
                                    screenSize.height/2)];
        [self addChild:background];
        [self displayMenu];
    }
    
    return self;
}




-(void) returnToMainMenu
{
    // pop the options scene from the CCDirector and return to the menu scene
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] popScene];
}

-(void) returnToGame
{
    // pop the options scene from the CCDirector and return to the menu scene
    [[CCDirector sharedDirector] popScene];
    
}

@end
