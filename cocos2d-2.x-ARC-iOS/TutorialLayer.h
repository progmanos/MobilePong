//
//  TutorialLayer.h
//  PongT2
//
//  Created by Elizabeth Mitchell on 3/30/13.
//
//
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCLayer.h"
#import "Constants.h"

@interface TutorialLayer : CCLayer{
    CCMenu *tutorialMenu;
    int touchHappened ;
}

@end
