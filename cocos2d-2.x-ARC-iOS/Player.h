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
-(CGFloat) first;
-(CGFloat) second;
-(CGFloat) third;
-(CGFloat) fourth;
-(CGFloat) fifth;
-(CGFloat) sixth;
-(CGFloat) tipOfPaddle;
-(CGFloat) rightOfPaddle;
-(CGFloat) leftOfPaddle;
-(CGFloat) OpponentTipOfPaddle;
-(BOOL) inSegmentA: (CGFloat) ballposCtr leftPos: (CGFloat) ballposL rightPos: (CGFloat) ballposR;
-(BOOL) inSegmentE: (CGFloat) ballposCtr leftPos: (CGFloat) ballposL rightPos: (CGFloat) ballposR;
-(BOOL) inSegmentB: (CGFloat) ballposCtr leftPos: (CGFloat) ballposL rightPos: (CGFloat) ballposR;
-(BOOL) inSegmentD: (CGFloat) ballposCtr leftPos: (CGFloat) ballposL rightPos: (CGFloat) ballposR;



@end
