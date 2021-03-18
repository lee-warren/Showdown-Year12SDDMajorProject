//
//  TutorialScene.m
//  MajorProject
//
//  Created by Lee Warren on 1/03/2016.
//  Copyright (c) 2016 Lee Warren. All rights reserved.
//

#import "TutorialScene.h"
#import "EnemyClass.h"
#import <AVFoundation/AVFoundation.h>
#import "GameOverScene.h"



@implementation TutorialScene

static const uint32_t playerCategory = 0x1 << 0;
static const uint32_t enemyCategory = 0x1 << 1;
static const uint32_t bulletCategory = 0x1 << 2;
static const uint32_t bombCategory = 0x1 << 3;
static const uint32_t crateCategory = 0x1 << 4;


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    
    // self.backgroundColor = [SKColor colorWithRed:237/255.0f green:225/255.0f blue:170/255.0f alpha:1.0f];
    
    self.physicsWorld.contactDelegate = self;
    //set gravity to zero:
    self.physicsWorld.gravity = CGVectorMake(0.0f, 0.0f);
    
    //highscore stuff
    defaults = [NSUserDefaults standardUserDefaults];
    
    //use to clear nsuserdafaults:
        //[[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];

    soundEffectVolume = [defaults doubleForKey:@"soundEffectVolume"];
    
    currentName = [defaults stringForKey:@"currentName"];
    
    names = [[defaults objectForKey:@"names"]mutableCopy];
    highScores = [[defaults objectForKey:@"highScores"]mutableCopy];
    hitPercentages = [[defaults objectForKey:@"hitPercentages"]mutableCopy];
    
    if (highScores == 0){
        highScores = [NSMutableArray arrayWithObjects: [NSNumber numberWithInt:15],[NSNumber numberWithInt:12],[NSNumber numberWithInt:8],[NSNumber numberWithInt:6],[NSNumber numberWithInt:3], nil];
        names = [NSMutableArray arrayWithObjects: @"progamer", @"2ndbest", @"midman", @"4thewin", @"tryhard", nil];
        hitPercentages = [NSMutableArray arrayWithObjects: @"95.55%",@"24.95%",@"50.00%",@"83.75%",@"12.12%", nil];

    }
    
    //end of highscore stuff

    
    self.backgroundColor = [SKColor colorWithRed:37/255.0f green:37/255.0f blue:37/255.0f alpha:1.0f];
    
    mainFont = @"Carnivalee Freakshow";
    mainFontColour = [SKColor colorWithRed:91/255.0f green:72/255.0f blue:56/255.0f alpha:1.0f];
    livesFontColour = [SKColor colorWithRed:142/255.0f green:35/255.0f blue:47/255.0f alpha:1.0f];
    bombCountFontColour = [SKColor colorWithRed:34/255.0f green:139/255.0f blue:34/255.0f alpha:1.0f];

    
    ground = [SKSpriteNode spriteNodeWithImageNamed:@"Ground"];
    ground.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    ground.zPosition = -1;
    [self addChild:ground];
    
    //declaring variables:
    playerSpeed = 300;
    canShootBullet = true;
    bulletSpeed = 8;
    enemyDelay = 75;
    portalDelay = 250;
    crateDelay = enemyDelay*10;
    //bulletDelay = 30;
    
    //loading sound actions
    NSError *error;
    NSURL *zombieSound1 = [[NSBundle mainBundle] URLForResource:@"ZombieSound" withExtension:@"mp3"];
    AVAudioPlayer *zombieSound1Player = [[AVAudioPlayer alloc] initWithContentsOfURL:zombieSound1 error:&error];
    [zombieSound1Player setVolume:soundEffectVolume*0.3];
    [zombieSound1Player prepareToPlay];
    
    playZombieSound1 = [SKAction runBlock:^{
        [zombieSound1Player play];
    }];
    NSURL *zombieSound2 = [[NSBundle mainBundle] URLForResource:@"ZombieSound2" withExtension:@"mp3"];
    AVAudioPlayer *zombieSound2Player = [[AVAudioPlayer alloc] initWithContentsOfURL:zombieSound2 error:&error];
    [zombieSound2Player setVolume:soundEffectVolume*0.3];
    [zombieSound2Player prepareToPlay];
    
    playZombieSound2 = [SKAction runBlock:^{
        [zombieSound2Player play];
    }];
    NSURL *zombieSound3 = [[NSBundle mainBundle] URLForResource:@"ZombieSound3" withExtension:@"mp3"];
    AVAudioPlayer *zombieSound3Player = [[AVAudioPlayer alloc] initWithContentsOfURL:zombieSound3 error:&error];
    [zombieSound3Player setVolume:soundEffectVolume*0.3];
    [zombieSound3Player prepareToPlay];
    
    playZombieSound3 = [SKAction runBlock:^{
        [zombieSound3Player play];
    }];
    NSURL *bombSound = [[NSBundle mainBundle] URLForResource:@"BombSound" withExtension:@"wav"];
    AVAudioPlayer *bombSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:bombSound error:&error];
    [bombSoundPlayer setVolume:soundEffectVolume*0.8];
    [bombSoundPlayer prepareToPlay];
    
    playBombSound = [SKAction runBlock:^{
        [bombSoundPlayer play];
    }];
    //finished loading sounds

    
    CGPoint location = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    player = [SKSpriteNode spriteNodeWithImageNamed:@"Player1.png"];
    
    player.position = location;
    player.scale = 0.5;
    player.zPosition = 2;
    
    //collision stuff
    playerPhysicsContact = [[SKSpriteNode alloc] initWithColor:([SKColor colorWithRed:0/255.0f green:158/255.0f blue:255/255.0f alpha:0.0f]) size:CGSizeMake(player.size.width, player.size.height)];
    playerPhysicsContact.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:player.size.height / 2];
    playerPhysicsContact.physicsBody.dynamic = YES;
    playerPhysicsContact.physicsBody.allowsRotation = YES;
    playerPhysicsContact.physicsBody.categoryBitMask = playerCategory;
    
    [player addChild:playerPhysicsContact];
    
    playerBulletStartPosition =  [[SKSpriteNode alloc] initWithColor:([SKColor colorWithRed:0/255.0f green:158/255.0f blue:255/255.0f alpha:0.0f]) size:CGSizeMake(player.size.width/100, player.size.height/100)];
    playerBulletStartPosition.position = CGPointMake(player.size.width/2 - 3, 0);
    [player addChild:playerBulletStartPosition];
    
    [self addChild:player];
    
    //player animation:
    NSMutableArray *playerTextures = [NSMutableArray arrayWithCapacity:8];
    
    for (int i = 0; i < 13; i++)
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
    
    
    menuBar = [SKShapeNode shapeNodeWithRect:CGRectMake(10, self.size.height - 10, self.frame.size.width - 20, 60) cornerRadius:5];
    menuBar.position = CGPointMake(10 + menuBar.frame.size.width/2 , self.size.height - 40);
    menuBar.fillColor = [SKColor redColor]; //[SKColor colorWithRed:91/255.0f green:72/255.0f blue:56/255.0f alpha:0.8f];
    menuBar.lineWidth = 2;
    menuBar.strokeColor = mainFontColour;
    [self addChild:menuBar];
    
    SKShapeNode *newMenuBar = [SKShapeNode shapeNodeWithRect:CGRectMake(10, self.size.height - 10, self.frame.size.width - 20, 60) cornerRadius:5];
    newMenuBar.position = CGPointMake(0,-60);
    newMenuBar.fillColor = [SKColor colorWithRed:91/255.0f green:72/255.0f blue:56/255.0f alpha:0.2f];
    newMenuBar.lineWidth = 2;
    newMenuBar.strokeColor = mainFontColour;
    [self addChild:newMenuBar];
    
    lives = 3;
    livesLabel = [SKLabelNode labelNodeWithFontNamed:mainFont];
    livesLabel.text = [NSString stringWithFormat:@"Lives: %d",lives];
    livesLabel.fontSize = 40;
    livesLabel.fontColor = livesFontColour;
    
    livesLabel.position = CGPointMake(menuBar.frame.size.width/2 - livesLabel.frame.size.width/2 - 30, -menuBar.frame.size.height/4);
    livesLabel.zPosition = 5;
    [menuBar addChild:livesLabel];
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:mainFont];
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    scoreLabel.fontSize = 50;
    scoreLabel.fontColor = mainFontColour;
    
    scoreLabel.position = CGPointMake(0,-menuBar.frame.size.height/4);
    scoreLabel.zPosition = 5;
    [menuBar addChild:scoreLabel];
    
    bombCount = 0;
    canShootBomb = true;
    bombCountLabel = [SKLabelNode labelNodeWithFontNamed:mainFont];
    bombCountLabel.text = [NSString stringWithFormat:@""];
    bombCountLabel.fontSize = 40;
    bombCountLabel.fontColor = bombCountFontColour;
    
    bombCountLabel.position = CGPointMake(-menuBar.frame.size.width/2 + livesLabel.frame.size.width/2 + 30,-menuBar.frame.size.height/4);
    bombCountLabel.zPosition = 5;
    [menuBar addChild:bombCountLabel];
    
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
    
    bulletBody.position = [ground.scene convertPoint:playerBulletStartPosition.position fromNode:playerBulletStartPosition.parent];
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
    
    enemyBody = [SKSpriteNode spriteNodeWithImageNamed:@"AnimatedEnemy0"];
    enemyBody.size = CGSizeMake(player.size.width*0.85, player.size.height*0.95);
    
    enemyBody.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:enemyBody.size.height / 2];
    enemyBody.physicsBody.usesPreciseCollisionDetection = YES;
    enemyBody.physicsBody.allowsRotation = YES;
    enemyBody.physicsBody.dynamic = YES;
    enemyBody.physicsBody.categoryBitMask = enemyCategory;
    
    enemyBody.physicsBody.collisionBitMask = 0;
    enemyBody.physicsBody.contactTestBitMask = enemyCategory | playerCategory;
    
    [enemy addChild:enemyBody];
    
    //enemy animation:
    NSMutableArray *enemyTextures = [NSMutableArray arrayWithCapacity:8];
    
    for (int i = 0; i < 14; i++)
    {
        NSString *enemyTextureName = [NSString stringWithFormat:@"AnimatedEnemy%d.png", i];
        SKTexture *enemyTexture =
        [SKTexture textureWithImageNamed:enemyTextureName];
        [enemyTextures addObject:enemyTexture];
    }
    
    SKAction* enemyAnimation = [SKAction animateWithTextures:enemyTextures timePerFrame:0.6];
    
    SKAction *enemyRepeat = [SKAction repeatActionForever:enemyAnimation];
    [enemyBody runAction:enemyRepeat];
    
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
    
    CGPoint mousePosition = [theEvent locationInNode:self];
    
    if (mousePosition.x <0 || mousePosition.x > self.size.width || mousePosition.y < 0 || mousePosition.y > self.size.height) {
        
        //mouse is outside of the screen
        
    } else {
        
        CGPoint charPos = player.position;
        CGFloat distance = sqrtf((mousePosition.x-charPos.x)*(mousePosition.x-charPos.x)+
                                 (mousePosition.y-charPos.y)*(mousePosition.y-charPos.y));
        
        SKAction *moveToClick = [SKAction moveTo:mousePosition duration:distance/playerSpeed];
        [player runAction:moveToClick];
        
    }
    
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
        
        if (downOrUp == true) { //key down
            
            switch (oneCharacter) {
                case 'a':
                case 'A':{
                    
                    //NSLog(@"A");
                    SKAction *rotation = [SKAction rotateByAngle: M_PI/7 duration:0.1];
                    [player runAction: rotation];
                    
                    if (player.zRotation*180/M_PI >= 360) { //if the player is on their second lap put them back on their first
                        player.zRotation =player.zRotation - 2*M_PI;
                    }
                    
                    //NSLog(@"%f",player.zRotation*180/M_PI);
                    break;
                    
                }
                case 'd':
                case 'D':{
                    
                    //NSLog(@"D");
                    SKAction *rotation2 = [SKAction rotateByAngle: -M_PI/7 duration:0.1];
                    [player runAction: rotation2];
                    
                    if (player.zRotation*180/M_PI <= 0) { // if the player is going into negetive number move them back into positive numbers
                        player.zRotation =player.zRotation + 2*M_PI;
                        
                    }
                    //NSLog(@"%f",player.zRotation*180/M_PI);
                    break;
                    
                }
            }
        } else { //key up
         
            switch (oneCharacter) {
                    case 's':
                    case 'S':{
                        
                        if (canShootBullet == true) {
                            
                            bullet = [self bullet];
                            [self addChild:bullet];
                            
                            double newBulletSpeed;
                            
                            [self findXYCordinatesForProjectiles];
                            
                            newBulletSpeed = sqrt(pow(bulletXPosition-player.position.x,2)+pow(bulletYPosition-player.position.y,2))/(100*bulletSpeed); //using pythagoras to find hypotenuse
                            
                            SKAction *move = [SKAction moveTo:CGPointMake(bulletXPosition, bulletYPosition) duration:newBulletSpeed];
                            [bullet runAction:move completion:^{
                                //[bullet removeFromParent];//removes the bullet when it reaches target
                                //you can add more code here
                                
                            }];
                            
                            bulletShot = bulletShot + 1;
                            
                            canShootBullet = false;
                            SKAction *waitToShoot = [SKAction waitForDuration:0.75];
                            [self runAction:waitToShoot completion:^{
                                canShootBullet = true;
                            }];
                        }
                        break;
                    }
                case 'w':
                case 'W':{
                    if (bombCount> 0 && canShootBomb == true) { //shoot bomb
                        
                        canShootBomb = false;
                        bombCount = bombCount - 1;
                        bombsShot = bombsShot + 1;
                        if (bombCount == 0) {
                            bombCountLabel.text = [NSString stringWithFormat:@""];
                        } else {
                            bombCountLabel.text = [NSString stringWithFormat:@"Bombs: %d",bombCount];
                        }
                        
                        
                        [self findXYCordinatesForProjectiles];
                        
                        CGPoint diff = CGPointMake(bulletXPosition - player.position.x, bulletYPosition - player.position.y);
                        
                        CGFloat angleRadians = atan2f(diff.y, diff.x);
                        
                        bomb = [SKSpriteNode spriteNodeWithImageNamed:@"PipeBomb.png"];
                        bomb.size = CGSizeMake(player.size.width*0.6, player.size.height*0.6);
                        bomb.position = CGPointMake(player.position.x,player.position.y);
                        bomb.zPosition = 5;
                        
                        [self addChild:bomb];
                        [bomb runAction:[SKAction sequence:@[
                                                             [SKAction rotateToAngle:angleRadians duration:0],
                                                             [SKAction moveByX:diff.x/6 y:diff.y/6 duration:0.1],
                                                             [SKAction waitForDuration:0.3]
                                                             ]] completion:^{
                            
                            
                            explosion = [SKSpriteNode spriteNodeWithImageNamed:@"Explosion1.png"];
                            explosion.size = CGSizeMake(bomb.size.width*6, bomb.size.height*6);
                            explosion.position = CGPointMake(bomb.position.x,bomb.position.y);
                            explosion.zRotation = bomb.zRotation;
                            explosion.zPosition = 5;
                            
                            explosion.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:explosion.size.height/4*1.6];
                            explosion.physicsBody.usesPreciseCollisionDetection = YES;
                            explosion.physicsBody.allowsRotation = YES;
                            explosion.physicsBody.dynamic = NO;
                            explosion.physicsBody.categoryBitMask = bombCategory;
                            
                            explosion.physicsBody.collisionBitMask = 0;
                            explosion.physicsBody.contactTestBitMask = bombCategory | enemyCategory;
                            
                            
                            [self addChild:explosion];
                            
                            [self runAction:playBombSound];
                            
                            
                            //bomb animation:
                            NSMutableArray *explosionTextures = [NSMutableArray arrayWithCapacity:4];
                            
                            for (int i = 1; i < 5; i++)
                            {
                                NSString *explosionTextureName = [NSString stringWithFormat:@"Explosion%d", i];
                                SKTexture *explosionTexture =
                                [SKTexture textureWithImageNamed:explosionTextureName];
                                [explosionTextures addObject:explosionTexture];
                            }
                            
                            SKAction* explosionAnimation = [SKAction animateWithTextures:explosionTextures timePerFrame:0.1];
                            [explosion runAction:explosionAnimation completion:^{
                                [explosion removeFromParent];
                            }];
                            
                            [bomb removeFromParent];
                            
                            
                        }];
                        
                        
                        
                        
                        
                        SKAction *waitToShoot = [SKAction waitForDuration:0.5];
                        [self runAction:waitToShoot completion:^{
                            canShootBomb = true;
                        }];
                    }
                    break;
                }
            }
        }
    }
}
                    /*
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

-(void)findXYCordinatesForProjectiles {
    
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
    
}

- (void) playerEnemeyCollision:(SKSpriteNode*)enemyThatGotHit { // Collision between player and enemy
    
    [enemyThatGotHit removeFromParent];
    NSLog(@"Collision between player and enemy");
    
    lives = lives - 1;
    livesLabel.text = [NSString stringWithFormat:@"Lives: %d",lives];
    
    SKSpriteNode *injuredPlayer = [SKSpriteNode spriteNodeWithImageNamed:@"PlayerDie"];
    injuredPlayer.size = CGSizeMake(player.size.width*2, player.size.height*2);
    injuredPlayer.zPosition = 5;
    
    [player addChild:injuredPlayer];
    
    SKSpriteNode *heart = [SKSpriteNode spriteNodeWithImageNamed:@"HeartLoss1.png"];
    heart.size = CGSizeMake(player.size.width*1.5, player.size.height*1.5);
    heart.position = CGPointMake(player.position.x,player.position.y + player.size.height*1.5);
    heart.zPosition = 5;
    
    [self addChild:heart];

    //heart animation:
    NSMutableArray *heartTextures = [NSMutableArray arrayWithCapacity:8];
    
    for (int i = 1; i < 9; i++)
    {
        NSString *heartTextureName = [NSString stringWithFormat:@"HeartLoss%d", i];
        SKTexture *heartTexture =
        [SKTexture textureWithImageNamed:heartTextureName];
        [heartTextures addObject:heartTexture];
    }
    
    SKAction* heartAnimation = [SKAction animateWithTextures:heartTextures timePerFrame:0.05];
    [heart runAction:heartAnimation completion:^{
        [heart removeFromParent];
    }];
    
    SKAction *wait0 = [SKAction waitForDuration:0.5];

    SKAction *block0 = [SKAction runBlock:^{
        SKAction *fade = [SKAction fadeAlphaTo:0 duration:0.5];
        [injuredPlayer runAction:fade];
    }];
    
    SKAction *block1 = [SKAction runBlock:^{
        [injuredPlayer removeFromParent];
    }];
    
    [self runAction:[SKAction sequence:@[block0, wait0, block1]]];
    
    if (lives == 0) {
        
        hitPercentage = (float)bulletHit/(float)bulletShot*100;
        
        //inserts score into sorted array at correct point and shifts all other values down
        for (int i = 0; i <=(int)[highScores count]-1; i++) {
           
            NSLog(@"Score: %@", [NSNumber numberWithInt:score]);

            if (score == [[highScores objectAtIndex:i]integerValue]) {
                if (hitPercentage> [[hitPercentages objectAtIndex:i]floatValue]) {
                    [names insertObject:currentName atIndex:i];
                    [hitPercentages insertObject:[NSString stringWithFormat:@"%.2f%%",hitPercentage] atIndex:i];
                    [highScores insertObject:[NSNumber numberWithInt:score] atIndex:i];
                    break;
                }
            } else if ([NSNumber numberWithInt:score] > [highScores objectAtIndex:i]) {
                [names insertObject:currentName atIndex:i];
                [hitPercentages insertObject:[NSString stringWithFormat:@"%.2f%%",hitPercentage] atIndex:i];
                [highScores insertObject:[NSNumber numberWithInt:score] atIndex:i];
                break;
            }
            
        }
        
        for (int i = (int)[highScores count]-1; i >=5; i--) {
            [names removeObjectAtIndex:i];
            [hitPercentages removeObjectAtIndex:i];
            [highScores removeObjectAtIndex:i];
        }
        
        [defaults setObject:highScores forKey:@"highScores"];
        [defaults setObject:hitPercentages forKey:@"hitPercentages"];
        [defaults setObject:names forKey:@"names"];
        
        //save the current players stats:
        [defaults setInteger:score forKey:@"currentScore"];
        if (bulletShot == 0) {
            [defaults setObject:[NSString stringWithFormat:@"n/a"] forKey:@"currentHitPercentage"];
        } else {
            [defaults setObject:[NSString stringWithFormat:@"%.2f%%",hitPercentage] forKey:@"currentHitPercentage"];
        }
        //bullets fired
        [defaults setObject:[NSString stringWithFormat:@"%i",bulletShot] forKey:@"currentBulletsShot"];
        //bombs fired
        [defaults setObject:[NSString stringWithFormat:@"%i",bombsShot] forKey:@"currentBombsShot"];
        //bombs collected
        //time played

        [defaults synchronize];
        
    
        SKScene *gameOverScene  = [[GameOverScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition crossFadeWithDuration:1];
        gameOverScene.scaleMode = SKSceneScaleModeAspectFit;
        [self.view presentScene:gameOverScene transition:doors];
        
    }
    
}


- (void) playerCrateCollision:(SKSpriteNode*)crateThatGotHit { // Collision between player and crate
    
    NSLog(@"Collision between player and crate");
    
    
    SKSpriteNode *brokencrate = [SKSpriteNode spriteNodeWithImageNamed:@"SmashedCrate.png"];
    brokencrate.zRotation = crateThatGotHit.zRotation;
    brokencrate.position = crateThatGotHit.position;
    brokencrate.size = crateThatGotHit.size;
    brokencrate.zPosition = crateThatGotHit.zPosition;
    
    [self addChild:brokencrate];
    [crateThatGotHit removeFromParent];
    
    SKAction *block0 = [SKAction runBlock:^{
        SKAction *fade = [SKAction fadeAlphaTo:0 duration:3];
        [brokencrate runAction:fade];
    }];
    
    SKAction *wait0 = [SKAction waitForDuration:3];

    SKAction *block1 = [SKAction runBlock:^{
        [brokencrate removeFromParent];
    }];
    
    [self runAction:[SKAction sequence:@[block0, wait0, block1]]];
    
    bombCount = bombCount + 3;
    bombCountLabel.text = [NSString stringWithFormat:@"Bombs: %d",bombCount];
    
    scoreCounterThing = [SKLabelNode labelNodeWithFontNamed:mainFont];
    scoreCounterThing.text = [NSString stringWithFormat:@"+3"];
    scoreCounterThing.fontSize = 30;
    scoreCounterThing.fontColor = bombCountFontColour;
    
    scoreCounterThing.position = CGPointMake(crateThatGotHit.position.x,crateThatGotHit.position.y + 35);
    scoreCounterThing.zPosition = 4.0;
    
    
    SKAction *fadeOutLabel = [SKAction fadeOutWithDuration:2];
    [scoreCounterThing runAction:[SKAction moveByX:0 y:25 duration:1]];
    [scoreCounterThing runAction:fadeOutLabel completion:^{
        [scoreCounterThing removeFromParent];
    }];
    
    [self addChild:scoreCounterThing];

    
}

- (void) bulletEnemeyCollision:(SKSpriteNode*)enemyThatHit:(SKSpriteNode*)bulletThatHit { //Collision between bullet and enemy
    
    deadEnemy = [SKSpriteNode spriteNodeWithImageNamed:@"EnemyDead"];
    
    deadEnemy.position = bulletThatHit.position;
    deadEnemy.size = CGSizeMake(enemyThatHit.size.width, enemyThatHit.size.width);
    deadEnemy.zPosition = 2;
    deadEnemy.alpha = 0.8;
    
    CGPoint charPos = player.position;
    CGPoint enemyPos = deadEnemy.position;
    deadEnemy.zRotation = atan2(charPos.y-enemyPos.y,charPos.x-enemyPos.x) - M_PI/2;

    
    SKAction *fadeOutdeadEnemy = [SKAction fadeOutWithDuration:2.5];
    [deadEnemy runAction:fadeOutdeadEnemy completion:^{
        [deadEnemy removeFromParent];
    }];
    
    [self addChild:deadEnemy];
    
    
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
    
    bulletHit = bulletHit + 1;

    int randomNo123 = arc4random() % 3 +1;
    if (randomNo123 == 1) {
        [self runAction:playZombieSound1];
    } else if (randomNo123 == 2) {
        [self runAction:playZombieSound2];
    } else if (randomNo123 == 3) {
        [self runAction:playZombieSound3];
    }
    
    [enemyThatHit removeFromParent];
    [bulletThatHit removeFromParent];
    NSLog(@"Collision between bullet and enemy");
    
}

- (void) explosionEnemeyCollision:(SKSpriteNode*)enemyThatHit:(SKSpriteNode*)bombThatHit { //Collision between bullet and enemy
    
    scoreCounterThing = [SKLabelNode labelNodeWithFontNamed:mainFont];
    scoreCounterThing.text = [NSString stringWithFormat:@"+1"];
    scoreCounterThing.fontSize = 30;
    scoreCounterThing.fontColor = mainFontColour;
    
    scoreCounterThing.position = CGPointMake(bombThatHit.position.x,bombThatHit.position.y + 35);
    scoreCounterThing.zPosition = 4.0;
    
    
    SKAction *fadeOutLabel = [SKAction fadeOutWithDuration:2];
    [scoreCounterThing runAction:[SKAction moveByX:0 y:25 duration:1]];
    [scoreCounterThing runAction:fadeOutLabel completion:^{
        [scoreCounterThing removeFromParent];
    }];
    
    [self addChild:scoreCounterThing];
    
    score = score + 1;
    scoreLabel.text = [NSString stringWithFormat:@"%d",score];
    
    [enemyThatHit removeFromParent];

    NSLog(@"Collision between bomb and enemy");
    
}

//collisions
- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKSpriteNode *firstNode;
    SKSpriteNode *secondNode;
    
    firstNode = (SKSpriteNode *)contact.bodyA.node;
    secondNode = (SKSpriteNode *) contact.bodyB.node;
    
    //collision between player and enemy
    if ((contact.bodyA.categoryBitMask == playerCategory)
        && (contact.bodyB.categoryBitMask == enemyCategory)) {
        
        [self playerEnemeyCollision:secondNode];
        
    }
    
    //collision between enemy and bullet
    if ((contact.bodyA.categoryBitMask == enemyCategory)
        && (contact.bodyB.categoryBitMask == bulletCategory)) {
        
        [self bulletEnemeyCollision:firstNode:secondNode];
        
    } else if ((contact.bodyA.categoryBitMask == bulletCategory)
               && (contact.bodyB.categoryBitMask == enemyCategory)) {
        
        [self bulletEnemeyCollision:secondNode:firstNode];
        
    }
    
    //collision between enemy and bomb
    if ((contact.bodyA.categoryBitMask == enemyCategory)
        && (contact.bodyB.categoryBitMask == bombCategory)) {
       
        [self explosionEnemeyCollision:firstNode:secondNode];
        
    } else if ((contact.bodyA.categoryBitMask == bombCategory)
               && (contact.bodyB.categoryBitMask == enemyCategory)) {
       
        [self explosionEnemeyCollision:secondNode:firstNode];
        
    }
    
    //collision between crate and player
    if ((contact.bodyA.categoryBitMask == crateCategory)
        && (contact.bodyB.categoryBitMask == playerCategory)) {

        [self playerCrateCollision:firstNode];
        
    } else if ((contact.bodyA.categoryBitMask == playerCategory)
               && (contact.bodyB.categoryBitMask == crateCategory)) {

        [self playerCrateCollision:secondNode];
        
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
        
        enemies.zRotation = atan2(charPos.y-enemyPos.y,charPos.x-enemyPos.x) - M_PI/2;
        
    }
    
    //insert bullet code here if i change my mind about having to press the button to shoot//
    
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
    
    //create crate
    if (crateDelayCounter >= crateDelay) {
        
        //spawn enemies from the four corners of the screen:
        double randomX = arc4random() % [@(self.size.width - self.size.width/15) intValue] + self.size.width/30;
        double randomY = arc4random() % [@(self.size.height - self.size.height/15) intValue] + self.size.height/30;
        double randomRotation = (arc4random() % 360);
        
        crate = [SKSpriteNode spriteNodeWithImageNamed:@"Crate.png"];
        crate.zRotation = 360/randomRotation * 2 * M_PI;
        crate.position = CGPointMake(randomX, randomY);
        crate.size = CGSizeMake(portal.size.width/1.5, portal.size.width/1.5);
        crate.zPosition = 1;
        
        crate.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:crate.size.height / 2];
        crate.physicsBody.usesPreciseCollisionDetection = YES;
        crate.physicsBody.allowsRotation = YES;
        crate.physicsBody.dynamic = NO;
        crate.physicsBody.categoryBitMask = crateCategory;
        
        crate.physicsBody.collisionBitMask = 0;
        crate.physicsBody.contactTestBitMask = crateCategory | playerCategory;
        
        
        [self addChild:crate];
        
        crateDelayCounter = 0;
        
    } else { //dont create a crate, increase counter instead
        crateDelayCounter = crateDelayCounter + 1;
        
    }
    

}


//other bullet code if I chnage my mind
/*
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
 */

@end
