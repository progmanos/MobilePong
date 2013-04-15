//
//  MultiplayerOptionLayer.m
//  PongT2
//
//  Created by Elizabeth Mitchell on 4/1/13.
//
//

#import "MultiplayerOptionLayer.h"

@implementation MultiplayerOptionLayer


-(void) displayMenu
{
    selections = 0;
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CCLabelTTF *levelChoicesLabel = [CCLabelTTF labelWithString:@"Select points to win match:" fontName:@"Arial" fontSize:32];
    CCMenuItemFont *levelChoicesItemLabel = [CCMenuItemFont itemWithLabel:levelChoicesLabel target:self selector:@selector(setMatchNum)];
    levelChoicesLabel.color = ccRED;
    
    levelChoiceOnelabel = [CCLabelTTF labelWithString:@"    5" fontName:@"Arial" fontSize:24];
    CCMenuItemFont *levelChoiceOneItemLabel = [CCMenuItemFont itemWithLabel:levelChoiceOnelabel target:self selector:@selector(setMatchNum1)];
        levelChoiceOnelabel.color = ccYELLOW ;
    
    levelChoiceTwolabel = [CCLabelTTF labelWithString:@"    11" fontName:@"Arial" fontSize:24];
    CCMenuItemFont *levelChoiceTwoItemLabel = [CCMenuItemFont itemWithLabel:levelChoiceTwolabel target:self selector:@selector(setMatchNum2)];
        levelChoiceTwolabel.color = ccYELLOW ;
    
    levelChoiceThreelabel = [CCLabelTTF labelWithString:@"  15" fontName:@"Arial" fontSize:24];
    CCMenuItemFont *levelChoiceThreeItemLabel = [CCMenuItemFont itemWithLabel:levelChoiceThreelabel target:self selector:@selector(setMatchNum3)];
        levelChoiceThreelabel.color = ccYELLOW ;
    
    CCLabelTTF *mainMenuLabel = [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Arial" fontSize:32];
    mainMenuLabel.color = ccRED;
    
    CCMenuItemFont *mainMenuGameItemLabel = [CCMenuItemFont itemWithLabel:mainMenuLabel target:self selector:@selector(returnToMainMenu)];
    
    
    
    
    multiplayerOptionMenu = [CCMenu
                 menuWithItems:levelChoicesItemLabel,levelChoiceOneItemLabel, levelChoiceTwoItemLabel, levelChoiceThreeItemLabel,  mainMenuGameItemLabel, nil];
    
    [multiplayerOptionMenu alignItemsVerticallyWithPadding:screenSize.height * 0.059f];
    [multiplayerOptionMenu setPosition:
     ccp(screenSize.width / 2.0f,
         screenSize.height / 2.0f)];
    
    [self addChild:multiplayerOptionMenu z:1];
}
-(id)init {
    self = [super init];
    if (self != nil) {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCSprite *background =
        [CCSprite spriteWithFile:@"background.png"];
        [background setPosition:ccp(screenSize.width/2,
                                    screenSize.height/2)];
        [self addChild:background];
        [self displayMenu];
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
