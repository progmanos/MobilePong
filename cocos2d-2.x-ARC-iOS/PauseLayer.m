//
//  PauseLayer.m
//  PongT2
//
//  Created by Elizabeth Mitchell on 3/31/13.
//
//

#import "PauseLayer.h"

@implementation PauseLayer

-(void) displayMenu
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCLabelTTF *resumelabel = [CCLabelTTF labelWithString:@"Resume" fontName:@"Arial" fontSize:32];//[CCSprite spriteWithFile:@"resume.png"];
    CCMenuItemFont *resumeGameItemLabel = [CCMenuItemFont itemWithLabel:resumelabel target:self selector:@selector(returnToGame)];
    resumelabel.color = ccBLUE;
    
    CCLabelTTF *mainMenuLabel = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Arial" fontSize:32];//[CCSprite spriteWithFile:@"MainMenuBut.png"];
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
        [CCSprite spriteWithFile:@"background2.png"];
        [background setPosition:ccp(screenSize.width/2,
                                    screenSize.height/2)];
        [self addChild:background];
        [self displayMenu];
    }
    
    return self;
}




-(void) returnToMainMenu
{
    endMultiPlayer = TRUE;
    gameOver = TRUE;
    // pop the options scene from the CCDirector and return to the menu scene
    [[CCDirector sharedDirector] popScene];
    [[CCDirector sharedDirector] popScene];
}

-(void) returnToGame
{
    // pop the options scene from the CCDirector and return to the menu scene
    [[CCDirector sharedDirector] popScene];
    gamePaused = FALSE;
    countdown = 3;
  
}


@end
