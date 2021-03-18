//
//  MenuScreen.h
//  RedBallSpriteKit
//
//  Created by Lee Warren on 20/07/2014.
//  Copyright (c) 2014 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "EnemyClass.h"

@interface TutorialScene : SKScene <SKPhysicsContactDelegate> {
    
    NSUserDefaults *defaults;
    
    NSMutableArray *names;
    NSString *currentName;
    
    NSMutableArray *highScores;
    int score;
    SKLabelNode *scoreLabel;
    SKLabelNode *scoreCounterThing;
    
    NSMutableArray *hitPercentages;
    int bulletShot;
    int bulletHit;
    float hitPercentage;
    
    int bombsShot;

    SKShapeNode *menuBar;
    
    SKSpriteNode *ground;
    NSString *mainFont;
    SKColor *mainFontColour;
    SKColor *livesFontColour;
    SKColor *bombCountFontColour;
    
    //SKShapeNode *menuBar;

    SKSpriteNode *player;
    SKSpriteNode *playerBulletStartPosition;
    SKSpriteNode *playerPhysicsContact;
    int playerSpeed;
    
    SKSpriteNode *bullet;
    SKSpriteNode *bulletBody;
    BOOL canShootBullet;
    
    int bombCount;
    SKLabelNode *bombCountLabel;
    SKSpriteNode *bomb;
    SKSpriteNode *explosion;
    BOOL canShootBomb;
    
    int bulletXPosition;
    int bulletYPosition;
    //int bulletDelayCounter;
    //int bulletDelay;
    int bulletSpeed;
    
    EnemyClass *enemy;
    SKSpriteNode *enemyBody;
    int enemySpeed;
    int enemyDelayCounter;
    int enemyDelay;
    
    NSMutableArray *allEnemies;

    SKSpriteNode *deadEnemy;
    
    SKLabelNode *livesLabel;
    int lives;
    
    SKSpriteNode *portal;
    SKAction *fadeAndReappear;
    int portalDelayCounter;
    int portalDelay;
    
    SKSpriteNode *crate;
    int crateDelayCounter;
    int crateDelay;
    
    //
    double soundEffectVolume;
    SKAction*   playZombieSound1;
    SKAction*   playZombieSound2;
    SKAction*   playZombieSound3;
    SKAction*   playBombSound;

}

//sound files
@property (strong, nonatomic) SKAction *zombieDeathSound1;
@property (strong, nonatomic) SKAction *zombieDeathSound2;
@property (strong, nonatomic) SKAction *zombieDeathSound3;


@end
