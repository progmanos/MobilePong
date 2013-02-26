//
//  OptionsScene.m
//  MobilePong2
//
//  Created by Rashad on 2/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "OptionsScene.h"


@implementation OptionsScene

-(id)init {
    self = [super init];
    if (self != nil) {
        optionsLayer = [OptionsLayer node];
        [self addChild:optionsLayer];
    }
    return self;
}
@end
