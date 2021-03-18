//
//  GameScene.m
//  MajorProject
//
//  Created by Lee Warren on 1/03/2016.
//  Copyright (c) 2016 Lee Warren. All rights reserved.
//

#import "GameScene.h"
#import "EnemyClass.h"
#import <AVFoundation/AVFoundation.h>
#import "GameOverScene.h"



@implementation GameScene

static const uint32_t playerCategory = 0x1 << 0;
static const uint32_t enemyCategory = 0x1 << 1;
static const uint32_t bulletCategory = 0x1 << 2;


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    // self.backgroundColor = [SKColor colorWithRed:237/255.0f green:225/255.0f blue:170/255.0f alpha:1.0f];
    
    self.physicsWorld.contactDelegate = self;
    //set gravity to zero:
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    
    
    self.backgroundColor = [SKColor colorWithRed:37/255.0f green:37/255.0f blue:37/255.0f alpha:1.0f];
    
    mainFont = @"Carnivalee Freakshow";
    mainFontColour = [SKColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f];
    livesFontColour = [SKColor colorWithRed:255/255.0f green:3/255.0f blue:3/255.0f alpha:1.0f];

    
    ground = [SKSpriteNode spriteNodeWithImageNamed:@"Ground"];
    ground.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    ground.zPosition = -1;
    [self addChild:ground];
    
    playerSpeed = 300;
    
    CGPoint location = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    player = [SKSpriteNode spriteNodeWithImageNamed:@"Player1.png"];
    
    player.position = location;
    player.scale = 0.5;
    player.zPosition = 2;
    
    //collision stuff
    playerPhysicsContact = [[SKSpriteNode alloc] initWithColor:([SKColor colorWithRed:0/255.0f green:158/255.0f blue:255/255.0f alpha:0.0f]) size:CGSizeMake(player.size.width, player.size.height)];
    playerPhysicsContact.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.height / 2];
    playerPhysicsContact.physicsBody.dynamic = NO;
    playerPhysicsContact.physicsBody.allowsRotation = YES;
    playerPhysicsContact.physicsBody.categoryBitMask = playerCategory;
    
    [player addChild:playerPhysicsContact];
    
    [self addChild:player];
    
    //player animation:
    NSMutableArray *playerTextures = [NSMutableArray arrayWithCapacity:8];
    
    for (int i = 1; i < 9; i++)
    {
        NSString *playerTextureName = [NSString stringWithFormat:@"Player%d.png", i];
        SKTexture *playerTexture =
        [SKTexture textureWithImageNamed:playerTextureName];
        [playerTextures addObject:playerTexture];
    }
    
    SKAction* playerAnimation = [SKAction animateWithTextures:playerTextures timePerFrame:0.1];
    
    SKAction *playerRepeat = [SKAction repeatActionForever:playerAnimation];
    [player runAction:playerRepeat];
     
    
    allEnemies = [[NSMutableArray alloc]init];
    
    //create the first enemy
    //enemy = [self enemy:CGPointMake(0, 0)];
    //[self insertChild:enemy atIndex: 0 ];
    //[allEnemies addObject:enemy];
    
    bulletDelay = 30;
    enemyDelay = 75;
    portalDelay = 250;
    
    lives = 5;
    livesLabel = [SKLabelNode labelNodeWithFontNamed:mainFont];
    livesLabel.text = [NSString stringWithFormat:@"Lives: %d",lives];
    livesLabel.fontSize = 40;
    livesLabel.fontColor = livesFontColour;
    
    livesLabel.position = CGPointMake(self.size.width -100,self.size.height-50);
    livesLabel.zPosition = 4.0;
    [self addChild:livesLabel];
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:mainFont];
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    scoreLabel.fontSize = 50;
    scoreLabel.fontColor = mainFontColour;
    
    scoreLabel.position = CGPointMake(self.size.width/2,self.size.height-50);
    scoreLabel.zPosition = 4.0;
    [self addChild:scoreLabel];
    
    
    tree = [SKSpriteNode spriteNodeWithImageNamed:@"Tree"];
    
    tree.scale = 0.3;
    tree.zPosition = 5;
    tree.position = CGPointMake(self.size.width - tree.size.width/2 ,self.size.height/2);

    [self addChild:tree];
    
    portal = [SKSpriteNode spriteNodeWithImageNamed:@"Portal"];
    
    portal.scale = 0.3;
    portal.zPosition = 0;
    portal.position = CGPointMake(portal.size.width ,self.size.height/2);
    
    
    SKAction *spinOnce = [SKAction rotateByAngle:-M_PI*2 duration: 5.0];
    SKAction *spinForever = [SKAction repeatActionForever:spinOnce];
    [portal runAction:spinForever];
    
    fadeAndReappear = [SKAction sequence:@[
                                           [SKAction runBlock:^{
        [portal runAction:[SKAction waitForDuration:4]completion:^{
            [portal runAction:[SKAction fadeAlphaTo:0 duration:0.5]completion:^{
                double randomX = arc4random() % [@(self.size.width - self.size.width/15) intValue] + self.size.width/30;
                double randomY = arc4random() % [@(self.size.height - self.size.height/15) intValue] + self.size.height/30;
                [portal runAction:[SKAction fadeAlphaTo:1 duration:1]];
                portal.position = CGPointMake(randomX, randomY);

            }];
        }];
    }]]];
    
    [self addChild:portal];

    
    
}

- (SKSpriteNode *)bullet
{
    bulletBody = [[SKSpriteNode alloc] initWithImageNamed:@"Bullet.png" ];
    bulletBody.size=CGSizeMake(self.size.width/200, self.size.width/100);
    
    bulletBody.position = player.position;
    bulletBody.zPosition = player.zPosition -1;//if you want your bullet not to spawn on top of your player
    bulletBody.zRotation = player.zRotation;
    
    bulletBody.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bulletBody.size.height / 2];
    bulletBody.physicsBody.usesPreciseCollisionDetection = YES;
    bulletBody.physicsBody.allowsRotation = YES;
    bulletBody.physicsBody.dynamic = NO;
    bulletBody.physicsBody.categoryBitMask = bulletCategory;
    
    bulletBody.physicsBody.collisionBitMask = 0;
    bulletBody.physicsBody.contactTestBitMask = bulletCategory | enemyCategory;
    
    /* (from dont touch green balls...
     powerUpSpot = [[SKSpriteNode alloc] initWithImageNamed:@"Blank.png" ];
     powerUpSpot.size = body.size;
     powerUpSpot.zPosition = 2;
     [body addChild:powerUpSpot];
     
     hitSpot = [[SKSpriteNode alloc] initWithImageNamed:@"Blank.png" ];
     hitSpot.size = body.size;
     hitSpot.zPosition = 3;
     [body addChild:hitSpot];
     */
    
    return bulletBody;
}

- (EnemyClass *)enemy:(CGPoint)positionToSpawn {
    
    enemy = [[EnemyClass alloc] init];
    enemy.speed = arc4random() % 5 + 10;
    //enemy.enemySpeed = arc4random() % 5 + 10;  //this doesn't work/I dont know how to fix
    NSLog(@"Enemy Speed : %f",enemy.speed );
    enemy.name = @"Enemy";
    enemy.position = positionToSpawn;
    enemy.zPosition = 1;
    
    enemyBody = [SKSpriteNode spriteNodeWithImageNamed:@"Enemy"];
    enemyBody.texture = [SKTexture textureWithImageNamed:@"Enemy"];
    enemyBody.scale = 0.1;
    
    enemyBody.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemyBody.size.height / 2];
    enemyBody.physicsBody.usesPreciseCollisionDetection = YES;
    enemyBody.physicsBody.allowsRotation = YES;
    enemyBody.physicsBody.dynamic = YES;
    enemyBody.physicsBody.categoryBitMask = enemyCategory;
    
    enemyBody.physicsBody.collisionBitMask = 0;
    enemyBody.physicsBody.contactTestBitMask = enemyCategory | playerCategory;
    
    [enemy addChild:enemyBody];
    
    return enemy;
    
    
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
    
    CGPoint clickPoint = [theEvent locationInNode:self];
    CGPoint charPos = player.position;
    CGFloat distance = sqrtf((clickPoint.x-charPos.x)*(clickPoint.x-charPos.x)+
                             (clickPoint.y-charPos.y)*(clickPoint.y-charPos.y));
    
    SKAction *moveToClick = [SKAction moveTo:clickPoint duration:distance/playerSpeed];
    [player runAction:moveToClick];
    
}



- (void)keyDown:(NSEvent *)event {
    [self handleKeyEvent:event keyDown:YES];
}

- (void)keyUp:(NSEvent *)event {
    [self handleKeyEvent:event keyDown:NO];
}



- (void)handleKeyEvent:(NSEvent *)event keyDown:(BOOL)downOrUp {
    NSString *characters = [event characters];
    for (int s = 0; s<[characters length]; s++) {
        unichar oneCharacter = [characters characterAtIndex:s];
        switch (oneCharacter) {
            case 'a': {
                
                NSLog(@"A");
                SKAction *rotation = [SKAction rotateByAngle: M_PI/8 duration:0.1];
                [player runAction: rotation];
                
                if (player.zRotation*180/M_PI >= 360) { //if the player is on their second lap put them back on their first
                    player.zRotation =player.zRotation - 2*M_PI;
                }
                
                NSLog(@"%f",player.zRotation*180/M_PI);
                break;
                
            }
            case 'd': {
                
                NSLog(@"D");
                SKAction *rotation2 = [SKAction rotateByAngle: -M_PI/8 duration:0.1];
                [player runAction: rotation2];
                
                if (player.zRotation*180/M_PI <= 0) { // if the player is going into negetive number move them back into positive numbers
                    player.zRotation =player.zRotation + 2*M_PI;
                    
                }
                NSLog(@"%f",player.zRotation*180/M_PI);
                break;
                
            }
                
                /*
                 case ' ';
                 NSLog(@"Sapce");
                 break;
                 case NSUpArrowFunctionKey:
                 NSLog(@"UP");
                 [self movePlayerUp];
                 break;
                 case NSLeftArrowFunctionKey:
                 [self movePlayerLeft];
                 break;
                 case NSRightArrowFunctionKey:
                 [self movePlayerRight];
                 break;
                 case NSDownArrowFunctionKey:
                 [self movePlayerDown];
                 break;
                 */
        }
    }
}

/*
 -(void)movePlayerUp {
 
 sprite.position = CGPointMake(sprite.position.x, sprite.position.y + 10);
 
 
 }
 
 -(void)movePlayerDown {
 
 sprite.position = CGPointMake(sprite.position.x, sprite.position.y - 10);
 
 
 }
 
 -(void)movePlayerLeft {
 
 sprite.position = CGPointMake(sprite.position.x - 10, sprite.position.y);
 
 
 }
 
 -(void)movePlayerRight {
 
 sprite.position = CGPointMake(sprite.position.x + 10, sprite.position.y);
 
 
 }
 */
- (void) playerEnemeyCollision:(SKSpriteNode*)enemyThatGotHit { // Collision between player and enemy
    
    [enemyThatGotHit removeFromParent];
    NSLog(@"Collision between player and enemy");
    
    lives = lives - 1;
    livesLabel.text = [NSString stringWithFormat:@"Lives: %d",lives];
    
    if (lives == 0) {
        
        
        SKScene *gameOverScene  = [[GameOverScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition crossFadeWithDuration:1];
        [self.view presentScene:gameOverScene transition:doors];
        
    }
    
}

- (void) bulletEnemeyCollision:(SKSpriteNode*)enemyThatHit:(SKSpriteNode*)bulletThatHit { //Collision between bullet and enemy
    
    explosion = [SKSpriteNode spriteNodeWithImageNamed:@"Explosion"];
    
    explosion.position = bulletThatHit.position;
    explosion.size = CGSizeMake(enemyThatHit.size.width*3, enemyThatHit.size.width*3);
    explosion.zPosition = 2;
    
    SKAction *fadeOutExplosion = [SKAction fadeOutWithDuration:0.5];
    [explosion runAction:fadeOutExplosion completion:^{
        [explosion removeFromParent];
    }];
    
    [self addChild:explosion];
    
    
    scoreCounterThing = [SKLabelNode labelNodeWithFontNamed:mainFont];
    scoreCounterThing.text = [NSString stringWithFormat:@"+1"];
    scoreCounterThing.fontSize = 30;
    scoreCounterThing.fontColor = mainFontColour;
    
    scoreCounterThing.position = CGPointMake(bulletThatHit.position.x,bulletThatHit.position.y + 35);
    scoreCounterThing.zPosition = 4.0;
    
    
    SKAction *fadeOutLabel = [SKAction fadeOutWithDuration:2];
    [scoreCounterThing runAction:[SKAction moveByX:0 y:25 duration:1]];
    [scoreCounterThing runAction:fadeOutLabel completion:^{
        [scoreCounterThing removeFromParent];
    }];

    [self addChild:scoreCounterThing];
    
    score = score + 1;
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    
    
    [self runAction:[SKAction playSoundFileNamed:@"ExplosionSound.wav" waitForCompletion:YES]];
    
    [enemyThatHit removeFromParent];
    [bulletThatHit removeFromParent];
    NSLog(@"Collision between bullet and enemy");
    
}

//collisions
- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKSpriteNode *firstNode;
    SKSpriteNode *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    //collision between player and block
    if ((contact.bodyA.categoryBitMask == playerCategory)
        && (contact.bodyB.categoryBitMask == enemyCategory)) {
        
        [self playerEnemeyCollision:secondNode];
        
    }
    
    //collision between player and block
    if ((contact.bodyA.categoryBitMask == enemyCategory)
        && (contact.bodyB.categoryBitMask == bulletCategory)) {
        
        [self bulletEnemeyCollision:firstNode:secondNode];
        
    } else if ((contact.bodyA.categoryBitMask == bulletCategory)
               && (contact.bodyB.categoryBitMask == enemyCategory)) {
        
        [self bulletEnemeyCollision:secondNode:firstNode];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //makes all the emenies move towards the player
    EnemyClass *enemies;
    for(enemies in allEnemies) {
        
        CGPoint charPos = player.position;
        CGPoint enemyPos = enemies.position;
        
        CGFloat distance = sqrtf((charPos.x-enemyPos.x)*(charPos.x-enemyPos.x)+
                                 (charPos.y-enemyPos.y)*(charPos.y-enemyPos.y));
        
        SKAction *moveTowardsPlayer = [SKAction moveTo:charPos duration:distance/enemies.speed];
        [enemies runAction:moveTowardsPlayer];
        
        
    }
    
    //shoot
    if (bulletDelayCounter >= bulletDelay) {
        //shoot a bullet
        bullet = [self bullet];
        [self addChild:bullet];
        
        int bulletXPosition;
        int bulletYPosition;
        double newBulletSpeed;
        //coordinates of bullets end position
        if (player.zRotation*180/M_PI <= 45 || player.zRotation*180/M_PI > 315) { // aiming 'upish'
            
            if (player.zRotation*180/M_PI > 0){ //first quadrant
                
                bulletYPosition = player.position.y + self.size.height + bullet.size.height;
                bulletXPosition = player.position.x - tan(player.zRotation)*(bulletYPosition - player.position.y);
                
                
            } else { // forth quadrant
                
                bulletYPosition = player.position.y + self.size.height + bullet.size.height;
                bulletXPosition = player.position.x + tan(2*M_PI - player.zRotation)*(bulletYPosition - player.position.y);
                
            }
            
            
        } else if (player.zRotation*180/M_PI > 45 && player.zRotation*180/M_PI <= 135) { // aiming 'leftish'
            
            if (player.zRotation*180/M_PI <= 90){ //first quadrant
                
                bulletXPosition = player.position.x - (self.size.width + bullet.size.width);
                bulletYPosition = player.position.y - tan(M_PI/2 - player.zRotation)*(bulletXPosition - player.position.x);
                
            } else { // second quadrant
                
                bulletXPosition = player.position.x - (self.size.width + bullet.size.width);
                bulletYPosition = player.position.y + tan(player.zRotation - M_PI/2)*(bulletXPosition - player.position.x);
                
            }
            
        } else if (player.zRotation*180/M_PI > 135 && player.zRotation*180/M_PI <= 225) { // aiming 'downish'
            
            if (player.zRotation*180/M_PI <=180){ //second quadrant
                
                bulletYPosition = player.position.y - self.size.height + bullet.size.height;
                bulletXPosition = player.position.x + tan(player.zRotation)*(player.position.y -bulletYPosition);
                
            } else { // third quadrant
                
                bulletYPosition = player.position.y - self.size.height + bullet.size.height;
                bulletXPosition = player.position.x - tan(2*M_PI - player.zRotation)*(player.position.y - bulletYPosition);
                
            }
        } else if (player.zRotation*180/M_PI > 225 && player.zRotation*180/M_PI <= 315) { // aiming 'rightish'
            
            if (player.zRotation*180/M_PI <= 270){ //third quadrant
                
                bulletXPosition = player.position.x + (self.size.width + bullet.size.width);
                bulletYPosition = player.position.y + tan(M_PI/2 - player.zRotation)*(player.position.x - bulletXPosition);
                
                
            } else { // forth quadrant
                
                bulletXPosition = player.position.x + (self.size.width + bullet.size.width);
                bulletYPosition = player.position.y - tan(player.zRotation - M_PI/2)*(player.position.x - bulletXPosition);
            }
            
        }
        
        newBulletSpeed = sqrt(pow(bulletXPosition-player.position.x,2)+pow(bulletYPosition-player.position.y,2))/250; //using pythagoras to find hypotenuse
        
        SKAction *move = [SKAction moveTo:CGPointMake(bulletXPosition, bulletYPosition) duration:newBulletSpeed];
        [bullet runAction:move completion:^{
            //[bullet removeFromParent];//removes the bullet when it reaches target
            //you can add more code here
        }];
        
        bulletDelayCounter = 0;
    } else { //dont fire a bullet, increase counter instead
        bulletDelayCounter = bulletDelayCounter + 1;
        
    }
    
    //create enemy
    if (enemyDelayCounter >= enemyDelay) {
        
        //spawn enemies from the four corners of the screen:
        CGPoint positionToSpawnEnemies;
        positionToSpawnEnemies = portal.position;
        /* spawns enemies in the four corners of the screen:
        int random1234 = arc4random() % 4 + 1;
        if (random1234 == 1) {
            positionToSpawnEnemies = CGPointMake(0, 0);
        } else if (random1234 == 2) {
            positionToSpawnEnemies = CGPointMake(self.size.width, 0);
        } else if (random1234 == 3) {
            positionToSpawnEnemies = CGPointMake(0, self.size.height);
        }else if (random1234 == 4) {
            positionToSpawnEnemies = CGPointMake(self.size.width, self.size.height);
        }
         */
        
        enemy = [self enemy:positionToSpawnEnemies];
        [self insertChild:enemy atIndex: 0 ];
        [allEnemies addObject:enemy];
        
        enemyDelayCounter = 0;
        
    } else { //dont create an enemy, increase counter instead
        enemyDelayCounter = enemyDelayCounter + 1;
        
    }
    
    //move portal
    if (portalDelayCounter >= portalDelay) {
        
        [portal runAction:fadeAndReappear];
        
        portalDelayCounter = 0;
        
    } else { //dont move the protal, increase counter instead
        portalDelayCounter = portalDelayCounter + 1;
        
    }

}



@end
