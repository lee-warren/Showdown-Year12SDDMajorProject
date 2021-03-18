//
//  GameOverScene.m
//  MajorProject
//
//  Created by Lee Warren on 20/05/2016.
//  Copyright © 2016 Lee Warren. All rights reserved.
//

#import "OptionsScene.h"
#import "MenuScene.h"

@implementation OptionsScene


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor colorWithRed:37/255.0f green:37/255.0f blue:37/255.0f alpha:1.0f];
    
    
    optionsTemplate = [SKSpriteNode spriteNodeWithImageNamed:@"OptionsScreenTemplate"];
    optionsTemplate.position = CGPointMake(self.size.width/2 ,self.size.height/2);
    optionsTemplate.size = CGSizeMake(self.size.width, self.size.height);
    [self addChild:optionsTemplate];
}

-(void)mouseUp:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    
    SKScene *menuScene  = [[MenuScene alloc] initWithSize:self.size];
    SKTransition *doors = [SKTransition fadeWithDuration:1];
    [self.view presentScene:menuScene transition:doors];
    
}


@end
