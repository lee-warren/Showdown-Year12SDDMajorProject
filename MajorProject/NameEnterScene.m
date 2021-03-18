//
//  GameScene.m
//  MajorProject
//
//  Created by Lee Warren on 1/03/2016.
//  Copyright (c) 2016 Lee Warren. All rights reserved.
//

#import "NameEnterScene.h"
#import <AVFoundation/AVFoundation.h>



@implementation NameEnterScene


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    //highscore stuff
    defaults = [NSUserDefaults standardUserDefaults];
    
    //use to clear nsuserdafaults:
        //[[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];

    
    self.backgroundColor = [SKColor colorWithRed:37/255.0f green:37/255.0f blue:37/255.0f alpha:1.0f];
    
    mainFont = @"Carnivalee Freakshow";
    mainFontColour = [SKColor colorWithRed:91/255.0f green:72/255.0f blue:56/255.0f alpha:1.0f];

   }

-(void)mouseDown:(NSEvent *)theEvent {
    /* Called when a mouse click occurs */
    
    /*
     enemy = [self enemy];
     [self addChild:enemy];
     [allEnemies addObject:enemy]; //adds the enemies to an array so they can be accesed later to move them all
     */
    
}

- (void)mouseMoved:(NSEvent *)theEvent {
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    
}

@end
