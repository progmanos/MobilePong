//
//  MultiplayerLayer.h
//  PongT2
//
//  Created by Shawney Moore on 3/18/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Ball.h"
#import "Player.h"
#import "Constants.h"
#import "GameKitHelper.h"
#import "PauseScene.h"

//@end

@interface MultiplayerLayer : CCLayer<GameKitHelperProtocol, GKPeerPickerControllerDelegate, GKSessionDelegate, UIAlertViewDelegate>{
    
    NSInteger gameState;
    NSInteger peerStatus;
    
    // networking
    GKSession       *gameSession;
    int             gameUniqueID;
    int             gamePacketNumber;
    NSString        *gamePeerId;
    
    GKPeerPickerController*		myPicker;
    
    UIAlertView     *connectionAlert;
    UIAlertView     *pauseAlert;
    UIAlertView     *gameOverAlert;
    
    int times;
    Ball *ball;
    Player *player;
    Player *opponent;
    CCLabelTTF *OpponentScoreLabel;
    CCLabelTTF *playerscoreLabel;
    CCLabelTTF *timeLabel;
    CCLabelTTF *countdownLabel;
    CCLabelTTF *winnerLabel;
    ccTime totalTime;
    ccTime disconnectTime;
    NSString *winner;
    NSUserDefaults *prefs;
    NSInteger *currhighscore;
    NSInteger *currentscore;
    BOOL playerScored;
    BOOL gameOverViewDisplayed;
    CCMenuItemImage* pauseButton;
    CCMenu* menu;
    CGSize screenSize;
    
    GameKitHelper* gkHelper;
    
    
    BOOL player1;
    BOOL player2;
    BOOL playerDetermined;
    BOOL opponentRecRandNum;
    BOOL bluetooth;
    BOOL online;
    BOOL createdConnection;
    int ournumber;
    int opponentnumber;
    
    int oneThirdOfPlayerPaddle;
    int oneThirdOfOpponentPaddle;
    
    CCLabelTTF *whichPlayerLabel;
    
    NSError* lastError;
    
    NSMutableArray* myData;
    
}

@property(nonatomic) NSInteger      gameState;
@property(nonatomic) NSInteger      peerStatus;

@property(nonatomic, retain) GKSession *gameSession;
@property(nonatomic, copy)   NSString *gamePeerId;

@property(nonatomic, retain) UIAlertView *connectionAlert;

@property (nonatomic, readonly) NSError* lastError;
-(id) init;
-(void)multiPlayerGame;
-(void) checkCollisionWithPlayer;
-(void)checkCollisionWithOpponent;

- (void)playerReset;
-(void) sendNetworkPacket:(GKSession *)session :(NSMutableArray*) data sizeInBytes:(NSUInteger)sizeInBytes;
@end
