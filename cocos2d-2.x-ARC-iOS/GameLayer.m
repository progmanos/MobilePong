//
//  GameLayer.m
//  PongT2
//
//  Created by Shawney Moore on 2/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#import <GameKit/GameKit.h>
#import "GameKitHelper.h"
#import "PauseScene.h"


//static NSString * const UIGestureRecognizerNodeKey = @"UIGestureRecognizerNodeKey";

@implementation GameLayer

-(id) init
{
    if ((self = [super init]))
    {
       
        countdown = 5;
        times =0;
        multiplayer = FALSE;
        prefs = [NSUserDefaults standardUserDefaults];
        
        playerScored = FALSE;
        [player resetScore];
        [opponent resetScore];
       
        
        currhighscore = [prefs integerForKey:@"highScore"];
        if(currhighscore == nil)
            currhighscore = 0;
        
        highscore = [NSString stringWithFormat:@"highScore: %d ", (int)currhighscore];
        
        
        // get level, set default level if the level key does not exist
        NSInteger level = [self GetLevel];
        
        if (level == 0) {
            NSInteger defaultLevel = Level_One;
            level = defaultLevel;
            [self SetLevel:defaultLevel];
        }
        
        
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        self.isTouchEnabled = YES;
        
        // move this to a header file for use in other classes
        screenSize = [CCDirector sharedDirector].winSize;
        
        //sets background to court image
        CCSprite *background = [CCSprite spriteWithFile:@"background3.png"];
        [self addChild:background z:0 tag:1];
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
   
        // swipe gesture detection for pausing game
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
        [self addGestureRecognizer:swipeGestureRecognizer];
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
        
        
        //sets label for score of opponent
        opponentScoreLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:48];
        opponentScoreLabel.position = ccp((screenSize.width/2), (screenSize.height - (screenSize.height/6)));
        opponentScoreLabel.color = ccBLACK;
        [self addChild:opponentScoreLabel z:0];
        
        //sets label for score of opponent
        playerScoreLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:48];
        playerScoreLabel.position = ccp((screenSize.width/2), (screenSize.height/6));
        playerScoreLabel.color = ccBLACK;
        [self addChild:playerScoreLabel z:0];
        
        
        //sets label for score of opponent's round
        opponentRoundLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:12];
        opponentRoundLabel.position = ccp((screenSize.width)/2, ((screenSize.height)-45));
        opponentRoundLabel.color = ccBLACK;
        [self addChild:opponentRoundLabel z:0];
        
        //sets label for score of player's round
        playerRoundLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:12];
        playerRoundLabel.position = ccp((screenSize.width)/2, 45);
        playerRoundLabel.color = ccBLACK;
        [self addChild:playerRoundLabel z:0];
        
        //sets label for time of gameplay
        timeLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:24];
        timeLabel.color = ccRED;
        timeLabel.position = ccp(30, 30);
        [self addChild:timeLabel z:0];
        
        //sets label for winner of the game
        winnerLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:28];
        winnerLabel.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:winnerLabel z:2];
        
        //sets label for highscore
        highScoreLabel = [CCLabelTTF labelWithString:@"8" fontName:@"Marker Felt" fontSize:12];
        highScoreLabel.position = ccp(35, 5);
        [self addChild:highScoreLabel z:0];
        [highScoreLabel setString:(highscore)];
        
        
        //sets label for countdown
        countdownLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:30];
        countdownLabel.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:countdownLabel z:0];
        [countdownLabel setString:([NSString stringWithFormat:@"%d", countdown])];
        countdownLabel.color = ccRED;
        
        //creates ball, player, and opponent player
        ball = [Ball ballWithParentNode:self];
        player = [Player playerWithParentNode:self];
        player.playerType = User;
        opponent = [Player playerWithParentNode:self];
        opponent.playerType = Opponent;
        
        //sets initial position of player & opponent
        [player setPosition:CGPointMake(screenSize.width / 2, 20.0)];
        [opponent setPosition:CGPointMake(screenSize.width/2, (screenSize.height - 20))];
        
        //Set opponent round score
        [opponentRoundLabel setString:[NSString stringWithFormat:@"Rounds Won: " @"%d", [opponent getRoundScore]]];
        
        //Set player round score
        [playerRoundLabel setString:[NSString stringWithFormat:@"Rounds Won: " @"%d", [opponent getRoundScore]]];
        
        
        //initialize player and opponent velocity
        [player setSpeed:(6)];
        
        //rudimentary AI
        //shrink the paddle by 20 pixels for level 1 and 10 for level two
        // use normal size for level three
        // increase the velocity per level
        switch (level) {
            case Level_One:
                [opponent setSpeed:(3)];
                [opponent resizePaddleWidth:([opponent initialPaddleWidth] - 20)];
                break;
            case Level_Two:
                [opponent setSpeed:(4)];
                [opponent resizePaddleWidth:([opponent initialPaddleWidth] - 10)];
                break;
            case Level_Three:
                [opponent setSpeed:(5)];
                break;
            default:
                break;
        }
        
        oneThirdOfPlayerPaddle = [player paddleSprite].contentSize.width/3;
        oneThirdOfOpponentPaddle = [opponent paddleSprite].contentSize.width/3;
       
        
        [self scheduleUpdate];
        
        
    }
	
    return self;
}

- (void)pauseButtonTapped: (id)sender {
    [[CCDirector sharedDirector] pushScene:[PauseScene node]];
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

-(void) movePlayerLeft
{
    [player moveLeft];
}

-(void) movePlayerRight
{
    [player moveRight];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  //  if ([touches count] == 3) {
    //    [[CCDirector sharedDirector] pushScene:[PauseScene node]];
      //  return;
    //}
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
    CGFloat currPaddleWidth = player.getPaddleWidth;
    if(point.x< (player.paddleSprite.position.x - (currPaddleWidth/2)))
    {
        [self schedule:@selector(movePlayerLeft)];
    }
    if(point.x < (player.paddleSprite.position.x - (currPaddleWidth/2))) {
        [self schedule:@selector(movePlayerLeft)];
    }
    else {
        [self schedule:@selector(movePlayerRight)];
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self unschedule:@selector(movePlayerLeft)];
    [self unschedule:@selector(movePlayerRight)];
}


-(void) handleSwipeGesture:(UISwipeGestureRecognizer *) swipeGestureRecognizer
{
        [[CCDirector sharedDirector] pushScene:[PauseScene node]];
}

-(void) update:(ccTime)delta
{
  
    //time in seconds
    totalTime += delta;
    countdown -= delta;
    
    
    if((int)countdown > 0)
        menu.position = CGPointMake(-100, -100);
    else
        menu.position = CGPointMake(screenSize.width/2, screenSize.height/2);
    
    if((int)countdown > 0 && (int)countdown <=3)
        [countdownLabel setString:[NSString stringWithFormat:@"%d", (int)countdown]];
    else
        [countdownLabel setString:@" "];
    
    [opponentRoundLabel setString:[NSString stringWithFormat:@"Rounds Won: " @"%d", [opponent getRoundScore]]];
    [playerRoundLabel setString:[NSString stringWithFormat:@"Rounds Won: " @"%d", [player getRoundScore]]];
    
    [self checkCollision];
    [self checkOpponentScore];
    [self checkPlayerScore];
    [self updateScore];
    [self checkWin];
    [self moveOpponentPaddle];
    
    
    //prevents scoring from incrementing more than once
    if([ball getYpos] > 10 && [ball getYpos] < 400)
        playerScored = FALSE;

    
    //updates time
    [timeLabel setString:[NSString stringWithFormat:@"%d", (int)totalTime]];
    
}
-(void) checkCollision
{
    //Checks collison with player
        //Checks collison with player
    int playerCollisionSeg = [player GetCollisionSegment:[ball tipOfBallX] leftPos:[ball leftOfBall] rightPos:[ball rightOfBall]];
    
    int opponentCollisionSeg = [opponent GetCollisionSegment:[ball tipOfBallX] leftPos:[ball leftOfBall] rightPos:[ball rightOfBall]];
    
    
    
    CGPoint normVect = CGPointMake(0, 1);
    
    CGRect ballbox = CGRectMake((ball.ballSprite.position.x-ball.ballSprite.contentSize.width/2), (ball.ballSprite.position.y-ball.ballSprite.contentSize.height/2), ball.ballSprite.contentSize.width, ball.ballSprite.contentSize.height);
    CGRect playerPaddleBox = CGRectMake((player.paddleSprite.position.x - player.paddleSprite.contentSize.width/2), (player.paddleSprite.position.y - player.paddleSprite.contentSize.height/2), player.paddleSprite.contentSize.width, player.paddleSprite.contentSize.height);
    
    CGRect opponentPaddleBox = CGRectMake((opponent.paddleSprite.position.x - opponent.paddleSprite.contentSize.width/2), (opponent.paddleSprite.position.y - opponent.paddleSprite.contentSize.height/2), opponent.paddleSprite.contentSize.width, opponent.paddleSprite.contentSize.height);
    
    if (CGRectIntersectsRect(ballbox, playerPaddleBox) && ball.didCollide == FALSE && ball.ballSprite.position.y > player.paddleSprite.position.y) {
        
        ball.didCollide = TRUE;
        
        float ballPosRelativeToLeftPaddle = [ball getPosition].x - [player leftHalfOfPaddle];
        
        //ensures that a number between 0 and 21 is returned. Any other value will cause error.
        if(ballPosRelativeToLeftPaddle <= 0)
            ballPosRelativeToLeftPaddle = 0;
        if(ballPosRelativeToLeftPaddle > 21)
            ballPosRelativeToLeftPaddle = 21;
        
        float ballPosRelativeToRightPaddle = [player rightHalfOfPaddle] - [ball getPosition].x;
        
        //ensures that a number between 0 and 21 is returned. Any other value will cause error.
        if(ballPosRelativeToRightPaddle < 0)
            ballPosRelativeToRightPaddle = 0;
        if(ballPosRelativeToRightPaddle > 21)
            ballPosRelativeToRightPaddle = 21;
        
        CGFloat adjSpeedLeftA = (oneThirdOfPlayerPaddle - ballPosRelativeToLeftPaddle)*.09524f;
        CGFloat adjSpeedRightA = -(oneThirdOfPlayerPaddle - ballPosRelativeToLeftPaddle)*.09524f;
        
        CGFloat bluntAngleLeftA = (oneThirdOfPlayerPaddle - ballPosRelativeToLeftPaddle)*0.0374f;
        CGFloat bluntAngleRightA = -(oneThirdOfPlayerPaddle - ballPosRelativeToLeftPaddle)*0.0374f;
        
        CGFloat adjSpeedLeftC = -(oneThirdOfPlayerPaddle - ballPosRelativeToRightPaddle)*.09524f;
        CGFloat adjSpeedRightC = (oneThirdOfPlayerPaddle - ballPosRelativeToRightPaddle)*.09524f;
        
        CGFloat bluntAngleLeftC = -(oneThirdOfPlayerPaddle -ballPosRelativeToRightPaddle)*0.0374f;
        CGFloat bluntAngleRightC = (oneThirdOfPlayerPaddle - ballPosRelativeToRightPaddle)*0.0374f;
        
        switch (playerCollisionSeg) {
            case SegmentA:
                [[SimpleAudioEngine sharedEngine] playEffect:@"bounce.wav"];
                if(ball.velocity.x >= 0) {
                    CCLOG(@"\nHit segment A approaching from left");
                    CCLOG(@"\nX %f", ballPosRelativeToLeftPaddle);
                    CCLOG(@"\nBlunt Angle: %f", (bluntAngleLeftA*180/M_PI));
                    if(([ball getAngle]<=(M_PI/2) && [ball getAngle] >0)||([ball getAngle] >(M_PI) && [ball getAngle] < (3*M_PI/2)))
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleRightA andSpeedAdjust:adjSpeedRightA];
                    else
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleLeftA andSpeedAdjust:adjSpeedRightA];
                        
                }
                else {
                    CCLOG(@"\nHit segment A approaching from right");
                    CCLOG(@"\nX %f", ballPosRelativeToLeftPaddle);
                    CCLOG(@"\nBlunt Angle: %f", (bluntAngleRightA*180/M_PI));
                    if(([ball getAngle]<=(M_PI/2) && [ball getAngle] >0)||([ball getAngle] >(M_PI) && [ball getAngle] < (3*M_PI/2)))
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleLeftA andSpeedAdjust:adjSpeedLeftA];
                    else
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleRightA andSpeedAdjust:adjSpeedLeftA];
                }
                break;
            case SegmentB:
                [[SimpleAudioEngine sharedEngine] playEffect:@"bounce.wav"];
                NSLog(@"\nHit segment C");
                ball.velocity = [ball reflect:normVect withBlunt:0 andSpeedAdjust:0];
                break;
            case SegmentC:
                [[SimpleAudioEngine sharedEngine] playEffect:@"bounce.wav"];
                if(ball.velocity.x >= 0) {
                    CCLOG(@"\nHit segment C approaching from left");
                    CCLOG(@"\nX %f", ballPosRelativeToRightPaddle);
                    CCLOG(@"\nBlunt Angle: %f", (bluntAngleLeftC*180/M_PI));
                    normVect.y = -normVect.y;
                    if(([ball getAngle]<=(M_PI/2) && [ball getAngle] >0)||([ball getAngle] >(M_PI) && [ball getAngle] < (3*M_PI/2)))
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleRightC andSpeedAdjust:adjSpeedRightC];
                    else
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleLeftC andSpeedAdjust:adjSpeedRightC];                }
                else {
                    CCLOG(@"\nHit segment C approaching from right");
                    CCLOG(@"\nX %f", ballPosRelativeToRightPaddle);
                    CCLOG(@"\nBlunt Angle: %f", (bluntAngleRightC*180/M_PI));
                    normVect.y = -normVect.y;
                    if(([ball getAngle]<=(M_PI/2) && [ball getAngle] >0)||([ball getAngle] >(M_PI) && [ball getAngle] < (3*M_PI/2)))
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleLeftC andSpeedAdjust:adjSpeedLeftC];
                    else
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleRightC andSpeedAdjust:adjSpeedLeftC];                }
            default:
                break;
        }
        
    }
    else if (CGRectIntersectsRect(ballbox, opponentPaddleBox) && ball.didCollide == FALSE && ball.ballSprite.position.y < opponent.paddleSprite.position.y) {
        
        ball.didCollide = TRUE;

        float ballPosRelativeToLeftPaddle = [ball getPosition].x - [opponent leftHalfOfPaddle];
        
        //ensures that a number between 0 and 21 is returned. Any other value will cause error.
        if(ballPosRelativeToLeftPaddle <= 0)
            ballPosRelativeToLeftPaddle = 0;
        if(ballPosRelativeToLeftPaddle > 21)
            ballPosRelativeToLeftPaddle = 21;
        
        float ballPosRelativeToRightPaddle = [opponent rightHalfOfPaddle] - [ball getPosition].x;
        
        //ensures that a number between 0 and 21 is returned. Any other value will cause error.
        if(ballPosRelativeToRightPaddle < 0)
            ballPosRelativeToRightPaddle = 0;
        if(ballPosRelativeToRightPaddle > 21)
            ballPosRelativeToRightPaddle = 21;
        
        CGFloat adjSpeedLeftA = (oneThirdOfOpponentPaddle - ballPosRelativeToLeftPaddle)*.09524f;
        CGFloat adjSpeedRightA = -(oneThirdOfOpponentPaddle - ballPosRelativeToLeftPaddle)*.09524f;
        
        CGFloat bluntAngleLeftA = (oneThirdOfOpponentPaddle - ballPosRelativeToLeftPaddle)*0.0374f;
        CGFloat bluntAngleRightA = -(oneThirdOfOpponentPaddle - ballPosRelativeToLeftPaddle)*0.0374f;
        
        CGFloat adjSpeedLeftC = -(oneThirdOfOpponentPaddle - ballPosRelativeToRightPaddle)*.09524f;
        CGFloat adjSpeedRightC = (oneThirdOfOpponentPaddle - ballPosRelativeToRightPaddle)*.09524f;
        
        CGFloat bluntAngleLeftC = -(oneThirdOfOpponentPaddle -ballPosRelativeToRightPaddle)*0.0374f;
        CGFloat bluntAngleRightC = (oneThirdOfOpponentPaddle - ballPosRelativeToRightPaddle)*0.0374f;
        
        switch (opponentCollisionSeg) {
            case SegmentA:
                [[SimpleAudioEngine sharedEngine] playEffect:@"bounce.wav"];
                if(ball.velocity.x >= 0) {
                    CCLOG(@"\nHit segment A approaching from left");
                    CCLOG(@"\nX %f", ballPosRelativeToLeftPaddle);
                    CCLOG(@"\nBlunt Angle: %f", (bluntAngleLeftA*180/M_PI));
                    if(([ball getAngle]<=(M_PI/2) && [ball getAngle] >0)||([ball getAngle] >(M_PI) && [ball getAngle] < (3*M_PI/2)))
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleRightA andSpeedAdjust:adjSpeedRightA];
                    else
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleLeftA andSpeedAdjust:adjSpeedRightA];
                    
                }
                else {
                    CCLOG(@"\nHit segment A approaching from right");
                    CCLOG(@"\nX %f", ballPosRelativeToLeftPaddle);
                    CCLOG(@"\nBlunt Angle: %f", (bluntAngleRightA*180/M_PI));
                    if(([ball getAngle]<=(M_PI/2) && [ball getAngle] >0)||([ball getAngle] >(M_PI) && [ball getAngle] < (3*M_PI/2)))
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleLeftA andSpeedAdjust:adjSpeedLeftA];
                    else
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleRightA andSpeedAdjust:adjSpeedLeftA];
                }
                break;
            case SegmentB:
                [[SimpleAudioEngine sharedEngine] playEffect:@"bounce.wav"];
                NSLog(@"\nHit segment C");
                ball.velocity = [ball reflect:normVect withBlunt:0 andSpeedAdjust:0];
                break;
            case SegmentC:
                [[SimpleAudioEngine sharedEngine] playEffect:@"bounce.wav"];
                if(ball.velocity.x >= 0) {
                    CCLOG(@"\nHit segment C approaching from left");
                    CCLOG(@"\nX %f", ballPosRelativeToRightPaddle);
                    CCLOG(@"\nBlunt Angle: %f", (bluntAngleLeftC*180/M_PI));
                    normVect.y = -normVect.y;
                    if(([ball getAngle]<=(M_PI/2) && [ball getAngle] >0)||([ball getAngle] >(M_PI) && [ball getAngle] < (3*M_PI/2)))
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleRightC andSpeedAdjust:adjSpeedRightC];
                    else
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleLeftC andSpeedAdjust:adjSpeedRightC];                }
                else {
                    CCLOG(@"\nHit segment C approaching from right");
                    CCLOG(@"\nX %f", ballPosRelativeToRightPaddle);
                    CCLOG(@"\nBlunt Angle: %f", (bluntAngleRightC*180/M_PI));
                    normVect.y = -normVect.y;
                    if(([ball getAngle]<=(M_PI/2) && [ball getAngle] >0)||([ball getAngle] >(M_PI) && [ball getAngle] < (3*M_PI/2)))
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleLeftC andSpeedAdjust:adjSpeedLeftC];
                    else
                        ball.velocity = [ball reflect:normVect withBlunt:bluntAngleRightC andSpeedAdjust:adjSpeedLeftC];                }
            default:
                break;
        }
    }
}



-(void)checkPlayerScore
{
    //Player score
    if([ball getYpos] >= 496 && !playerScored)
    {
        //[ball changeGreenBall];
        [[SimpleAudioEngine sharedEngine] playEffect:@"correct.wav"];
        [player updateScore];
        if([player getScore]==[opponent getScore]){
            [player changeSame];
            [opponent changeSame];
        }
        else if([player getScore]<[opponent getScore]){
            [player changeLosing];
            [opponent changeWinning];
        }
        else{
            [player changeWinning];
            [opponent changeLosing];
        }
        
        playerScored = TRUE;
    }
}

-(void)checkOpponentScore
{
    //opponent score
    if([ball getYpos] <= -10 && !playerScored)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"wrong.wav"];
        [opponent updateScore];
        //[ball changeMadBall];
        //change colore of paddle depending on who is winning
        if([player getScore]==[opponent getScore]){
            [player changeSame];
            [opponent changeSame];
        }
        else if([player getScore]<[opponent getScore]){
            [player changeLosing];
            [opponent changeWinning];
        }
        else{
            [player changeWinning];
            [opponent changeLosing];
        }

        
        playerScored = TRUE;
        
    }
    
}

-(void)updateScore
{
    
    //Updates player score
    [playerScoreLabel setString:[NSString stringWithFormat:@"%d", [player getScore]]];
    
    //Updates opponent score
    [opponentScoreLabel setString:[NSString stringWithFormat:@"%d", [opponent getScore]]];
}

-(void)moveOpponentPaddle
{
    //handles movement of AI paddle
    if ([opponent getXpos] > [ball getXpos] && [ball getYpos] > 200)
        [opponent moveLeft];
    
    if ([opponent getXpos] < [ball getXpos] && [ball getYpos]  > 200)
        [opponent moveRight];
}

-(void) checkWin
{
    //play to 11 to win
    if([opponent getScore] == pointsToWin)
        [self opponentWinsGame];
    
    //play to 11 to win
    if([player getScore] == pointsToWin)
        [self playerWinsGame];
}

//Displays "Sorry, you lose" in red for 3 seconds. Then starts a new game
-(void) opponentWinsGame
{
    //[ball changeMadBall];
    if(times==0){
        [opponent updateRoundScore];
        times =1;
    }
    
    if([opponent getRoundScore]< 3){
        
        winner = @"Sorry, you lose the round";
        winnerLabel.color = ccRED;
        [winnerLabel setString:(winner)];
        [self performSelector:@selector(newGame) withObject:nil afterDelay:3.0];
        
        
    }
    else{
       
        winner = @"Sorry, you lose the game";
        winnerLabel.color = ccRED;
        [winnerLabel setString:(winner)];
        [self performSelector:@selector(newGame) withObject:nil afterDelay:3.0];
        
        
    }
    
}


//Displays "Congratulations, you won" in red for 3 seconds. Then starts a new game
-(void) playerWinsGame
{
    
    if(times==0){
       [player updateRoundScore];
    times =1;
    }
    
    if([player getRoundScore]<3){
        winner = @"Congratulations\n you won the round!";
        winnerLabel.color = ccGREEN;
        [winnerLabel setString:(winner)];
    }
    else{
        winner = @"Congratulations\n you won the game!";
        winnerLabel.color = ccGREEN;
        [winnerLabel setString:(winner)];
    }
    
    currentscore = (NSInteger)totalTime;
    if(currentscore < currhighscore)
    {
        [prefs setInteger:*(currentscore) forKey:@"highScore"];
        [prefs synchronize];
        
    }
    
    [self performSelector:@selector(newGame) withObject:nil afterDelay:3.0];
    
}



-(void) newGame
{
    times = 0;
    //removes win/lose message
    winner = @" ";
    [winnerLabel setString:(winner)];
    
    //resets timer
    totalTime = 0;
    
    //resets scores
    [player resetScore];
    [opponent resetScore];
    
    currhighscore = [prefs integerForKey:@"highScore"];
    if(currhighscore == nil)
        currhighscore = 0;
    //resets rounds after game is over
    if([player getRoundScore]==3|| [opponent getRoundScore]==3){
        [player resetRoundScore];
        [opponent resetRoundScore];
        //Set opponent round score
        [opponentRoundLabel setString:[NSString stringWithFormat:@"Rounds: " @"%d", [opponent getRoundScore]]];
        
        //Set player round score
        [playerRoundLabel setString:[NSString stringWithFormat:@"Rounds: " @"%d", [player getRoundScore]]];
        
        [[CCDirector sharedDirector] pushScene:[EndGameScene node]];
        
    highscore = [NSString stringWithFormat:@"highScore: %d ", (int)currhighscore];
    [highScoreLabel setString:(highscore)];
        
    }
    
    currhighscore = [prefs integerForKey:@"highScore"];
    if(currhighscore == nil)
        currhighscore = 0;
    
    highscore = [NSString stringWithFormat:@"highScore: %d ", (int)currhighscore];
    [highScoreLabel setString:(highscore)];
    
    
}

-(NSInteger) GetLevel
{
    NSInteger level = [[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
    return level;
}

-(void) SetLevel:(NSInteger) level
{
    // set level value
    [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"level"];
    
    // save the data
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) GetMatchLevel
{
    NSInteger matchLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
    return matchLevel;
}

-(void) SetMatchLevel:(NSInteger) matchLevel
{
    // set level value
    [[NSUserDefaults standardUserDefaults] setInteger:matchLevel forKey:@"matchLevel"];
    
    // save the data
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end



