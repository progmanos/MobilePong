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


@interface MenuLayer : CCLayer {
    CCMenu *mainMenu;
}

-(void) displayMenu;
@end
