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
        CCLabelTTF *levelOneLabel = [CCLabelTTF labelWithString:@"Beginner" fontName:@"Arial" fontSize:32];
        CCMenuItemFont *levelOne = [CCMenuItemFont itemWithLabel:levelOneLabel target:self selector:nil];
        
        CCLabelTTF *levelTwoLabel = [CCLabelTTF labelWithString:@"Intermediate" fontName:@"Arial" fontSize:32];
        CCMenuItemFont *levelTwo = [CCMenuItemFont itemWithLabel:levelTwoLabel target:self selector:nil];
        
        CCLabelTTF *levelThreeLabel = [CCLabelTTF labelWithString:@"Advanced" fontName:@"Arial" fontSize:32];
        CCMenuItemFont *levelThree = [CCMenuItemFont itemWithLabel:levelThreeLabel target:self selector:nil];
        CCLabelTTF *backLabel = [CCLabelTTF labelWithString:@"Back to Main Menu" fontName:@"Arial" fontSize:32];
        CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:backLabel target:self selector:@selector(returnToMainMenu)];
        CCMenuItemToggle *LevelToggle = [CCMenuItemToggle itemWithTarget:self
                                                                selector:@selector(switchLevels)
                                                                   items:levelOne,levelTwo,levelThree,nil];
        optionsMenu = [CCMenu menuWithItems:LevelToggle, backItem, nil];
        [optionsMenu alignItemsVerticallyWithPadding:60.0f];
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

@end
