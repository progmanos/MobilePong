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
#import "NetworkPackets.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "MultiplayerLayer.h"


//
// various states the game can get into
//
typedef enum {
    kStateStartGame,
    kStatePicker,
    kStateMultiplayer,
    kStateMultiplayerCointoss,
    kStateMultiplayerReconnect
} gameStates;

// GameKit Session ID for app
#define kSessionID @"PONG"

#pragma mark -

@interface MultiplayerLayer(Private)
-(void) setLastError:(NSError*)error;
@end

@implementation MultiplayerLayer

@synthesize gameState, peerStatus, gameSession, gamePeerId, connectionAlert, lastError;

-(id) init
{
    if ((self = [super init]))
    {
        bluetooth = TRUE;
        gameSession = nil;
        gamePeerId = nil;
        
        NSString *uid = [[UIDevice currentDevice] uniqueIdentifier];
        
        gameUniqueID = [uid hash];
        
        
        self.gameState = kStateStartGame; // Setting to kStateStartGame does a reset of players, scores, etc.
        [self startPicker];
 
        
        
        endMultiPlayer = FALSE;
        gamePaused = FALSE;
        times = 0;
        countdowntostart = 5;
        opponentnumber = 0;
        ournumber = arc4random()%100;
        opponentRecRandNum = FALSE;
        player1=FALSE;
        player2=FALSE;
        playerDetermined=FALSE;
        initialPosition=FALSE;
        playerConnected=FALSE;
        playerScored=FALSE;
        
        //countdown = [NSString stringWithFormat:@"TIME TO START: %d ", (int)countdowntostart];
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
        timeLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:24];
        timeLabel.color = ccRED;
        timeLabel.position = ccp(30, 30);
        [self addChild:timeLabel z:1];
        
        //sets label for winner of the game
        winnerLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:48];
        winnerLabel.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:winnerLabel z:2];
        
        //sets label for countdown
        countdownLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:12];
        countdownLabel.position = ccp(35, 5);
        [self addChild:countdownLabel z:0];
        //[countdownLabel setString:(countdown)];
       
        
        //sets label for which player
        whichPlayerLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:12];
        whichPlayerLabel.position = ccp(200, 5);
        [self addChild:whichPlayerLabel z:0];
        [whichPlayerLabel setString:(@" ")];
        
        playerPauseLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:24];
        playerPauseLabel.position = ccp(screenSize.width/2, screenSize.height/2 + 40);
        playerPauseLabel.color = ccWHITE;
        [self addChild:playerPauseLabel z:2];
        
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
        
        [self scheduleUpdate];
        
        
    }
	
    return self;
}


- (void)pauseButtonTapped: (id)sender {
    
    gamePaused = TRUE;
    [[CCDirector sharedDirector] pushScene:[PauseScene node]];
    [self pauseReceived:TRUE];
     }

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

-(void) movePlayerLeft
{
    [player moveLeft];
    
    //sends paddle position every time paddle moves left
    [self sendPaddlePosition:[player getXpos]];
}

-(void) movePlayerRight
{
    [player moveRight];
    
    //sends paddle position every time the paddle moves rights
    [self sendPaddlePosition:[player getXpos]];
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
    
    if (playerCollisionSeg >= SegmentA && playerCollisionSeg <= SegmentC && [ball tipOfBall] >= ([player tipOfPaddle]-5) && [ball tipOfBall] <= ([player tipOfPaddle]) && ball.didCollide == FALSE) {
        ball.velocity = [ball reflectStraight:CGPointMake(0,1)];
        ball.didCollide = TRUE;
    }
    else {
        int opponentCollisionSeg = [opponent GetCollisionSegment:[ball tipOfBallX] leftPos:[ball leftOfBall] rightPos:[ball rightOfBall]];
        if (opponentCollisionSeg >= SegmentA && opponentCollisionSeg <= SegmentC && [ball opponentTipOfBall] <= ([opponent tipOfPaddle]+5) && [ball opponentTipOfBall] >= ([opponent tipOfPaddle])) {
            ball.velocity = [ball reflectStraight:CGPointMake(0,-1)];
            ball.didCollide = TRUE;
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
        [[SimpleAudioEngine sharedEngine] playEffect:@"correct.wav"];
        
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
        [self sendBallPosition:[ball getPosition]];
        initialPosition = TRUE;
    }
    if(player2)
    {
        //[ball setVelocity:CGPointMake(-[ball getVelocity].x, -[ball getVelocity].y)];
        initialPosition = TRUE;
    }
    
    usleep(100000);
}

-(BOOL) currentMatch
{
    if(!bluetooth)
        if([gkHelper currentMatch] != nil)
            return TRUE;
    if(bluetooth)
        if(gameSession.available)
            return TRUE;
    return FALSE;
}

-(void) update:(ccTime)delta
{
    [playerPauseLabel setString:(@" ")];
    if(endMultiPlayer && !bluetooth)
        [gkHelper disconnectCurrentMatch];
    
    //check that a match has been made
    if([self currentMatch])
    {
        
        //determine which player is which
        if(!opponentRecRandNum)
        {
            [self sendRandomNumber:ournumber];
            usleep(10000);
        }
        
        //set initial position of each player after players are decided
        if(!initialPosition && playerDetermined && opponentRecRandNum)
            [self initialize];
        
        
        
        //if countdown has ended and initial position has been set, game begins
        if(initialPosition)
        {
            [self playGame:delta];
        }
    }
    else
        playerConnected = FALSE;
     
}


-(void)playGame:(ccTime)delta
{
    playerConnected = TRUE;
    //time in seconds
    totalTime += delta;
    
    [self checkCollision];
    [self checkPlayerScore];
    [self checkOpponentScore];
    [self updateScore];
    [self checkWin];
    
    if(player1)
    {
        [self sendBallPosition:[ball getPosition]];
        [ball moveBall];
    }
  
    //prevents scoring from incrementing more than once
    if([ball getYpos] > 10 && [ball getYpos] < 400)
        playerScored = FALSE;
    
    //updates time
    [timeLabel setString:[NSString stringWithFormat:@"%d", (int)totalTime]];
    if(!gamePaused)
        [self pauseReceived:FALSE];

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

//Displays "Sorry, you lose" in red for 3 seconds. Then starts a new game
-(void) AIwinsGame
{
    
    winner = @"Sorry, you lose";
    winnerLabel.color = ccRED;
    [winnerLabel setString:(winner)];
    [gkHelper disconnectCurrentMatch];
   // [self performSelector:@selector(newGame) withObject:nil afterDelay:3.0];
}

//Displays "Congratulations, you won" in red for 3 seconds. Then starts a new game
-(void) playerWinsGame
{
    winner = @"Congratulations\n you won!";
    winnerLabel.color = ccGREEN;
    [winnerLabel setString:(winner)];
    [gkHelper disconnectCurrentMatch];
    
   
  //  [self performSelector:@selector(newGame) withObject:nil afterDelay:3.0];
    
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
	
//	gkHelper = [GameKitHelper sharedGameKitHelper];
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
		
//		GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
		[gkHelper showMatchmakerWithRequest:request];
	}
}

-(void) onAchievementsViewDismissed
{
	CCLOG(@"onAchievementsViewDismissed");
    
	// add small delay because leaderboard view must be fully moved outside the screen
	// before a new view can be shown
	[self scheduleOnce:@selector(showMatchmaking:) delay:2.0f];
}


// TM16: handles receiving of data, determines packet type and based on that executes certain code
-(void) onReceivedData:(NSData*)data fromPlayer:(NSString*)playerID
{
	SBasePacket* basePacket = (SBasePacket*)data.bytes;
	CCLOG(@"onReceivedData: %@ fromPlayer: %@ - Packet type: %i", data, playerID, basePacket->type);
	
	switch (basePacket->type)
	{

		case kPacketTypeScore:
		{
			SScorePacket* scorePacket = (SScorePacket*)basePacket;
			CCLOG(@"\tscore = %i", scorePacket->score);
			break;
		}
        case kPacketTypeRanNumReceived:
		{
			SRanNumReceivedPacket* posRecPacket = (SRanNumReceivedPacket*)basePacket;
            opponentRecRandNum = TRUE;
			break;
		}
		case kPacketTypeBallPosition:
		{
			SBallPositionPacket* positionPacket = (SBallPositionPacket*)basePacket;
			CCLOG(@"\tposition = (%.1f, %.1f)", positionPacket->position.x, positionPacket->position.y);
            CGPoint temp = CGPointMake((screenSize.width - positionPacket->position.x), (screenSize.height - positionPacket->position.y));
            [ball setPosition:temp];
            
			if (playerID != [GKLocalPlayer localPlayer].playerID)
			{
                
			}
			break;
		}
        case kPacketTypeVelocity:
		{
			SVelocityPacket* velocityPacket = (SVelocityPacket*)basePacket;
			CCLOG(@"\tvelocity = (%.1f, %.1f)", velocityPacket->velocity.x, velocityPacket->velocity.y);
            CGPoint temp = CGPointMake(-(velocityPacket->velocity.x), -(velocityPacket->velocity.y));
			[ball setVelocity:temp];
            
			if (playerID != [GKLocalPlayer localPlayer].playerID)
			{
                
			}
			break;
		}
        case kPacketTypePaddlePosition:
		{
			SPaddlePositionPacket* ppositionPacket = (SPaddlePositionPacket*)basePacket;
			CCLOG(@"\tPADDLEPOS = %i", (int)ppositionPacket->paddleposition);
            [opponent setXPosition: (screenSize.width - ppositionPacket->paddleposition)];
			
			if (playerID != [GKLocalPlayer localPlayer].playerID)
			{
                
			}
			break;
		}
        case kPacketTypeRandomNumber:
		{
			SRandomNumberPacket* randNumPacket = (SRandomNumberPacket*)basePacket;
			CCLOG(@"\trecieved OPPONENT RandomNumer = %i", randNumPacket->randomNumber);
			opponentnumber = randNumPacket->randomNumber;
			if (playerID != [GKLocalPlayer localPlayer].playerID)
			{
                
			}
            if(ournumber > opponentnumber)
            {
                
                [whichPlayerLabel setString:(@"PLAYER 1")];
                player1 = TRUE;
                player2 = FALSE;
                playerDetermined = TRUE;
                CCLOG(@"Player1");
                [self sendRandNumReceived];
            }
            else if(ournumber<opponentnumber)
            {
                [whichPlayerLabel setString:(@"PLAYER 2")];
                player2 = TRUE;
                player1 = FALSE;
                playerDetermined = TRUE;
                CCLOG(@"Player2");
                [self sendRandNumReceived];
            }
            else
            {
                ournumber = arc4random()%100;
                [self sendRandomNumber:ournumber];
            }
			break;
		}
        case kPacketTypeCountdown:
		{
			SCountdownPacket* ctdownPacket = (SCountdownPacket*)basePacket;
			CCLOG(@"\tCountdown = %i", ctdownPacket->countdown);
			countdowntostart = ctdownPacket->countdown;
			if (playerID != [GKLocalPlayer localPlayer].playerID)
			{
                
			}
			break;
		}
        case kPacketTypePause:
		{
			SPausePacket* pausePacket = (SPausePacket*)basePacket;
            if(pausePacket->Pause)
            {
                if(player1)
                    [playerPauseLabel setString:(@"Player 2 has paused the game")];
                if(!player1)
                    [playerPauseLabel setString:(@"Player 1 has paused the game")];
                [[CCDirector sharedDirector] pause];
            }
                
            else
            {
                [playerPauseLabel setString:(@" ")];
                [[CCDirector sharedDirector] resume];
            }
			break;
		}
		default:
			CCLOG(@"unknown packet type %i", basePacket->type);
			break;
	}
}

// send score
-(void) sendScore
{
    CCLOG(@"Send Score Method");
    
    SScorePacket packet;
    packet.type = kPacketTypeScore;
    
    if(bluetooth)
      [self sendNetworkPacket:gameSession :&packet sizeInBytes:sizeof(packet)];

    
	if(!bluetooth)
        if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
            [[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
}

//send ball position
-(void) sendBallPosition:(CGPoint)ballPos
{
    CCLOG(@"Send Ball Position Method");
    
    SBallPositionPacket packet;
    packet.type = kPacketTypeBallPosition;
    packet.position = ballPos;
    
    if(bluetooth)
        [self sendNetworkPacket:gameSession :&packet sizeInBytes:sizeof(packet)];

    
	if(!bluetooth)
        if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
            [[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
}



//send velocity
-(void) sendVelocity:(CGPoint)ballVel
{
    CCLOG(@"Send Velocity Method");
    
    SVelocityPacket packet;
    packet.type = kPacketTypeVelocity;
    packet.velocity = ballVel;
    
    if(bluetooth)
           [self sendNetworkPacket:gameSession :&packet sizeInBytes:sizeof(packet)];
    
	if(!bluetooth)
       if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
           [[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
}

-(void) sendPaddlePosition:(CGFloat)paddleX
{
    CCLOG(@"Send Paddle Position Method");
    SPaddlePositionPacket packet;
    packet.type = kPacketTypePaddlePosition;
    packet.paddleposition = paddleX;
    
	if(bluetooth)
           [self sendNetworkPacket:gameSession :&packet sizeInBytes:sizeof(packet)];

    if(!bluetooth)
          if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
              [[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
}

-(void) sendRandomNumber:(int)ranNumber
{
    CCLOG(@"Send Rand Num");
    SRandomNumberPacket packet;
    packet.type = kPacketTypeRandomNumber;
    packet.randomNumber = ranNumber;
    CCLOG(@"sending number...");
    
    if(bluetooth)
        [self sendNetworkPacket:gameSession :&packet sizeInBytes:sizeof(packet)];

    if(!bluetooth)
        if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
            [[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
    
    
}

-(void) sendCountdown:(int)ctdown
{
    CCLOG(@"Send Countdown Method");
    
    SCountdownPacket packet;
    packet.type = kPacketTypeCountdown;
    packet.countdown = ctdown;
    
    if(bluetooth)
        [self sendNetworkPacket:gameSession :&packet sizeInBytes:sizeof(packet)];

    
    if(!bluetooth)
        if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
            [[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
}

-(void) sendRandNumReceived
{
    CCLOG(@"Send Random Number Method");
    
    SRanNumReceivedPacket packet;
    packet.type = kPacketTypeRanNumReceived;
    
    if(bluetooth)
        [self sendNetworkPacket:gameSession :&packet sizeInBytes:sizeof(packet)];
    
    if(!bluetooth)
        if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
            [[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];

}

-(void) pauseReceived:(BOOL)paused
{
    CCLOG(@"Pause Received Method");
    SPausePacket packet;
    packet.type = kPacketTypePause;
    packet.Pause = paused;
    
    if(bluetooth)
        [self sendNetworkPacket:gameSession :&packet sizeInBytes:sizeof(packet)];
    if(!bluetooth)
        if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
            [[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
}

#pragma mark Peer Picker Related Methods
-(void)startPicker {
    
    GKPeerPickerController*		picker;
	self.gameState = kStatePicker;			// we're going to do Multiplayer!
	
	picker = [[GKPeerPickerController alloc] init]; // note: picker is released in various picker delegate methods when picker use is done.
	picker.delegate = self;
    
    picker.connectionTypesMask = (GKPeerPickerConnectionTypeNearby |
                                  GKPeerPickerConnectionTypeOnline);
    [picker show]; // show the Peer Picker
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
        [self onAchievementsViewDismissed];
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
        
        // reset game here
        
        
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
    [self onReceivedData:data fromPlayer:peer];
}

-(void) sendNetworkPacket:(GKSession *)session :(void*) data sizeInBytes:(NSUInteger)sizeInBytes
{
    NSError* error = nil;
    NSData* packet = [NSData dataWithBytes:data length:sizeInBytes];
    [session sendDataToAllPeers:packet withDataMode:GKSendDataUnreliable error:&error];
    [self setLastError:error];
}


@end





