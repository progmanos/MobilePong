//
//  Player.h
//  PongT2
//
//  Created by Shawney Moore on 2/16/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCNode
{
    int score;
    int velocity;
    CGPoint position;
    CGSize screenSize;
}

@property (nonatomic,assign) CCSprite* paddleSprite;
@property (nonatomic, readonly) CGFloat initialPaddleWidth;

-(void) setSprite: (CCSprite*) paddleSprite;
-(void) setVelocity: (int) velocity;
-(void) moveRight;
-(void) moveLeft;
-(void) setPosition:(CGPoint)position;
-(float) getXpos;
+(id)playerWithParentNode:(CCNode*)parentNode;
-(id)initWithParentNode:(CCNode*)parentNode;
-(int) getScore;
-(void) updateScore;
-(void) resetScore;
-(CGFloat) getPaddleWidth;
-(float) getTopCenterY;
-(float) getLeftCenterY;
-(float) getRightCenterY;
-(float) getLeftCornerX;
-(float) getRightCornerX;
-(void) resizePaddleWidth:(float)width;

@end
