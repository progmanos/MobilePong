//
//  GameLayer.h
//  Pong
//
//  Created by Rashad on 2/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Ball.h"
#import "Paddle.h"

@interface GameLayer : CCLayer {
    Ball *pongball;
    Paddle *paddle;
}
+(id) scene;
@end
