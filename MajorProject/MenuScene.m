//
//  GameScene.m
//  MajorProject
//
//  Created by Lee Warren on 1/03/2016.
//  Copyright (c) 2016 Lee Warren. All rights reserved.
//

#import "MenuScene.h"
#import "EnemyClass.h"
#import <AVFoundation/AVFoundation.h>
#import "GameScene.h"



@implementation MenuScene


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed:237/255.0f green:225/255.0f blue:170/255.0f alpha:1.0f];
    
    //declaring variables:
    buttonSmall = CGSizeMake(240, 72);
    buttonLarge = CGSizeMake(333, 100);
    //end of declaring
    
    gameTitle = [SKSpriteNode spriteNodeWithImageNamed:@"GameTitle"];
    gameTitle.color = [SKColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    gameTitle.position = CGPointMake(self.size.width/2 ,self.size.height/2 + self.size.height/5);
    gameTitle.size = CGSizeMake(1000, 750);
    [self addChild:gameTitle];
    
    playButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonPlay"];
    playButton.size = buttonSmall;
    playButton.color = [SKColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    playButton.position = CGPointMake(self.size.width/6 ,self.size.height/5);
    
    [self addChild:playButton];
    
    highscoreButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonHighscore"];
    highscoreButton.size = buttonSmall;
    highscoreButton.color = [SKColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    highscoreButton.position = CGPointMake(playButton.position.x + buttonLarge.width ,self.size.height/5);
    
    [self addChild:highscoreButton];
    
    optionsButton = [SKSpriteNode spriteNodeWithImageNamed:@"ButtonOptions"];
    optionsButton.size = buttonSmall;
    optionsButton.color = [SKColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    optionsButton.position = CGPointMake(highscoreButton.position.x + buttonLarge.width ,self.size.height/5);
    
    [self addChild:optionsButton];
    
    
}

-(void)mouseDown:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    CGPoint location = [theEvent locationInNode:self];
    NSLog(@"%i", location);
    
    if ((location.x > playButton.position.x - playButton.size.width/2 -self.frame.size.width/100) && (location.x < playButton.position.x +playButton.size.width/2 + self.frame.size.width/100) && ( location.y > playButton.position.y -playButton.size.height/2 -self.frame.size.width/100) && (location.y < playButton.position.y + playButton.size.height/2 +self.frame.size.width/100)) { //clicked on play agin button
        
        playButton.colorBlendFactor = 0.4;
        
    } else if ((location.x > highscoreButton.position.x - highscoreButton.size.width/2 -self.frame.size.width/100) && (location.x < highscoreButton.position.x +highscoreButton.size.width/2 + self.frame.size.width/100) && ( location.y > highscoreButton.position.y -highscoreButton.size.height/2 -self.frame.size.width/100) && (location.y < highscoreButton.position.y + highscoreButton.size.height/2 +self.frame.size.width/100)) { //clicked on highscoreButton
        
        highscoreButton.colorBlendFactor = 0.4;
        
    } else if ((location.x > optionsButton.position.x - optionsButton.size.width/2 -self.frame.size.width/100) && (location.x < optionsButton.position.x +optionsButton.size.width/2 + self.frame.size.width/100) && ( location.y > optionsButton.position.y -optionsButton.size.height/2 -self.frame.size.width/100) && (location.y < optionsButton.position.y + optionsButton.size.height/2 +self.frame.size.width/100)) { //clicked on highscoreButton
        
        optionsButton.colorBlendFactor = 0.4;
        
    }
    
    
}

-(void)mouseUp:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    CGPoint location = [theEvent locationInNode:self];
    NSLog(@"%i", location);
    
    if ((location.x > playButton.position.x - playButton.size.width/2 -self.frame.size.width/100) && (location.x < playButton.position.x +playButton.size.width/2 + self.frame.size.width/100) && ( location.y > playButton.position.y -playButton.size.height/2 -self.frame.size.width/100) && (location.y < playButton.position.y + playButton.size.height/2 +self.frame.size.width/100)) { //clicked on play agin button
        
        SKScene *gameScene  = [[GameScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition crossFadeWithDuration:1];
        [self.view presentScene:gameScene transition:doors];
        
    } else if ((location.x > highscoreButton.position.x - highscoreButton.size.width/2 -self.frame.size.width/100) && (location.x < highscoreButton.position.x +highscoreButton.size.width/2 + self.frame.size.width/100) && ( location.y > highscoreButton.position.y -highscoreButton.size.height/2 -self.frame.size.width/100) && (location.y < highscoreButton.position.y + highscoreButton.size.height/2 +self.frame.size.width/100)) { //clicked on highscoreButton
        
    } else if ((location.x > optionsButton.position.x - optionsButton.size.width/2 -self.frame.size.width/100) && (location.x < optionsButton.position.x +optionsButton.size.width/2 + self.frame.size.width/100) && ( location.y > optionsButton.position.y -optionsButton.size.height/2 -self.frame.size.width/100) && (location.y < optionsButton.position.y + optionsButton.size.height/2 +self.frame.size.width/100)) { //clicked on optionsButton
        
    }
    
    playButton.colorBlendFactor = 0;
    highscoreButton.colorBlendFactor = 0;
    optionsButton.colorBlendFactor = 0;
    
    
}

- (void)mouseMoved:(NSEvent *)theEvent {
    
    CGPoint location = [theEvent locationInNode:self];
    
    if ((location.x > playButton.position.x - playButton.size.width/2 -self.frame.size.width/100) && (location.x < playButton.position.x +playButton.size.width/2 + self.frame.size.width/100) && ( location.y > playButton.position.y -playButton.size.height/2 -self.frame.size.width/100) && (location.y < playButton.position.y + playButton.size.height/2 +self.frame.size.width/100)) { //clicked on play agin button
        
        playButton.size = buttonLarge;
        
    } else {
        
        playButton.size = buttonSmall;
    }
    
    if ((location.x > highscoreButton.position.x - highscoreButton.size.width/2 -self.frame.size.width/100) && (location.x < highscoreButton.position.x +highscoreButton.size.width/2 + self.frame.size.width/100) && ( location.y > highscoreButton.position.y -highscoreButton.size.height/2 -self.frame.size.width/100) && (location.y < highscoreButton.position.y + highscoreButton.size.height/2 +self.frame.size.width/100)) { //clicked on highscoreButton
        
        highscoreButton.size = buttonLarge;
        
    } else {
        
        highscoreButton.size = buttonSmall;
    }
    
    if ((location.x > optionsButton.position.x - optionsButton.size.width/2 -self.frame.size.width/100) && (location.x < optionsButton.position.x +optionsButton.size.width/2 + self.frame.size.width/100) && ( location.y > optionsButton.position.y -optionsButton.size.height/2 -self.frame.size.width/100) && (location.y < optionsButton.position.y + optionsButton.size.height/2 +self.frame.size.width/100)) { //clicked on optionsButton
        
        optionsButton.size = buttonLarge;
        
    } else {
        
        optionsButton.size = buttonSmall;
    }
    
    
}


@end
