//
//  Ball.m
//  PongT2
//
//  Created by Shawney Moore on 2/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Ball.h"
//#import "Math.h"

@implementation Ball

@synthesize didCollide;
@synthesize ballSprite;
@synthesize velocity;
@synthesize prevPosition;

+(id)ballWithParentNode:(CCNode *)parentNode
{
    return[[self alloc] initWithParentNode:parentNode];
}

-(id) initWithParentNode:(CCNode *)parentNode
{
    if((self = [super init]))
    {
        didCollideWithWall = FALSE;
        score = FALSE;
        [parentNode addChild:self];
        screenSize = [CCDirector sharedDirector].winSize;
        
        ballSprite = [CCSprite spriteWithFile:@"ball.png"];
        
        // create initial serving position, needs to be refactored
        position = CGPointMake(CCRANDOM_0_1() * screenSize.width, CCRANDOM_0_1() * screenSize.height);
        [self addChild:ballSprite];
        
        [self scheduleUpdate];
            
        //srandom(time(NULL));
        
        /* generate inital random angles */
        velocity = [self calcVelocity:MIN_BALL_SPEED withAngle:CC_DEGREES_TO_RADIANS([self getRandomAngle])];
    }

    
    return self;
}
-(CGFloat)getRandomAngle
{
    CGFloat randangle;
    if(position.y < screenSize.height/2)
        randangle = arc4random() % (150-31) + 30;
    else
        randangle = arc4random() % (330-211) + 210;
    
    return randangle;
}
-(void) update:(ccTime)delta
{
    ballSprite.position = position;
    
    if(!multiplayer && !score && countdown <1 )
        [self moveBall];
    
    if(position.y < -16)
    {
        
        score = TRUE;
    }
    
    //player scores and serves ball
    else if(position.y >500)
    {
        score = TRUE;
        //[self changeMadBall];
    }
    else{
        score = FALSE;
        //[self changeMadBall];
    }
    
}



-(CGPoint) getVelocity
{
    return velocity;
}

-(void) setPosition: (CGPoint) p
{
    position = p;
}

-(CGPoint) getPosition
{
    return  position;
}


-(void) moveBall
{
    
    position.x += velocity.x;
    position.y += velocity.y;
    
    
    //Handles bouncing on walls
    if((position.x < 10 || position.x > (screenSize.width - 10))&&!didCollideWithWall){
        didCollideWithWall = TRUE;
        [[SimpleAudioEngine sharedEngine] playEffect:@"bounce.wav"];
        velocity.x = -velocity.x;
    }
    if(position.x > 9 && position.x < (screenSize.width - 9))
        didCollideWithWall = FALSE;
    //AI scores and serves ball
    if(position.y < -16)
    {
        didCollideWithWall = FALSE;
        score = TRUE;
        [self AIserveBall];
    }
    
    //player scores and serves ball
    if(position.y >500)
    {
        score = TRUE;
        [self player1serveBall];
    }
    
    if(position.y > 230 && position.y < 350)
        self.didCollide = FALSE;

    
}

//Freezes ball on players side of the screen for 5 seconds
-(void) player1serveBall
{
    countdown = 3;
    tempVelocity = velocity;
    
    screenSize = [CCDirector sharedDirector].winSize;
    position = CGPointMake((arc4random()%300) + 1, (screenSize.height/4));
    velocity.x = 0;
    velocity.y = 0;
    
    [self performSelector:@selector(resumeMove) withObject:nil afterDelay:2.0];


}


//Freezes ball on AI side of the screen for 5 seconds
-(void) AIserveBall
{
    countdown = 2;
    
    //tempVelocity = velocity;
    
    screenSize = [CCDirector sharedDirector].winSize;
    position = CGPointMake((arc4random()%300) + 1, (screenSize.height - (screenSize.height/4)));
    velocity.x = 0;
    velocity.y = 0;
    [self performSelector:@selector(resumeMove) withObject:nil afterDelay:1.0];

}


//Ball resumes movement
-(void) resumeMove
{
    score = FALSE;
    CGPoint initialvel = [self calcVelocity:MIN_BALL_SPEED withAngle: CC_DEGREES_TO_RADIANS([self getRandomAngle])];
    velocity.x = initialvel.x;
    velocity.y = initialvel.y;
    tempVelocity = CGPointMake(0, 0);
    didCollide = FALSE;
    didCollideWithWall = FALSE;
}


-(float) getXpos
{
    return position.x;
}

-(float) getYpos
{
    return position.y;
}
//subtracts half of ball to get tip of ball as it approaches user
-(CGFloat) tipOfBall{
    return(position.y - (ballSprite.contentSize.height /* ballSprite.scaleY*/)/2);
}

-(float) getDiameter
{
    // use scaleX to account for retina display
    return (ballSprite.contentSize.width * ballSprite.scaleX);
}

//adds half of ball to get tip of ball as it approaches user
-(CGFloat) opponentTipOfBall{
    return(position.y + (ballSprite.contentSize.height /* ballSprite.scaleY*/)/2);
}

-(float) getTopTipY
{
    float diameter = [self getDiameter];
    return (ballSprite.position.y + (diameter/2.0));
}

//adds half of ball to get right of ball to get right tip
-(CGFloat) rightOfBall{
    return(position.x + (ballSprite.contentSize.width /* ballSprite.scaleY*/)/2);
}

-(float) getBottomTipY
{
    float diameter = [self getDiameter];
    return (ballSprite.position.y - (diameter/2.0));
}

//subtracts half of ball to get left of ball to get right tip
-(CGFloat) leftOfBall{
    return(position.x - (ballSprite.contentSize.height /* ballSprite.scaleY*/)/2);
}

-(float) getLeftTipX
{
    float diameter = [self getDiameter];
    return (ballSprite.position.x - (diameter/2.0));
}

//gets x position of the ball when looking at the top or bottom
-(CGFloat) tipOfBallX{
    return  position.x;
}

-(float) getRightTipX
{
    float diameter = [self getDiameter];
    return (ballSprite.position.x + (diameter/2.0));
}

-(CGPoint) calcVelocity: (CGFloat) speed withAngle: (CGFloat) angle
{
    return CGPointMake(speed*cosf(angle), speed*sinf(angle));
}

-(CGFloat) getSpeed
{
    return [self getSpeed:velocity];
}

-(CGFloat) getAngle
{
    return [self getAngle:velocity];
}

-(CGFloat) getSpeed: (CGPoint) velocityVector
{
    return sqrtf(powf(velocityVector.x,2) + powf(velocityVector.y,2));
}

-(CGFloat) getAngle: (CGPoint) velocityVector
{
    CGFloat vectAngle = atan2f(-velocityVector.y,-velocityVector.x);
    vectAngle = CC_DEGREES_TO_RADIANS(vectAngle/M_PI*180 + 180);
    return vectAngle;
}

-(CGPoint) reflectStraight: (CGPoint) normVect
{
    //  CGPoint curVector = CGPointMake(position.x - prevPosition.x, position.y - prevPosition.y);
    CGFloat dotproduct = ccpDot(velocity,normVect);
    CGFloat reflectionVectX = velocity.x - 2*normVect.x*dotproduct;
    CGFloat reflectionVectY = velocity.y - 2*normVect.y*dotproduct;
    CGPoint newVelocity = CGPointMake(reflectionVectX, reflectionVectY);
    return newVelocity;
}
-(CGPoint) reflect: (CGPoint) normVect withBlunt: (CGFloat) bluntVal andSpeedAdjust: (CGFloat) speedAdjVal
{
    //CGPoint reflectionVect = [self reflectStraight:normVect];
    //CGFloat newAngle = [self getAngle:reflectionVect] + bluntVal;
    NSLog(@"INITIAL ANGLE: %f", (([self getAngle]*180)/M_PI));
    
    CGFloat newAngle = ((2*M_PI)- [self getAngle])+ bluntVal;
    NSLog(@"Adjusted Angle *BEFORE IF'S: %f", ((newAngle*180)/M_PI));
    
    if(newAngle < 0) {
        newAngle = newAngle + 2*M_PI;
    }
    if(newAngle > 2*M_PI){
        newAngle = newAngle - 2*M_PI;
    }
    /*if (newAngle < M_PI && newAngle > (5*M_PI/6)) {
        newAngle = 5*M_PI/6;
    }
    if(newAngle >= M_PI && newAngle < (7*M_PI/6)) {
        newAngle = 7*M_PI/6;
    }
    if(newAngle > (11*M_PI/6) && newAngle <= (2*M_PI)) {
        newAngle = 11*M_PI/6;
    }
    if(newAngle >= 0 && newAngle < M_PI/6) {
        newAngle = M_PI/6;
    }
    NSLog(@"Adjusted Angle: %f", ((newAngle*180)/M_PI));
    */
    CGFloat newSpeed = [self getSpeed] + speedAdjVal;
    
    if (newSpeed > MAX_BALL_SPEED) {
        newSpeed = MAX_BALL_SPEED;
    }
    else if(newSpeed < MIN_BALL_SPEED) {
        newSpeed = MIN_BALL_SPEED;
    }
    
    
    
    if(position.y < screenSize.width/2)
    {
        if(newAngle > 5*M_PI/6 && newAngle < 3*M_PI/2)
            newAngle = 5*M_PI/6;
        if(newAngle >= 3*M_PI/2 || newAngle < M_PI/6)
            newAngle = M_PI/6;
    }
    
    if(position.y > screenSize.width/2)
    {
        if(newAngle > M_PI/2 && newAngle < 7*M_PI/6)
            newAngle = 7*M_PI/6;
        if(newAngle > 11*M_PI/6 || newAngle <= M_PI/2)
            newAngle = 11*M_PI/6;
    }
        
    CGPoint newVelocity = [self calcVelocity:newSpeed withAngle:newAngle];
        
    return newVelocity;
}

-(void) changeMadBall
{
 ballSprite = [CCSprite spriteWithFile:@"mad_ball.png"];
}

-(void) changeYellowBall
{
    ballSprite = [CCSprite spriteWithFile:@"yellow_ball.png"];
}

-(void) changeGreenBall
{
    ballSprite = [CCSprite spriteWithFile:@"green_ball.png"];
}


@end
