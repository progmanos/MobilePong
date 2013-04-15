//
//  PauseLayer.h
//  PongT2
//
//  Created by Elizabeth Mitchell on 3/31/13.
//
//

#import "CCLayer.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"
#import "tutorialScene.h"
#import "OptionsScene.h"
#import <CoreFoundation/CoreFoundation.h>
@interface PauseLayer : CCLayer{
CCMenu *pauseMenu;
}
-(void) displayMenu;
-(void) returnToGame;
-(void) returnToMainMenu;

@end
