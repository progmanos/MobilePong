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


@implementation GameLayer

-(id) init
{
    if ((self = [super init]))
    {
        times =0;
        multiplayer = FALSE;
        prefs = [NSUserDefaults standardUserDefaults];
        
        playerScored = FALSE;
        [player1 resetScore];
        [AIplayer resetScore];
       
        
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
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        [self addChild:background z:0 tag:1];
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        
        pauseButton = [CCMenuItemImage itemFromNormalImage:@"pausebutton.png" selectedImage:@"pausebutton.png" target:self selector:@selector(pauseButtonTapped:)];
        
        menu = [CCMenu menuWithItems:pauseButton, nil];
        menu.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        [self addChild:menu z:0];
        
        
        //sets label for score of AIplayer
        AIscoreLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:48];
        AIscoreLabel.position = ccp((screenSize.width/2), (screenSize.height - (screenSize.height/6)));
        AIscoreLabel.color = ccBLACK;
        [self addChild:AIscoreLabel z:0];
        
        //sets label for score of AIplayer
        player1scoreLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:48];
        player1scoreLabel.position = ccp((screenSize.width/2), (screenSize.height/6));
        player1scoreLabel.color = ccBLACK;
        [self addChild:player1scoreLabel z:0];
        
        
        //sets label for score of AIplayer's round
        AIroundLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:12];
        AIroundLabel.position = ccp((screenSize.width)/2, ((screenSize.height)-45));
        AIroundLabel.color = ccBLACK;
        [self addChild:AIroundLabel z:0];
        
        //sets label for score of player1's round
        player1roundLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:12];
        player1roundLabel.position = ccp((screenSize.width)/2, 45);
        player1roundLabel.color = ccBLACK;
        [self addChild:player1roundLabel z:0];
        
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
        
        
        //creates ball, player, and AI player
        ball = [Ball ballWithParentNode:self];
        player1 = [Player playerWithParentNode:self];
        player1.playerType = User;
        AIplayer = [Player playerWithParentNode:self];
        AIplayer.playerType = Opponent;
        
        //sets initial position of player1 & AIplayer
        [player1 setPosition:CGPointMake(screenSize.width / 2, 20.0)];
        [AIplayer setPosition:CGPointMake(screenSize.width/2, (screenSize.height - 20))];
        
        //Set AI round score
        [AIroundLabel setString:[NSString stringWithFormat:@"Rounds Won: " @"%d", [AIplayer getRoundScore]]];
        
        //Set player1 round score
        [player1roundLabel setString:[NSString stringWithFormat:@"Rounds Won: " @"%d", [player1 getRoundScore]]];
        
        
        //initialize player and AI velocity
        [player1 setSpeed:(6)];
        
        //rudimentary AI
        //shrink the paddle by 20 pixels for level 1 and 10 for level two
        // use normal size for level three
        // increase the velocity per level
        switch (level) {
            case Level_One:
                [AIplayer setSpeed:(3)];
                [AIplayer resizePaddleWidth:([AIplayer initialPaddleWidth] - 20)];
                break;
            case Level_Two:
                [AIplayer setSpeed:(4)];
                [AIplayer resizePaddleWidth:([AIplayer initialPaddleWidth] - 10)];
                break;
            case Level_Three:
                [AIplayer setSpeed:(5)];
                break;
            default:
                break;
        }
        
        
       
        
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
    
    [AIroundLabel setString:[NSString stringWithFormat:@"Rounds Won: " @"%d", [AIplayer getRoundScore]]];
    [player1roundLabel setString:[NSString stringWithFormat:@"Rounds Won: " @"%d", [player1 getRoundScore]]];
    
    [self checkCollision];
    [self checkAIScore];
    [self checkPlayerScore];
    [self updateScore];
    [self checkWin];
    [self moveAIPaddle];
    
    
    //prevents scoring from incrementing more than once
    if([ball getYpos] > 10 && [ball getYpos] < 400)
        playerScored = FALSE;

    
    //updates time
    [timeLabel setString:[NSString stringWithFormat:@"%d", (int)totalTime]];
    
}
-(void) checkCollision
{
    //Checks collison with player
    int player1CollisionSeg = [player1 GetCollisionSegment:[ball tipOfBallX] leftPos:[ball leftOfBall] rightPos:[ball rightOfBall]];
    
    if (player1CollisionSeg >= SegmentA && player1CollisionSeg <= SegmentC && [ball tipOfBall] >= ([player1 tipOfPaddle]-5) && [ball tipOfBall] <= ([player1 tipOfPaddle]) && ball.didCollide == FALSE) {
        ball.velocity = [ball reflectStraight:CGPointMake(0,1)];
        ball.didCollide = TRUE;
    }
    else {
        int opponentCollisionSeg = [AIplayer GetCollisionSegment:[ball tipOfBallX] leftPos:[ball leftOfBall] rightPos:[ball rightOfBall]];
        if (opponentCollisionSeg >= SegmentA && opponentCollisionSeg <= SegmentC && [ball opponentTipOfBall] <= ([AIplayer tipOfPaddle]+5) && [ball opponentTipOfBall] >= ([AIplayer tipOfPaddle])) {
            ball.velocity = [ball reflectStraight:CGPointMake(0,-1)];
            ball.didCollide = TRUE;
        }
    }
}



-(void)checkPlayerScore
{
    //Player score
    if([ball getYpos] >= 496 && !playerScored)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"correct.wav"];
        [player1 updateScore];
        playerScored = TRUE;
    }
}

-(void)checkAIScore
{
    //AI score
    if([ball getYpos] <= -10 && !playerScored)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"wrong.wav"];
        [AIplayer updateScore];
        playerScored = TRUE;
    }
}

-(void)updateScore
{
    
    //Updates player1score
    [player1scoreLabel setString:[NSString stringWithFormat:@"%d", [player1 getScore]]];
    
    //Updates AIscore
    [AIscoreLabel setString:[NSString stringWithFormat:@"%d", [AIplayer getScore]]];
}

-(void)moveAIPaddle
{
    //handles movement of AI paddle
    if ([AIplayer getXpos] > [ball getXpos] && [ball getYpos] > 200)
        [AIplayer moveLeft];
    
    if ([AIplayer getXpos] < [ball getXpos] && [ball getYpos]  > 200)
        [AIplayer moveRight];
}

-(void) checkWin
{
    //play to 11 to win
    if([AIplayer getScore] == pointsToWin)
        [self AIwinsGame];
    
    //play to 11 to win
    if([player1 getScore] == pointsToWin)
        [self player1WinsGame];
}

//Displays "Sorry, you lose" in red for 3 seconds. Then starts a new game
-(void) AIwinsGame
{
    if(times==0){
        [AIplayer updateRoundScore];
        times =1;
    }
    
    if([AIplayer getRoundScore]< 3){
        
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
-(void) player1WinsGame
{
    if(times==0){
       [player1 updateRoundScore];
    times =1;
    }
    
    if([player1 getRoundScore]<3){
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
    [player1 resetScore];
    [AIplayer resetScore];
    
    currhighscore = [prefs integerForKey:@"highScore"];
    if(currhighscore == nil)
        currhighscore = 0;
    //resets rounds after game is over
    if([player1 getRoundScore]==3|| [AIplayer getRoundScore]==3){
        [player1 resetRoundScore];
        [AIplayer resetRoundScore];
        //Set AI round score
        [AIroundLabel setString:[NSString stringWithFormat:@"Rounds: " @"%d", [AIplayer getRoundScore]]];
        
        //Set player1 round score
        [player1roundLabel setString:[NSString stringWithFormat:@"Rounds: " @"%d", [player1 getRoundScore]]];
        
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



