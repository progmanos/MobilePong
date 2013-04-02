//
//  MultiplayerOptionLayer.h
//  PongT2
//
//  Created by Elizabeth Mitchell on 4/1/13.
//
//

#import "CCLayer.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"
#import "tutorialScene.h"
#import "GameLayer.h"
#import "OptionsScene.h"
#import <CoreFoundation/CoreFoundation.h>
@interface MultiplayerOptionLayer : CCLayer
{
    int selections;
    int lastSelction;
    CCMenu *multiplayerOptionMenu;
    CCLabelTTF *levelChoiceOnelabel;
    CCLabelTTF *levelChoiceTwolabel;
    CCLabelTTF *levelChoiceThreelabel;
}

@end
