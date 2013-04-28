//
//  MultiplayerLayer.m
//  PongT2
//
//  Created by Shawney Moore on 3/18/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "SimpleAudioEngine.h"
#import <GameKit/GameKit.h>
#import "AppDelegate.h"
#import "RootViewController.h"
#import "MultiplayerLayer.h"


//
// various states for peer picker
//
typedef enum {
    kStateStartGame,
    kStatePicker,
    kStateMultiplayer,
    kStateMultiplayerCointoss,
    kStateMultiplayerReconnect
} gameStates;


// GameKit Session ID for app
#define kSessionID @"PONGCS4893"


@interface MultiplayerLayer(Private)
-(void) setLastError:(NSError*)error;
@end

@implementation MultiplayerLayer

@synthesize gameState, peerStatus, gameSession, gamePeerId, connectionAlert, lastError;

-(id) init
{
    if ((self = [super init]))
    {
        gameOverViewDisplayed = FALSE;
        bluetooth = FALSE;
        online = FALSE;
        createdConnection = FALSE;
        gameOver = FALSE;
        gameSession = nil;
        gamePeerId = nil;
        
        countdown = 0;

        myPicker = [[GKPeerPickerController alloc] init];
        
        NSString *uid = [[UIDevice currentDevice] uniqueIdentifier];
        
        gameUniqueID = [uid hash];
        
        
        self.gameState = kStateStartGame; // Setting to kStateStartGame does a reset of players, scores, etc.
        [self startPicker];
 
        
        
        endMultiPlayer = FALSE;
        gamePaused = FALSE;
        times = 0;
        ournumber = arc4random()%100000;
        //ournumber = 0;
        opponentRecRandNum = FALSE;
        player1=FALSE;
        player2=FALSE;
        playerDetermined=FALSE;
        initialPosition=FALSE;
        playerConnected=TRUE;
        playerScored=FALSE;
        
        
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        self.isTouchEnabled = YES;
        
        screenSize = [CCDirector sharedDirector].winSize;
        
        //sets background to court image
        CCSprite *background = [CCSprite spriteWithFile:@"background3.png"];
        [self addChild:background z:0 tag:1];
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        
        pauseButton = [CCMenuItemImage itemFromNormalImage:@"pause.png" selectedImage:@"pause.png" target:self selector:@selector(pauseButtonTapped:)];
        
        menu = [CCMenu menuWithItems:pauseButton, nil];
        menu.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        [self addChild:menu z:0];
        
        //sets label for score of Opponent
        OpponentScoreLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:48];
        OpponentScoreLabel.position = ccp((screenSize.width/2), (screenSize.height - (screenSize.height/6)));
        OpponentScoreLabel.color = ccBLACK;
        [self addChild:OpponentScoreLabel z:0];
        
        //sets label for score of Opponent
        playerscoreLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:48];
        playerscoreLabel.position = ccp((screenSize.width/2), (screenSize.height/6));
        playerscoreLabel.color = ccBLACK;
        [self addChild:playerscoreLabel z:0];
        
        //sets label for time of gameplay
       /* timeLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:24];
        timeLabel.color = ccRED;
        timeLabel.position = ccp(30, 30);
        [self addChild:timeLabel z:1];*/
        
        //sets label for winner of the game
        winnerLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:48];
        winnerLabel.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:winnerLabel z:2];
        
        //sets label for countdown
        countdownLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:30];
        countdownLabel.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:countdownLabel z:0];
        [countdownLabel setString:([NSString stringWithFormat:@"%f", countdown])];
        countdownLabel.color = ccRED;
       
        
        //sets label for which player
        whichPlayerLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:12];
        whichPlayerLabel.position = ccp(200, 5);
        [self addChild:whichPlayerLabel z:0];
        [whichPlayerLabel setString:(@" ")];
        
        
        //creates ball, player, and AI player
        ball = [Ball ballWithParentNode:self];
        player = [Player playerWithParentNode:self];
        player.playerType = User;
        opponent = [Player playerWithParentNode:self];
        opponent.playerType = Opponent;
        
        //sets initial position of player & Opponent
        [player setPosition:CGPointMake(screenSize.width / 2, 20.0)];
        [opponent setPosition:CGPointMake(screenSize.width/2, (screenSize.height - 20))];
        
        //initialize player velocity
        [player setSpeed:5];
        
        oneThirdOfPlayerPaddle = [player paddleSprite].contentSize.width/3;
        oneThirdOfOpponentPaddle = [opponent paddleSprite].contentSize.width/3;
        

        
        [self scheduleUpdate];
        
        
    }
	
    return self;
}

- (void)pauseButtonTapped: (id)sender
{
    gamePaused = TRUE;
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
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView: [touch view]];
    CGFloat currPaddleWidth = player.getPaddleWidth;
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


-(void) checkCollision
{
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
    if([ball getYpos] >= 490 && !playerScored)
    {
        //play sound
        [[SimpleAudioEngine sharedEngine] playEffect:@"correct.wav"];
        
        //increment player score
        [player updateScore];
        
        //prevent score from incrementing too many times
        playerScored = TRUE;
    }
}

-(void)checkOpponentScore
{
    //Opponent score
    if([ball getYpos] <= 0 && !playerScored)
    {
        //play sound
        [[SimpleAudioEngine sharedEngine] playEffect:@"wrong.wav"];
        
        //increment player score
        [opponent updateScore];
        
        //prevent score from incrementing too many times
        playerScored = TRUE;
    }
}


-(void)updateScore
{
    
    //Updates playerscore
    [playerscoreLabel setString:[NSString stringWithFormat:@"%d", [player getScore]]];
    [OpponentScoreLabel setString:[NSString stringWithFormat:@"%d", [opponent getScore]]];

}



//set initial position of each player
-(void)initialize
{
    //before game starts, player one send their ball position to player
    if(player1)
    {
        //[self sendBallPosition:[ball getPosition]];
        initialPosition = TRUE;
    }
    if(player2)
    {
        //[ball setVelocity:CGPointMake(-[ball getVelocity].x, -[ball getVelocity].y)];
        initialPosition = TRUE;
    }
    
    usleep(100000);
}


-(void) update:(ccTime)delta
{
    if(gamePaused)
        [[CCDirector sharedDirector] pushScene:[PauseScene node]];

    
    //ARRAY PACKET ORDER
    // [0] - packet number - numberWithInt
    // [1] – ball angle - numberWithDouble
    // [2] - ball speed - numberWithDouble
    // [3] - x-coord of ball position - numberWithInt
    // [4] - y-coord of ball position - numberWithInt
    // [5] - position of your paddle - numberWithInt
    // [6] - opponent's current score - numberWithInt
    // [7] - your current score - numberWithInt
    // [8] - pause state (0:unpaused, 1:paused) - numberWithInt
    // [9] – did I just score? (bool yes or no) - numberWithBool
    // [10] – randomly generated number that determines if host or not - numberWithInt
    // [11] – determines game version
    // [12] – countdown
    
    int numpacket = 0;
    
    myData = [NSArray arrayWithObjects:
              [NSNumber numberWithInt:numpacket],
              [NSNumber numberWithDouble:[ball getAngle]],
              [NSNumber numberWithDouble:[ball getSpeed]],
              [NSNumber numberWithInt:[ball getPosition].x],
              [NSNumber numberWithInt:[ball getPosition].y],
              [NSNumber numberWithInt:[player getXpos]],
              [NSNumber numberWithInt:[opponent getScore]],
              [NSNumber numberWithInt:[player getScore]],
              [NSNumber numberWithInt:gamePaused],
              [NSNumber numberWithBool:playerScored],
              [NSNumber numberWithInt:ournumber],
              [NSNumber numberWithInt:1],
              [NSNumber numberWithInt:((int)countdown)],
              nil];
    if(online || bluetooth)
        [self sendArray:myData];
    
    if(online)
        if([gkHelper currentMatch])
            
    
    if(endMultiPlayer && !bluetooth)
        [gkHelper disconnectCurrentMatch];
    
    
    //time in seconds
    totalTime += delta;
    
    if(player1)
    {
        countdown -= delta;
        [self checkPlayerScore];
        [self checkOpponentScore];
    }
    if((int)countdown > 0)
        menu.position = CGPointMake(-100, -100);
    else
        menu.position = CGPointMake(screenSize.width/2, screenSize.height/2);
    
    if((int)countdown > 0 && (int)countdown <=3)
        [countdownLabel setString:[NSString stringWithFormat:@"%d", (int)countdown]];
    else
        [countdownLabel setString:@" "];

    [self checkCollision];
    [self updateScore];
    [self checkWin];
    
    if(player1 && countdown < 1)
        [ball moveBall];
    
    //prevents scoring from incrementing more than once
    if([ball getYpos] > 10 && [ball getYpos] < 400)
        playerScored = FALSE;
    
    
}

//Handles cancel button in wi-fi matchmaking screen
-(void) onMatchmakingViewDismissed
{
    [self startPicker];
}


//Called when players are disconnected
-(void) onPlayerDisconnected:(NSString*)playerID;
{
    
    
    if(!gameOver)
    {
        if(gamePaused)
            [pauseAlert dismissWithClickedButtonIndex:-1 animated:YES];
        // We've been disconnected from the other peer.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lost Connection" message:nil delegate:self cancelButtonTitle:@"End Game" otherButtonTitles:nil];
        self.connectionAlert = alert;
        [alert show];
    
    
        [[CCDirector sharedDirector] pause];
    }
}


-(void) checkWin
{
    //play to 11 to win
    if([opponent getScore] == 11)
        [self AIwinsGame];
    
    //play to 11 to win
    if([player getScore] == 11)
        [self playerWinsGame];
    
    //if multiplayer, opponent score = 11
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    
    if (buttonIndex == 0) {
        [gkHelper disconnectCurrentMatch];
        [[CCDirector sharedDirector] resume];
        [[CCDirector sharedDirector] popScene];
        if(gamePaused)
            [[CCDirector sharedDirector] popScene];

    }
    
}

//Displays "Sorry, you lose" in red for 3 seconds. Then starts a new game
-(void) AIwinsGame
{
    gameOver = TRUE;
    if(!gameOverViewDisplayed)
    {
    gameOverAlert = [[UIAlertView alloc] initWithTitle:@"Sorry, you lose" message:nil delegate:self cancelButtonTitle:@"Main Menu" otherButtonTitles:nil, nil];
    [gameOverAlert show];
    gameOverViewDisplayed = TRUE;
    [[CCDirector sharedDirector] pause];

    }
    //[[CCDirector sharedDirector] pause];
    //winner = @"Sorry, you lose";
    /*winnerLabel.color = ccRED;
    [winnerLabel setString:(winner)];
    [gkHelper disconnectCurrentMatch];
   // [self performSelector:@selector(newGame) withObject:nil afterDelay:3.0];*/
}

//Displays "Congratulations, you won" in red for 3 seconds. Then starts a new game
-(void) playerWinsGame
{
    gameOver = TRUE;
    if(!gameOverViewDisplayed)
    {
        gameOverAlert = [[UIAlertView alloc] initWithTitle:@"Congratulations, you won!" message:nil delegate:self cancelButtonTitle:@"Main Menu" otherButtonTitles:nil, nil];
        [gameOverAlert show];
        gameOverViewDisplayed = TRUE;
        [[CCDirector sharedDirector] pause];

    }
    

    [[CCDirector sharedDirector] pause];
    /*winner = @"Congratulations\n you won!";
    winnerLabel.color = ccGREEN;
    [winnerLabel setString:(winner)];
    [gkHelper disconnectCurrentMatch];
    
   
  //  [self performSelector:@selector(newGame) withObject:nil afterDelay:3.0];
    */
}




#pragma mark GameKitHelper delegate methods

-(void) onFriendListReceived:(NSArray*)friends
{
	CCLOG(@"onFriendListReceived: %@", friends.description);
	
//	gkHelper = [GameKitHelper sharedGameKitHelper];
	
	if (friends.count > 0)
	{
		[gkHelper getPlayerInfo:friends];
	}
	else
	{
		[gkHelper submitScore:1234 category:@"Playtime"];
	}
}

-(void) onPlayerInfoReceived:(NSArray*)players
{
	CCLOG(@"onPlayerInfoReceived: %@", players.description);
	
	for (GKPlayer* gkPlayer in players)
	{
		CCLOG(@"PlayerID: %@, Alias: %@, isFriend: %i", gkPlayer.playerID, gkPlayer.alias, gkPlayer.isFriend);
	}
	
	[gkHelper submitScore:1234 category:@"Playtime"];
}


#pragma mark Achievements


-(void) showMatchmaking:(ccTime)delta
{
	GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
	CCLOG(@"LocalPlayer isAuthenticated changed to: %@", localPlayer.authenticated ? @"YES" : @"NO");
	
	if (localPlayer.authenticated)
	{
		GKMatchRequest* request = [[GKMatchRequest alloc] init];
		request.minPlayers = 2;
		request.maxPlayers = 2;
        playerConnected = TRUE;
		
		[gkHelper showMatchmakerWithRequest:request];
	}
}


// TM16: handles receiving of data, determines packet type and based on that executes certain code
-(void) onReceivedData:(NSData*)data fromPlayer:(NSString*)playerID
{
    createdConnection = TRUE;
    
    //ARRAY PACKET ORDER
    // [0] - packet number - numberWithInt
    // [1] – ball angle - numberWithDouble
    // [2] - ball speed - numberWithDouble
    // [3] - x-coord of ball position - numberWithInt
    // [4] - y-coord of ball position - numberWithInt
    // [5] - position of your paddle - numberWithInt
    // [6] - send opponent's current score/receive your score - numberWithInt
    // [7] - your current score - numberWithInt
    // [8] - pause state (0:unpaused, 1:paused) - numberWithInt
    // [9] – did I just score? (bool yes or no) - numberWithBool
    // [10] – randomly generated number that determines if host or not - numberWithInt
    // [11] – determines game version 
    // [12] – countdown
    
    (CCLOG(@"ON receive data method"));

    
    NSMutableArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    
    
    
//-------handles high score------------------------------------------------------------------------
    if(!player1)
    {
        [opponent setScore:[[myArray objectAtIndex:7]intValue]];
        [player setScore:[[myArray objectAtIndex:6]intValue]];
    }
    
//-------end of handle high score------------------------------------------------------------------
    
    
    
    
    
//-----Compares our number to oppoenet number to determine which player is player 1 and 2---------
    opponentnumber = [[myArray objectAtIndex:10]intValue];
    if(ournumber > opponentnumber)
    {
        [whichPlayerLabel setString:(@"PLAYER 1")];
        player1 = TRUE;
        player2 = FALSE;
    }
    else if(ournumber<opponentnumber)
    {
        [whichPlayerLabel setString:(@"PLAYER 2")];
        player2 = TRUE;
        player1 = FALSE;
    }
    else if(ournumber == opponentnumber)
    {
        ournumber = arc4random()%100000;
    }
//-------end of determine players------------------------------------------------------------------
    
    
    
    
//-----------------Sets ball posistion-------------------------------------------------------------
    if(!player1)
    {
        int xpos = [[myArray objectAtIndex:3]intValue]; //myArray[3] = ballx
        int ypos = [[myArray objectAtIndex:4]intValue]; //myArray[4] = bally
        
        if([[myArray objectAtIndex:11]intValue]==0)
           {
               CGPoint temp = CGPointMake((screenSize.width - xpos), (ypos));
               [ball setPosition:temp];
           }
        else
        {
            CGPoint temp = CGPointMake((screenSize.width - xpos), (screenSize.height -ypos));
            [ball setPosition:temp];
        }
        NSLog(@"Not player 1");
        NSLog(@"XPOS: %i", xpos);
        NSLog(@"YPOS: %i", ypos);
    }
//-----------------end set ball position----------------------------------------------------------------
    
    
    
    
//-----------------set opponents paddle position-------------------------------------------------------
    if([[myArray objectAtIndex:11]intValue]==0)
    {
        int opponentpaddlepos = [[myArray objectAtIndex:5]intValue]; //myArray[5] = paddle position
        [opponent setXPosition: ((screenSize.width)-opponentpaddlepos)];
        //[player setXPosition:([player getXpos]+[player paddleSprite].scaleX/2)];
    }
    else
    {
        int opponentpaddlepos = [[myArray objectAtIndex:5]intValue]; //myArray[5] = paddle position
        [opponent setXPosition: (screenSize.width - opponentpaddlepos)];
    }
//-----------------end set opponents paddle position-----------------------------------------------------
    
 
    
//-----------------handles pauses------------------------------------------------------------------------
    if([[myArray objectAtIndex:8]intValue])//myArray[8] = pause state
    {
        if(player1)
        {
            pauseAlert = [[UIAlertView alloc] initWithTitle:@" Player 2 has paused the game" message:nil delegate:self cancelButtonTitle:@"Quit Game" otherButtonTitles:nil, nil];
            [pauseAlert show];
            }
        if(player2)
        {
            pauseAlert = [[UIAlertView alloc] initWithTitle:@"Player 1 has paused the game" message:nil delegate:self cancelButtonTitle:@"Quit Game" otherButtonTitles:nil, nil];
            [pauseAlert show];
        }
        [[CCDirector sharedDirector] pause];

    }

    else
    {
        [pauseAlert dismissWithClickedButtonIndex:-1 animated:YES];
        [[CCDirector sharedDirector] resume];
    }
//-----------------end handle pause-------------------------------------------------------------------------------
    
    
    
    
    
//-----------------handle countdown------------------------------------------------------------------------------
    if(player2)
        countdown = [[myArray objectAtIndex:12]intValue];
    
//-----------------end handle countdown---------------------------------------------------------------------------


}

//send ball position
-(void) sendArray:(NSMutableArray *)myArray
{
        
    if(bluetooth)
        if(gameSession != nil)
        {
            [self sendNetworkPacket:gameSession :myArray sizeInBytes:sizeof(myArray)];
            CCLOG(@"Sending Array...."); 
        }
    
	if(online)
        if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
        {
            [[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:myArray sizeInBytes:sizeof(myArray)];
            CCLOG(@"Sending Array....");
        }
}

#pragma mark Peer Picker Related Methods
-(void)startPicker {
    
    GKPeerPickerController*		picker;
	self.gameState = kStatePicker;
    
	picker = [[GKPeerPickerController alloc] init]; // note: picker is released in various picker delegate methods when picker use is done.
	picker.delegate = self;
    
    picker.connectionTypesMask = (GKPeerPickerConnectionTypeNearby |
                                  GKPeerPickerConnectionTypeOnline);
    [picker show]; // show the Peer Picker
    playerConnected = TRUE;
}

#pragma mark GKPeerPickerControllerDelegate Methods

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
    
    picker.delegate = nil;
    
    // invalidate and release game session if one is around.
    if(self.gameSession != nil) {
        [self invalidateSession:self.gameSession];
        self.gameSession = nil;
    }
    
    // go back to start mode
    self.gameState = kStateStartGame;
    [[CCDirector sharedDirector] popScene];

}

//
// Provide a custom session that has a custom session ID. This is also an opportunity to provide a session with a custom display name.
//
- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type{
	if (type == GKPeerPickerConnectionTypeOnline) {
        bluetooth = FALSE;
        picker.delegate = nil;
        [picker dismiss];
        
        gkHelper = [GameKitHelper sharedGameKitHelper];
		gkHelper.delegate = self;
        [gkHelper authenticateLocalPlayer];
        [self scheduleOnce:@selector(showMatchmaking:) delay:0.0f];
        online = TRUE;

    }
    else if(type == GKPeerPickerConnectionTypeNearby)
    {
        bluetooth = true;
    }
    
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
    GKSession *session = [[GKSession alloc] initWithSessionID:kSessionID displayName:nil sessionMode:GKSessionModePeer];
    return session;
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {
    // Remember the current peer.
    self.gamePeerId = peerID;  // copy
    
    // Make sure we have a reference to the game session and it is set up
    self.gameSession = session; // retain
    self.gameSession.delegate = self;
    [self.gameSession setDataReceiveHandler:self withContext:NULL];
    
    // Done with the Peer Picker so dismiss it.
    [picker dismiss];
    picker.delegate = nil;
    
    // Start Multiplayer game by entering a cointoss state to determine who is server/client.
    self.gameState = kStateMultiplayerCointoss;
}


#pragma mark Session Related Methods

//
// invalidate session
//
- (void)invalidateSession:(GKSession *)session {
    if(session != nil) {
        [session disconnectFromAllPeers];
        session.available = NO;
        [session setDataReceiveHandler: nil withContext: NULL];
        session.delegate = nil;
    }
}

#pragma mark GKSessionDelegate Methods

// we've gotten a state change in the session
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    if(self.gameState == kStatePicker) {
        return;             // only do stuff if we're in multiplayer, otherwise it is probably for Picker
    }
    
    if(state == GKPeerStateDisconnected) {
        // We've been disconnected from the other peer.
        
        // Update user alert or throw alert if it isn't already up
        NSString *message = [NSString stringWithFormat:@"Could not reconnect with %@.", [session displayNameForPeer:peerID]];
        if((self.gameState == kStateMultiplayerReconnect) && self.connectionAlert && self.connectionAlert.visible) {
            self.connectionAlert.message = message;
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lost Connection" message:message delegate:self cancelButtonTitle:@"End Game" otherButtonTitles:nil];
            self.connectionAlert = alert;
            [alert show];
        }
        
        // go back to start mode
        self.gameState = kStateStartGame;
    }
}

- (void)setGameState:(NSInteger)newState {
    if(newState == kStateStartGame) {
        if(self.gameSession) {
            // invalidate session and release it.
            [self invalidateSession:self.gameSession];
            self.gameSession = nil;
        } 
    }
    
    gameState = newState;
}

-(void) session:(GKSession *)session didFailWithError:(NSError *)error
{
	CCLOG(@"match:didFailWithError");
	[self setLastError:error];
}
-(void) setLastError:(NSError*)error
{
	lastError = error.copy;
	if (lastError != nil)
	{
		NSLog(@"GameKitHelper ERROR: %@", lastError.userInfo.description);
	}
}
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    CCLOG(@"Receiving data with Bluetooth...");
    [self onReceivedData:data fromPlayer:peer];
}

-(void) sendNetworkPacket:(GKSession *)session :(NSMutableArray*) data sizeInBytes:(NSUInteger)sizeInBytes
{
    CCLOG(@"Sending data with Bluetooth...");
    NSError* error = nil;
    NSData *packet = [NSKeyedArchiver archivedDataWithRootObject:data];
    [session sendDataToAllPeers:packet withDataMode:GKSendDataUnreliable error:&error];
    [self setLastError:error];
}




@end







