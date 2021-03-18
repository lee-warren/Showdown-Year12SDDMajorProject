//
//  GameOverScene.m
//  MajorProject
//
//  Created by Lee Warren on 20/05/2016.
//  Copyright © 2016 Lee Warren. All rights reserved.
//

#import "HighscoreScene.h"

@implementation HighscoreScene


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed:37/255.0f green:37/255.0f blue:37/255.0f alpha:1.0f];
    
    
    gameOverTemplate = [SKSpriteNode spriteNodeWithImageNamed:@"GameOverTemplate"];
    gameOverTemplate.position = CGPointMake(self.size.width/2 ,self.size.height/2);
    gameOverTemplate.size = CGSizeMake(self.size.width, self.size.height);
    [self addChild:gameOverTemplate];
}

@end
