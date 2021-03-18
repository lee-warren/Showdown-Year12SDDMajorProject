//
//  MenuScreen.h
//  RedBallSpriteKit
//
//  Created by Lee Warren on 20/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "EnemyClass.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate> {
    
    SKSpriteNode *ground;
    NSString *mainFont;
    SKColor *mainFontColour;
    SKColor *livesFontColour;

    SKSpriteNode *player;
    SKSpriteNode *playerPhysicsContact;
    int playerSpeed;
    
    SKSpriteNode *bullet;
    SKSpriteNode *bulletBody;
    int bulletDelayCounter;
    int bulletDelay;
    
    EnemyClass *enemy;
    SKSpriteNode *enemyBody;
    int enemySpeed;
    int enemyDelayCounter;
    int enemyDelay;
    
    NSMutableArray *allEnemies;
    
    int score;
    SKLabelNode *scoreLabel;
    SKLabelNode *scoreCounterThing;

    SKSpriteNode *explosion;
    
    SKLabelNode *livesLabel;
    int lives;
    
    
    SKSpriteNode *tree;
    
    SKSpriteNode *portal;
    SKAction *fadeAndReappear;
    int portalDelayCounter;
    int portalDelay;
    


}

@end
