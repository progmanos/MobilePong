//
//  GameLayer.m
//  PongT2
//
//  Created by Shawney Moore on 2/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//
#import "GameLayer.h"



@implementation GameLayer

-(id) init
{
    if ((self = [super init]))
    {
        
        prefs = [NSUserDefaults standardUserDefaults];
        
        playerScored = FALSE;
        
        currhighscore = [prefs integerForKey:@"highScore"];
        if(currhighscore == nil)
            currhighscore = 0;
        
        highscore = [NSString stringWithFormat:@"highScore: %d ", (int)currhighscore];
        
        
        // get level, set default level if the level key does not exist
        NSInteger level = [self GetLevel];
        
        if (level == 0) {
            NSInteger defaultLevel = 1;
            [self SetLevel:defaultLevel];
        }
    
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        self.isTouchEnabled = YES;
        
        // move this to a header file for use in other classes
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        //sets background to court image
        CCSprite *background = [CCSprite spriteWithFile:@"court.png"];
        [self addChild:background z:0 tag:1];
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        
        //creates ball, player, and AI player
        ball = [Ball ballWithParentNode:self];
        player1 = [Player playerWithParentNode:self];
        AIplayer = [Player playerWithParentNode:self];
        
        //sets initial position of player1 & AIplayer
        [player1 setPosition:CGPointMake(screenSize.width / 2, 20.0)];
        [AIplayer setPosition:CGPointMake(screenSize.width/2, (screenSize.height - 20))];
        
        //sets label for score of AIplayer
        AIscoreLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:24];
        AIscoreLabel.position = ccp((screenSize.width/2), (screenSize.height - (screenSize.height/4)));
        AIscoreLabel.color = ccBLACK;
        [self addChild:AIscoreLabel z:1];
        
        //sets label for score of AIplayer
        player1scoreLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:24];
        player1scoreLabel.position = ccp((screenSize.width/2), (screenSize.height/4));
        player1scoreLabel.color = ccBLACK;
        [self addChild:player1scoreLabel z:1];
        
        //sets label for time of gameplay
        timeLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:24];
        timeLabel.color = ccRED;
        timeLabel.position = ccp(30, 30);
        [self addChild:timeLabel z:1];
        
        //sets label for winner of the game
        winnerLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:48];
        winnerLabel.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:winnerLabel z:2];
        
        //sets label for highscore
        highScoreLabel = [CCLabelTTF labelWithString:@"8" fontName:@"Marker Felt" fontSize:12];
        highScoreLabel.position = ccp(35, 5);
        [self addChild:highScoreLabel z:0];
        [highScoreLabel setString:(highscore)];
        
        
        //initialize player and AI velocity
        [player1 setVelocity:(5)];
        [AIplayer setVelocity:(2)];
        
        
        [self scheduleUpdate];
        
        
    }
	
    return self;
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

-(void) movePlayerLeft
{
    [player1 moveLeft];
}

-(void) movePlayerRight
{
    [player1 moveRight];
}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
    CGFloat currPaddleWidth = player1.getPaddleWidth;
    if(point.x < (player1.paddleSprite.position.x - (currPaddleWidth/2))) {
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

-(void) update:(ccTime)delta
{
    //time in seconds
    totalTime += delta;
    
    //collsion for player paddle
    /*if([ball getYpos] <= 30 && ([ball getYpos]+9) >= 20 &&ball.didCollide == FALSE && ([ball getXpos]) > ([player1 getXpos] - 30) && (([ball getXpos]+9) < [player1 getXpos] + 30))
        [ball switchVel];*/
    
    //first if statement checks to see if the ball is hitting the paddle
    if(([ball tipOfBall]<=([player1 tipOfPaddle]))&&[ball tipOfBall]>=([player1 tipOfPaddle]-.5)){
        //check to see if it hits section C
        if (([player1 first]<=[ball tipOfBallX])&&([ball tipOfBallX] <= [player1 second])) {
            
            [ball switchVel];
        }
         //checks to see if it hits section B(part before or) and section D (part after or)
        else if (([player1 third]<=[ball tipOfBallX] &&[ball tipOfBallX]<= [player1 first])
                 || ([player1 second]<=[ball tipOfBallX]&& [ball tipOfBallX]<= [player1 fourth])){
            
            
            [ball switchVel];
        }
        //checks to see if it hits section A(part before or) and section E (part after or)
        else if (([player1 fifth]<=[ball tipOfBallX] &&[ball tipOfBallX]<= [player1 third])
                ||([player1 fourth]<=[ball tipOfBallX]&&[ball tipOfBallX] <= [player1 sixth])){
            
            [ball switchVel];
        }
        /*else if{
            [AIplayer updateScore];
            
            [ball AIserveBall];
            
        }*/
    }
    
    //checks to see if ball is going to hit right side of paddle
    if (([player1 rightOfPaddle]+.5)>=[ball leftOfBall]&& [ball leftOfBall]>=[player1 rightOfPaddle]){
        if ([player1 getYpos]<=[ball getYpos]&&[ball getYpos]<=[player1 tipOfPaddle]) {
            [ball switchVel];
        }
        
    }
    
    //checks to see if ball is going to hit left side of paddle
    else if (([player1 leftOfPaddle]-.5)<=[ball rightOfBall]&& [ball rightOfBall]<=[player1 leftOfPaddle]){
        if ([player1 getYpos]<=[ball getYpos]&&[ball getYpos]<=[player1 tipOfPaddle]) {
            [ball switchVel];
        }
    }

    
//collision for AIpaddle
   /* if(([ball getYpos]+9) >= 459 && ([ball getYpos]+9) <= 469 && ball.didCollide == FALSE && ([ball getXpos]+9) > ([AIplayer getXpos] - 30) && ([ball getXpos]+9) < ([AIplayer getXpos] + 30))
        [ball switchVel];
    */
    
    //first if statement checks to see if the ball is hitting the paddle
    if([ball opponentTipOfBall]<=[AIplayer OpponentTipOfPaddle]&&[ball opponentTipOfBall]>=([AIplayer OpponentTipOfPaddle]-.5)){
        
        //check to see if it hits section C
        if (([AIplayer first]<=[ball tipOfBallX])&&([ball tipOfBallX] <= [AIplayer second])) {
            
            [ball switchVel];
        }
        //checks to see if it hits section B(part before or) and section D (part after or)
        else if (([AIplayer third]<=[ball tipOfBallX] &&[ball tipOfBallX]<= [AIplayer first])
                 || ([AIplayer second]<=[ball tipOfBallX]&& [ball tipOfBallX]<= [AIplayer fourth])){
            
            
            [ball switchVel];
        }
        //checks to see if it hits section A(part before or) and section E (part after or)
        else if (([AIplayer fifth]<=[ball tipOfBallX] &&[ball tipOfBallX]<= [AIplayer third])
                 ||([AIplayer fourth]<=[ball tipOfBallX]&&[ball tipOfBallX] <= [AIplayer sixth])){
            
            [ball switchVel];
        }
        /*else if{
         [AIplayer updateScore];
         
         [ball AIserveBall];
         
         }*/
    }
    
    //checks to see if ball is going to hit right side of paddle
    if (([AIplayer rightOfPaddle]+.5)>=[ball leftOfBall]&& [ball leftOfBall]>=[AIplayer rightOfPaddle]){
        if ([AIplayer getYpos]<=[ball getYpos]&&[ball getYpos]<=[AIplayer OpponentTipOfPaddle]) {
            [ball switchVel];
        }
        
    }
    
    //checks to see if ball is going to hit right side of paddle
    else if (([AIplayer leftOfPaddle]-.5)<=[ball rightOfBall]&& [ball rightOfBall]<=[AIplayer leftOfPaddle]){
        if ([AIplayer getYpos]<=[ball getYpos]&&[ball getYpos]<=[AIplayer OpponentTipOfPaddle]) {
            [ball switchVel];
        }
    }
    
    //AI score
    if([ball getYpos] <= -10 && !playerScored)
    {
        
        [AIplayer updateScore];
        playerScored = TRUE;
       
    }
    
    //Player score
    if([ball getYpos] >= 496 && !playerScored)
    {
        [player1 updateScore];
        playerScored = TRUE;
    }
    
    //prevents scoring from incrementing more than once
    if([ball getYpos] > 10 && [ball getYpos] < 400)
        playerScored = FALSE;

    //handles movement of AI paddle
    if ([AIplayer getXpos] > [ball getXpos] && [ball getYpos] > 200)
        [AIplayer moveLeft];
    
    if ([AIplayer getXpos] < [ball getXpos] && [ball getYpos]  > 200)
        [AIplayer moveRight];
    
    //Updates AIscore
    [AIscoreLabel setString:[NSString stringWithFormat:@"%d", [AIplayer getScore]]];
    
    //Updates player1score
    [player1scoreLabel setString:[NSString stringWithFormat:@"%d", [player1 getScore]]];
    
    //updates time
    [timeLabel setString:[NSString stringWithFormat:@"%d", (int)totalTime]];
    
    
    //play to 11 to win
    if([AIplayer getScore] == 11)
        [self AIwinsGame];
    
    //play to 11 to win
    if([player1 getScore] == 11)
        [self player1WinsGame];
    


}

//Displays "Sorry, you lose" in red for 3 seconds. Then starts a new game
-(void) AIwinsGame
{
    
    winner = @"Sorry, you lose";
    winnerLabel.color = ccRED;
    [winnerLabel setString:(winner)];
    [self performSelector:@selector(newGame) withObject:nil afterDelay:3.0];
}

//Displays "Congratulations, you won" in red for 3 seconds. Then starts a new game
-(void) player1WinsGame
{
    winner = @"Congratulations\n you won!";
    winnerLabel.color = ccGREEN;
    [winnerLabel setString:(winner)];
    
    
    currentscore = (NSInteger)totalTime;
    if(currentscore < currhighscore)
    {
        [prefs setInteger:currentscore forKey:@"highScore"];
        [prefs synchronize];
        
    }
    
    [self performSelector:@selector(newGame) withObject:nil afterDelay:3.0];
    
}



-(void) newGame
{
    //removes win/lose message
    winner = @" ";
    [winnerLabel setString:(winner)];
    
    //resets timer
    totalTime = 0;
    
    //resets scores
    [player1 resetScore];
    [AIplayer resetScore];
    
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
@end



