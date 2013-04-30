//
//  OptionsLayer.h
//  MobilePong2
//
//  Created by Rashad on 2/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

@interface OptionsLayer : CCLayer {
    int selections;
    int lastSelction;
    CCMenu *optionsMenu;
    CCLabelTTF *playTo5label;
    CCLabelTTF *playTo11label;
    CCLabelTTF *playTo15label;
    CCMenuItemToggle *scoreToggle;
    CCMenuItemFont *playTo5;
    CCMenuItemFont *playTo11;
    CCMenuItemFont *playTo15;
    
}

-(void) returnToMainMenu;

@end
