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
    CCMenu *optionsMenu;
}

-(void) returnToMainMenu;

@end
