//
//  MenuLayer.h
//  MobilePong2
//
//  Created by Rashad on 2/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"
#import "OptionsScene.h"
#import "MultiplayerScene.h"
#import "GameScene.h"
#import "tutorialScene.h"
#import <CoreFoundation/CoreFoundation.h> 

@interface MenuLayer : CCLayer {
    CCMenu *mainMenu;
    int playerNum;
}

-(void) displayMenu;
@end
