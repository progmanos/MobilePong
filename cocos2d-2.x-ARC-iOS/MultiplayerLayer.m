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

@implementation MultiplayerLayer
-(id) init
{
    if ((self = [super init]))
    {
        countdowntostart = 5;
        opponentnumber = 0;
        ournumber = 0;
        player1=FALSE;
        player2=FALSE;
        playerDetermined=FALSE;
        initialPosition=FALSE;
        playerConnected=FALSE;
        playerScored=FALSE;
        randNumberReceived = FALSE;
        gkHelper = [GameKitHelper sharedGameKitHelper];
		gkHelper.delegate = self;
        [gkHelper authenticateLocalPlayer];
        [self onAchievementsViewDismissed];
        
        countdown = [NSString stringWithFormat:@"TIME TO START: %d ", (int)countdowntostart];
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        self.isTouchEnabled = YES;
        
        // move this to a header file for use in other classes
        screenSize = [CCDirector sharedDirector].winSize;
        
        //sets background to court image
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        [self addChild:background z:0 tag:1];
        background.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        
        pauseButton = [CCMenuItemImage itemFromNormalImage:@"pausebutton.png" selectedImage:@"pause.png" target:self selector:@selector(pauseButtonTapped:)];
        
        menu = [CCMenu menuWithItems:pauseButton, nil];
        menu.position = CGPointMake(screenSize.width/2, screenSize.height/2);
        [self addChild:menu z:0];
        
        //sets label for score of Opponent
        OpponentScoreLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:48];
        OpponentScoreLabel.position = ccp((screenSize.width/2), (screenSize.height - (screenSize.height/4)));
        OpponentScoreLabel.color = ccBLACK;
        [self addChild:OpponentScoreLabel z:0];
        
        //sets label for score of Opponent
        playerscoreLabel = [CCLabelTTF labelWithString:@" " fontName:@"Marker Felt" fontSize:48];
        playerscoreLabel.position = ccp((screenSize.width/2), (screenSize.height/4));
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
        countdownLabel = [CCLabelTTF labelWithString:@"8" fontName:@"Marker Felt" fontSize:12];
        countdownLabel.position = ccp(35, 5);
        [self addChild:countdownLabel z:0];
        [countdownLabel setString:(countdown)];
       
        
        //sets label for which player
        whichPlayerLabel = [CCLabelTTF labelWithString:@"8" fontName:@"Marker Felt" fontSize:12];
        whichPlayerLabel.position = ccp(200, 5);
        [self addChild:whichPlayerLabel z:0];
        [whichPlayerLabel setString:(@"undetermined")];
        
        
        //creates ball, player, and AI player
        ball = [Ball ballWithParentNode:self];
        player = [Player playerWithParentNode:self];
        opponent = [Player playerWithParentNode:self];
        
        //sets initial position of player & Opponent
        [player setPosition:CGPointMake(screenSize.width / 2, 20.0)];
        [opponent setPosition:CGPointMake(screenSize.width/2, (screenSize.height - 20))];
        
        //initialize player velocity
        [player setVelocity:(5)];
        
        [self scheduleUpdate];
        
        
    }
	
    return self;
}


//returns to main menu..still need to implement actual pause button
- (void)pauseButtonTapped: (id)sender {
    [[CCDirector sharedDirector] popScene];
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



-(void) checkCollisionWithPlayer
{
    //Checks collison with player
    if([ball tipOfBall] <= [player tipOfPaddle] && [ball tipOfBall] >= [player tipOfPaddle]-5)
        if([ball rightOfBall] >= [player leftOfPaddle] && [ball leftOfBall] <= [player rightOfPaddle])
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"bounce.wav"];
            //Checks segment A -- furthest left segment
            if([player inSegmentA:([ball tipOfBallX]) leftPos:([ball leftOfBall]) rightPos:([ball rightOfBall])])
                [ball updateVelocityA];
            
            //Checks segment B -- second left segment
            else if([player inSegmentB:([ball tipOfBallX]) leftPos:([ball leftOfBall]) rightPos:([ball rightOfBall])])
                [ball updateVelocityB];
            
            //Checks segment D -- second right segment
            else if([player inSegmentD:([ball tipOfBallX]) leftPos:([ball leftOfBall]) rightPos:([ball rightOfBall])])
                [ball updateVelocityD];
            
            //Checks segment E -- second right segment
            else if([player inSegmentE:([ball tipOfBallX]) leftPos:([ball leftOfBall]) rightPos:([ball rightOfBall])])
                [ball updateVelocityE];
            
            //Center segment
            else
                [ball updateVelocityC];        }
}

-(void)checkCollisionWithOpponent
{
    //Checks collision with AI
    if([ball opponentTipOfBall] >= [opponent OpponentTipOfPaddle] && [ball opponentTipOfBall] <= [opponent OpponentTipOfPaddle]+5)
        if([ball rightOfBall] >= [opponent leftOfPaddle] && [ball leftOfBall] <= [opponent rightOfPaddle])
            
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"bounce.wav"];
            //Checks segment A -- furthest left segment
            if([opponent inSegmentA:([ball tipOfBallX]) leftPos:([ball leftOfBall]) rightPos:([ball     rightOfBall])])
                [ball updateVelocityA];
            
            //Checks segment B -- second left segment
            else if([opponent inSegmentB:([ball tipOfBallX]) leftPos:([ball leftOfBall]) rightPos:([ball rightOfBall])])
                [ball updateVelocityB];
            
            //Checks segment C -- second right segment
            else if([opponent inSegmentD:([ball tipOfBallX]) leftPos:([ball leftOfBall]) rightPos:([ball rightOfBall])])
                [ball updateVelocityD];
            
            //Checks segment E -- furthest right segment
            else if([opponent inSegmentE:([ball tipOfBallX]) leftPos:([ball leftOfBall]) rightPos:([ball    rightOfBall])])
                [ball updateVelocityE];
            
            //Checks segment C -- center segment
            else
                [ball updateVelocityC];
        }
}

-(void)checkPlayerScore
{
    //Player score
    if([ball getYpos] >= 496 && !playerScored)
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

-(void)pickAndSendRandomNumber
{
    CCLOG(@"pick and send random number");
    ournumber = arc4random()%100;
    [self sendRandomNumber:ournumber];
    CCLOG(@"Sending number.... %i", ournumber);
}


//set initial position of each player
-(void)initialize
{
    //before game starts, player one send their ball position to player
    if(player1)
    {
        //(!positionReceived)
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

-(void) update:(ccTime)delta
{
    
    //Update countdown
    [countdownLabel setString:[NSString stringWithFormat:@"%d", (int)countdowntostart]];

    
    //check that a match has been made
    if([gkHelper currentMatch]!=nil)
    {
        
        //determine which player is which
        if(!playerDetermined)
           [self pickAndSendRandomNumber];
        
        //set initial position of each player after players are decided
        if(!initialPosition && playerDetermined)
            [self initialize];
        
        //player one sends countdown to player 2
        if(countdowntostart>-1 && playerDetermined)
           if(player1)
            {
                [self sendCountdown:countdowntostart];
                usleep(100000);
            }
        
        //if countdown has ended and initial position has been set, game begins
        if(initialPosition && countdowntostart <= 0)
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
    
    [self checkCollisionWithOpponent];
    [self checkCollisionWithPlayer];
    [self checkPlayerScore];
    [self updateScore];
    [self checkOpponentScore];
    
    if(player1)
    {
        [self sendBallPosition:[ball getPosition]];
        [ball moveBall];
    }
    if([ball getPosition].y <= screenSize.height/2)
    {
        
        
    }
  
    //prevents scoring from incrementing more than once
    if([ball getYpos] > 10 && [ball getYpos] < 400)
        playerScored = FALSE;
    
    //updates time
    [timeLabel setString:[NSString stringWithFormat:@"%d", (int)totalTime]];

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
    [self performSelector:@selector(newGame) withObject:nil afterDelay:3.0];
}

//Displays "Congratulations, you won" in red for 3 seconds. Then starts a new game
-(void) playerWinsGame
{
    winner = @"Congratulations\n you won!";
    winnerLabel.color = ccGREEN;
    [winnerLabel setString:(winner)];
    
   
    [self performSelector:@selector(newGame) withObject:nil afterDelay:3.0];
    
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
        case kPacketTypePosReceived:
		{
			SPosReceivedPacket* posRecPacket = (SPosReceivedPacket*)basePacket;
            positionReceived = TRUE;
			break;
		}
		case kPacketTypeBallPosition:
		{
			SBallPositionPacket* positionPacket = (SBallPositionPacket*)basePacket;
			CCLOG(@"\tposition = (%.1f, %.1f)", positionPacket->position.x, positionPacket->position.y);
            CGPoint temp = CGPointMake((screenSize.width - positionPacket->position.x), (screenSize.height - positionPacket->position.y));
            if(!player1)
            {
                //
                //positionReceived = TRUE;
                //[self sendPosReceived:positionReceived];
            }
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
			CCLOG(@"\tPADDLEPOS = %i", ppositionPacket->paddleposition);
            [opponent setXPosition: ppositionPacket->paddleposition];
			
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
            }
            else if(ournumber<opponentnumber)
            {
                [whichPlayerLabel setString:(@"PLAYER 2")];
                player2 = TRUE;
                player1 = FALSE;
                playerDetermined = TRUE;
                CCLOG(@"Player2");
            }
			break;
		}
        case kPacketTypeCountdown:
		{
			SCountdownPacket* ctdownPacket = (SCountdownPacket*)basePacket;
			CCLOG(@"\tCountdown = %i", ctdownPacket->countdown);
			countdowntostart = ctdownPacket->countdown;
            if(player1)
                countdowntostart--;
			if (playerID != [GKLocalPlayer localPlayer].playerID)
			{
                
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
	if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
	{
		//bogusScore++;
		
		SScorePacket packet;
		packet.type = kPacketTypeScore;
		//packet.score = bogusScore;
		
		[[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
	}
}

//send ball position
-(void) sendBallPosition:(CGPoint)ballPos
{
	if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
	{
		SBallPositionPacket packet;
		packet.type = kPacketTypeBallPosition;
		packet.position = ballPos;
		
		[[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
	}
}

//send velocity
-(void) sendVelocity:(CGPoint)ballVel
{
	if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
	{
		SVelocityPacket packet;
		packet.type = kPacketTypeVelocity;
		packet.velocity = ballVel;
		
		[[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
	}
}

-(void) sendPaddlePosition:(CGFloat)paddleX
{
	if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
	{
		SPaddlePositionPacket packet;
		packet.type = kPacketTypePaddlePosition;
        packet.paddleposition = paddleX;
		
		[[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
	}
}

-(void) sendRandomNumber:(int)ranNumber
{
    CCLOG(@"sending number...");
	if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
	{
		SRandomNumberPacket packet;
		packet.type = kPacketTypeRandomNumber;
        packet.randomNumber = ranNumber;
		
		[[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
	}
}

-(void) sendCountdown:(int)ctdown
{
	if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
	{
        countdowntostart--;
        SCountdownPacket packet;
        packet.type = kPacketTypeCountdown;
        packet.countdown = ctdown;
		
		[[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
	}
}

-(void) sendPosReceived:(BOOL)posRec
{
	if ([GameKitHelper sharedGameKitHelper].currentMatch != nil)
	{
        SPosReceivedPacket packet;
        packet.type = kPacketTypePosReceived;
        packet.didReceivePos = posRec;
        
		[[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:&packet sizeInBytes:sizeof(packet)];
	}
}
@end





