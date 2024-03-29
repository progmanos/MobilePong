//
//  OptionsLayer.m
//  MobilePong2
//
//  Created by Rashad on 2/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "OptionsLayer.h"


@implementation OptionsLayer

-(void) switchLevels
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    GameLevel level = [prefs integerForKey:@"level"];

    //if you click on the label, increment the level and save it to the game preferences
    if (level == 0) {
        level = Level_One;
    }

    switch (level) {
       case Level_One:
            [prefs setInteger:Level_Two forKey:@"level"];
            break;
       case Level_Two:
            [prefs setInteger:Level_Three forKey:@"level"];
            break;
       case Level_Three:
            [prefs setInteger:Level_One forKey:@"level"];
            break;
       default:
            break;
     }
    NSLog(@"New level is now: %i", [prefs integerForKey:@"level"]);
    [prefs synchronize];
}

-(void) returnToMainMenu
{
  // pop the options scene from the CCDirector and return to the menu scene
    [[CCDirector sharedDirector] popScene];
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
        
        CCLabelTTF *levelChoicesLabel = [CCLabelTTF labelWithString:@"Select Difficulty:" fontName:@"Arial" fontSize:24];
        CCMenuItemFont *levelChoicesItemLabel = [CCMenuItemFont itemWithLabel:levelChoicesLabel target:nil selector:nil];
        levelChoicesLabel.color = ccWHITE;
        
        
        CCLabelTTF *levelOneLabel = [CCLabelTTF labelWithString:@"Beginner" fontName:@"Arial" fontSize:24];
        CCMenuItemFont *levelOne = [CCMenuItemFont itemWithLabel:levelOneLabel target:self selector:nil];
        levelOneLabel.color = ccRED;
        
        CCLabelTTF *levelTwoLabel = [CCLabelTTF labelWithString:@"Intermediate" fontName:@"Arial" fontSize:24];
        CCMenuItemFont *levelTwo = [CCMenuItemFont itemWithLabel:levelTwoLabel target:self selector:nil];
        levelTwoLabel.color = ccRED;
        
        CCLabelTTF *levelThreeLabel = [CCLabelTTF labelWithString:@"Advanced" fontName:@"Arial" fontSize:24];
        CCMenuItemFont *levelThree = [CCMenuItemFont itemWithLabel:levelThreeLabel target:self selector:nil];
        levelThreeLabel.color = ccRED;
        
        CCLabelTTF *backLabel = [CCLabelTTF labelWithString:@"Back to Main Menu" fontName:@"Arial" fontSize:24];
        CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:backLabel target:self selector:@selector(returnToMainMenu)];
        backItem.color = ccBLACK;
        
        
        //set number of match
        CCLabelTTF *scoreChoicesLabel = [CCLabelTTF labelWithString:@"Select points to win match:" fontName:@"Arial" fontSize:24];
        CCMenuItemFont *scoreChoicesItemLabel = [CCMenuItemFont itemWithLabel:scoreChoicesLabel target:nil selector:nil];
        scoreChoicesLabel.color = ccWHITE;
        
        playTo5label = [CCLabelTTF labelWithString:@"    5" fontName:@"Arial" fontSize:24];
        playTo5 = [CCMenuItemFont itemWithLabel:playTo5label target:self selector:nil];
        playTo5label.color = ccYELLOW ;
        
        playTo11label = [CCLabelTTF labelWithString:@"    11" fontName:@"Arial" fontSize:24];
        playTo11 = [CCMenuItemFont itemWithLabel:playTo11label target:self selector:nil];
        playTo11label.color = ccYELLOW ;
        
        playTo15label = [CCLabelTTF labelWithString:@"    15" fontName:@"Arial" fontSize:24];
        playTo15 = [CCMenuItemFont itemWithLabel:playTo15label target:self selector:nil];
        playTo15label.color = ccYELLOW ;
        
        
        CCMenuItemToggle *LevelToggle = [CCMenuItemToggle itemWithTarget:self
                                                                selector:@selector(switchLevels)
                                                                   items:levelOne,levelTwo,levelThree,nil];
        
        scoreToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(switchScore)
                                                                   items:playTo5, playTo11, playTo15, nil];
        
        
        optionsMenu = [CCMenu menuWithItems:levelChoicesItemLabel, LevelToggle, scoreChoicesItemLabel, scoreToggle, backItem, nil];
        [optionsMenu alignItemsVerticallyWithPadding:20.0f];
        [optionsMenu setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:optionsMenu];
        
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        GameLevel level = [prefs integerForKey:@"level"];
        switch (level) {
            case Level_One:
                [LevelToggle setSelectedIndex:0];
                break;
            case Level_Two:
                [LevelToggle setSelectedIndex:1];
                break;
            case Level_Three:
                [LevelToggle setSelectedIndex:2];
                break;
            default:
                break;
        }

       
    }
    return self;
}
-(void)switchScore
{
    if(scoreToggle.selectedItem == playTo5)        
        pointsToWin = 5;
    if(scoreToggle.selectedItem == playTo11)
        pointsToWin = 11;
    if(scoreToggle.selectedItem == playTo15)
        pointsToWin = 15;

        
}

@end
