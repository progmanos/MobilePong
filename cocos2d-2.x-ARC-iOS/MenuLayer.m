//
//  MenuLayer.m
//  MobilePong2
//
//  Created by Rashad on 2/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//


#import "MenuLayer.h"



@implementation MenuLayer

-(void) playGame
{
    multiplayer = false;
    //push the game scene so we can easily pop it of the stack and return to the main menu
    [[CCDirector sharedDirector] pushScene:[GameScene node]];
}
-(void) showOptions
{
    [[CCDirector sharedDirector] pushScene:[OptionsScene node]];
}

-(void) tutorial
{
    //push the game scene so we can easily pop it of the stack and return to the main menu
    [[CCDirector sharedDirector] pushScene:[tutorialScene node]];
}

-(void)showMultiplayer
{
    multiplayer = TRUE;
    [[CCDirector sharedDirector] pushScene:[MultiplayerScene node]];
}
-(void) displayMenu
{
    pointsToWin = 11;
    multiplayer = FALSE;
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCLabelTTF *playlabel = [CCSprite spriteWithFile:@"SinglePlayer.png"];//[CCLabelTTF labelWithString:@"Single Player" fontName:@"Arial" fontSize:32];
    CCMenuItemFont *playGameItemLabel = [CCMenuItemFont itemWithLabel:playlabel target:self selector:@selector(playGame)];
    playGameItemLabel.color = ccBLUE;
    
    CCLabelTTF *optionsLabel = [CCSprite spriteWithFile:@"Options.png"];//[CCLabelTTF labelWithString:@"Options" fontName:@"Arial" fontSize:32];
    optionsLabel.color = ccRED;
    
    CCMenuItemFont *optionsItemLabel = [CCMenuItemFont itemWithLabel:optionsLabel target:self selector:@selector(showOptions)];
    
    CCLabelTTF *tutorialLabel = [CCSprite spriteWithFile:@"TutorialBut.png"];//[CCLabelTTF labelWithString:@"Tutorial" fontName:@"Arial" fontSize:32];
    tutorialLabel.color = ccYELLOW;
    CCMenuItemFont *tutorialItemLabel  = [CCMenuItemFont itemWithLabel:tutorialLabel target:self selector:@selector(tutorial)];
    
    CCLabelTTF *multiplayerLabel = [CCSprite spriteWithFile:@"multiplayerBut.png"];//[CCLabelTTF labelWithString:@"Multiplayer" fontName:@"Arial" fontSize:32];
    multiplayerLabel.color = ccGREEN;
    
    CCMenuItemFont *multiplayerItemLabel = [CCMenuItemFont itemWithLabel:multiplayerLabel target:self selector:@selector(showMultiplayer)];
    
    
    mainMenu = [CCMenu
                menuWithItems:playGameItemLabel, multiplayerItemLabel, optionsItemLabel, tutorialItemLabel, nil];
    
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
    [mainMenu setPosition:
     ccp(screenSize.width / 2.0f,
         screenSize.height / 2.25f)];
    
    [self addChild:mainMenu z:1];
}


-(id) init
{
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *background =
        [CCSprite spriteWithFile:@"MainMenu2.png"];
        [background setPosition:ccp(screenSize.width/2,
                                    screenSize.height/2)];
        [self addChild:background];
        [self displayMenu];
        
    }
    
    return self;
}


@end