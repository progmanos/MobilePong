//
//  Player.h
//  PongT2
//
//  Created by Shawney Moore on 2/16/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"

typedef enum  {
        SegmentA = 0,
        SegmentB,
        SegmentC
    } CollionSegment;

@interface Player : CCNode
{
    int roundScore;
    int score;
    int speed;
    CGPoint position;
    CGSize screenSize;
    CollionSegment collisionSeg;
}

@property (nonatomic,assign) CCSprite* paddleSprite;
@property (nonatomic, assign) TypeofPlayer playerType;

/* Used for adjusting AI paddle width in different levels */
@property (nonatomic, readonly) CGFloat initialPaddleWidth;

-(void) setSprite: (CCSprite*) paddleSprite;
-(void) setSpeed: (int) newSpeed;
-(void) moveRight;
-(void) moveLeft;
-(void) setPosition:(CGPoint)position;
-(void) setXPosition:(CGFloat)xposition;
-(float) getXpos;
+(id)playerWithParentNode:(CCNode*)parentNode;
-(id)initWithParentNode:(CCNode*)parentNode;
-(int) getScore;
-(void) updateScore;
-(void) resetScore;
-(void) setScore:(int)s;
-(void) updateRoundScore;
-(void) resetRoundScore;
-(int) getRoundScore;
-(CGFloat) getPaddleWidth;
-(float) getTopCenterY;
-(float) getLeftCenterY;
-(float) getRightCenterY;
-(float) getLeftCornerX;
-(float) getRightCornerX;
-(void) resizePaddleWidth:(float)width;


-(CGFloat) tipOfPaddle;
-(CGFloat) rightHalfOfPaddle;
-(CGFloat) leftHalfOfPaddle;

-(BOOL) inSegmentA: (CGFloat) ballposCtr leftPos: (CGFloat) ballposL rightPos: (CGFloat) ballposR;
-(BOOL) inSegmentB: (CGFloat) ballposCtr leftPos: (CGFloat) ballposL rightPos: (CGFloat) ballposR;
-(int) GetCollisionSegment: (CGFloat) ballCtrTip leftPos: (CGFloat) ballposLeft rightPos: (CGFloat) ballRightPos;
@end
