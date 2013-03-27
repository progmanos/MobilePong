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
-(void)showMultiplayer
{
    multiplayer = TRUE;
    [Nextpeer launchDashboard];
    
}
-(void) displayMenu
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCLabelTTF *playlabel = [CCLabelTTF labelWithString:@"Play Pong" fontName:@"Arial" fontSize:32];
    CCMenuItemFont *playGameItemLabel = [CCMenuItemFont itemWithLabel:playlabel target:self selector:@selector(playGame)];
    
    CCLabelTTF *optionsLabel = [CCLabelTTF labelWithString:@"Options" fontName:@"Arial" fontSize:32];
    optionsLabel.color = ccRED;
    
    CCMenuItemFont *optionsItemLabel = [CCMenuItemFont itemWithLabel:optionsLabel target:self selector:@selector(showOptions)];
    
    
    CCLabelTTF *multiplayerLabel = [CCLabelTTF labelWithString:@"Multiplayer" fontName:@"Arial" fontSize:32];
    optionsLabel.color = ccRED;
    
    CCMenuItemFont *multiplayerItemLabel = [CCMenuItemFont itemWithLabel:multiplayerLabel target:self selector:@selector(showMultiplayer)];
    
    
    mainMenu = [CCMenu
                menuWithItems:playGameItemLabel,optionsItemLabel, multiplayerItemLabel, nil];
    
    [mainMenu alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
    [mainMenu setPosition:
     ccp(screenSize.width / 2.0f,
         screenSize.height / 2.0f)];
    
    [self addChild:mainMenu z:1];
}


-(id) init
{
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *background =
        [CCSprite spriteWithFile:@"court.png"];
        [background setPosition:ccp(screenSize.width/2,
                                    screenSize.height/2)];
        [self addChild:background];
        [self displayMenu];
        
    }
    
    return self;
}


@end