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
        CCLabelTTF *levelOneLabel = [CCLabelTTF labelWithString:@"Beginner" fontName:@"Arial" fontSize:24];
        CCMenuItemFont *levelOne = [CCMenuItemFont itemWithLabel:levelOneLabel target:self selector:nil];
        
        CCLabelTTF *levelTwoLabel = [CCLabelTTF labelWithString:@"Intermediate" fontName:@"Arial" fontSize:24];
        CCMenuItemFont *levelTwo = [CCMenuItemFont itemWithLabel:levelTwoLabel target:self selector:nil];
        
        CCLabelTTF *levelThreeLabel = [CCLabelTTF labelWithString:@"Advanced" fontName:@"Arial" fontSize:24];
        CCMenuItemFont *levelThree = [CCMenuItemFont itemWithLabel:levelThreeLabel target:self selector:nil];
        CCLabelTTF *backLabel = [CCLabelTTF labelWithString:@"Back to Main Menu" fontName:@"Arial" fontSize:24];
        CCMenuItemLabel *backItem = [CCMenuItemLabel itemWithLabel:backLabel target:self selector:@selector(returnToMainMenu)];
        
        
        //set number of match
        CCLabelTTF *levelChoicesLabel = [CCLabelTTF labelWithString:@"Select points to win match:" fontName:@"Arial" fontSize:24];
        CCMenuItemFont *levelChoicesItemLabel = [CCMenuItemFont itemWithLabel:levelChoicesLabel target:self selector:@selector(setMatchNum)];
        levelChoicesLabel.color = ccRED;
        
        levelChoiceOnelabel = [CCLabelTTF labelWithString:@"    5" fontName:@"Arial" fontSize:16];
        CCMenuItemFont *levelChoiceOneItemLabel = [CCMenuItemFont itemWithLabel:levelChoiceOnelabel target:self selector:@selector(setMatchNum1)];
        levelChoiceOnelabel.color = ccYELLOW ;
        
        levelChoiceTwolabel = [CCLabelTTF labelWithString:@"    11" fontName:@"Arial" fontSize:16];
        CCMenuItemFont *levelChoiceTwoItemLabel = [CCMenuItemFont itemWithLabel:levelChoiceTwolabel target:self selector:@selector(setMatchNum2)];
        levelChoiceTwolabel.color = ccYELLOW ;
        
        levelChoiceThreelabel = [CCLabelTTF labelWithString:@"  15" fontName:@"Arial" fontSize:16];
        CCMenuItemFont *levelChoiceThreeItemLabel = [CCMenuItemFont itemWithLabel:levelChoiceThreelabel target:self selector:@selector(setMatchNum3)];
        levelChoiceThreelabel.color = ccYELLOW ;

        CCMenuItemToggle *LevelToggle = [CCMenuItemToggle itemWithTarget:self
                                                                selector:@selector(switchLevels)
                                                                   items:levelOne,levelTwo,levelThree,nil];
        optionsMenu = [CCMenu menuWithItems:LevelToggle, backItem,levelChoicesItemLabel,levelChoiceOneItemLabel, levelChoiceTwoItemLabel, levelChoiceThreeItemLabel, nil];
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

-(void) setMatchNum1{
    if(selections==0){
        selections++;
        levelChoiceOnelabel.color = ccGREEN ;
        lastSelction=1;
        pointsToWin =5;
    }
    else{
        if(lastSelction==2){
            levelChoiceTwolabel.color = ccYELLOW ;
            levelChoiceOnelabel.color = ccGREEN ;
            pointsToWin =5;
            lastSelction=1;
        }
        else if(lastSelction==3){
            levelChoiceThreelabel.color = ccYELLOW ;
            levelChoiceOnelabel.color = ccGREEN ;
            pointsToWin =5;
            lastSelction=1;
        }
    }
}


-(void) setMatchNum2{
    if(selections==0){
        selections++;
        levelChoiceTwolabel.color = ccGREEN ;
        lastSelction=2;
        pointsToWin =11;
    }
    else{
        if(lastSelction==3){
            levelChoiceThreelabel.color = ccYELLOW ;
            levelChoiceTwolabel.color = ccGREEN ;
            pointsToWin =11;
            lastSelction=2;
        }
        else if(lastSelction==1){
            levelChoiceOnelabel.color = ccYELLOW ;
            levelChoiceTwolabel.color = ccGREEN ;
            pointsToWin =11;
            lastSelction=2;
        }
    }
}


-(void) setMatchNum3{
    if(selections==0){
        selections++;
        levelChoiceThreelabel.color = ccGREEN ;
        lastSelction=3;
        pointsToWin =15;
    }
    else{
        if(lastSelction==1){
            levelChoiceOnelabel.color = ccYELLOW ;
            levelChoiceThreelabel.color = ccGREEN ;
            pointsToWin =15;
            lastSelction=3;
        }
        else if(lastSelction==2){
            levelChoiceTwolabel.color = ccYELLOW ;
            levelChoiceThreelabel.color = ccGREEN ;
            pointsToWin =15;
            lastSelction=3;
        }
    }
}

@end
