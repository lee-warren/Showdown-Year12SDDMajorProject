//
//  GameScene.h
//  MajorProject
//

//  Copyright (c) 2016 Lee Warren. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "EnemyClass.h"

@interface MenuScene : SKScene <SKPhysicsContactDelegate> {
    
    SKSpriteNode *gameTitle;
    
    SKSpriteNode *playButton;
    SKSpriteNode *highscoreButton;
    SKSpriteNode *optionsButton;
    
    CGSize buttonSmall;
    CGSize buttonLarge;
    
    SKLabelNode *livesLabel;
    int lives;
    
}

@end
