//
//  Constants.h
//  PongT2
//
//  Created by Rashad on 2/25/13.
//
//

#ifndef PongT2_Constants_h
#define PongT2_Constants_h

#define MAX_BALL_SPEED 6
#define MIN_BALL_SPEED 4
#define PADDLE_COLLISION_DIVIDER 21

typedef enum {
    Level_One = 1,
    Level_Two = 2,
    Level_Three = 3
} GameLevel;

typedef enum  {
    User = 0,
    Opponent
}TypeofPlayer;
BOOL multiplayer;
NSString* name;
BOOL playerConnected;
BOOL initialPosition;


#endif
