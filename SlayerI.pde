public int windowWidth = 800;
public int windowHeight = 600;

public float deltaTime;
public float gameSpeedMultiplier = 1.0;

public Player Player1;
public Enemy[] enemies;

public int maxEnemiesOnScreen = 8;

public boolean keyInput[] = new boolean[256];

void setup(){
  size(800, 600);
  
  Player1 = new Player(100, 50, 2, 6);
  enemies = new Enemy[maxEnemiesOnScreen];
  GameSetup();
  
}

void draw(){
  background(0);
  
  updateDeltaTime();
  
  updateMovement();
  updateGraphics();
  
  DrawDebug();
  
}

void updateDeltaTime(){
  deltaTime = (30*gameSpeedMultiplier)/frameRate;
}


class Player{
  
  public int xPos = windowWidth/2;
  public int yPos = windowHeight/2;
  
  float speedAccX = 0;
  float speedAccY = 0;
  float accSpeed = 0.5;
  public int maxSpeed;
  public int currentXSpeed;
  public int currentYSpeed;
  
  public int health;
  public int damage;
  public int regenHP;
  
  public PImage Sprite;
  public PImage BulletSprite;
  
  public float spriteMultiplier = .15;
  public int spriteHeight;
  public int spriteWidth;
  
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  
  Player(int _h, int _d, int _r, int _s){
    health = _h;
    damage = _d;
    regenHP = _r;
    maxSpeed = _s;
    
  }
  
  void update(){
    accelarationUpdate();
    
    currentXSpeed = round(maxSpeed * speedAccX);
    currentYSpeed = round(maxSpeed * speedAccY);
    
    xPos = xPos + round(currentXSpeed * deltaTime);
    yPos = yPos + round(currentYSpeed * deltaTime);
    
  }

  void accelarationUpdate(){
    if(isKeyDown('w') && speedAccY <= 1.5 && speedAccY >= -1.0){
      speedAccY = speedAccY - accSpeed;
    } else if(isKeyDown('s') && speedAccY <= 1.0 && speedAccY >= -1.5){
      speedAccY = speedAccY + accSpeed;
    }
    
    if(isKeyDown('a') && speedAccX <= 1.5 && speedAccX >= -1.0){
      speedAccX = speedAccX - accSpeed;
    } else if(isKeyDown('d') && speedAccX <= 1.0 && speedAccX >= -1.5){
      speedAccX = speedAccX + accSpeed;
    }
    
    if(isKeyDown('w') == false && isKeyDown('a') == false && isKeyDown('s') == false && isKeyDown('d') == false){
      if(speedAccX > 0){
        speedAccX = speedAccX - accSpeed;
      }
      if(speedAccX < 0){
        speedAccX = speedAccX + accSpeed;
      }
      if(speedAccY < 0){
        speedAccY = speedAccY + accSpeed;
      }
      if(speedAccY > 0){
        speedAccY = speedAccY - accSpeed;
      }
    }
  
  }

}


class Enemy{
  
  public int xPos;
  public int yPos;
  
  public int speed;
  public int health;
  public int damage;
  
  public PImage Sprite;
  
  public float spriteMultiplier = .1;
  public int spriteHeight;
  public int spriteWidth;
  
  Enemy(int _h, int _d, int _s){
    health = _h;
    damage = _d;
    speed = _s;
    
  }

}

class Bullet{
  
  public int xPos;
  public int yPos;
  
  public int maxSpeed = 8;
  public int speedX;
  public int speedY;
  
  public int damageOnHit;
  public boolean isOnScreen;
  
  
  Bullet(int _damage){damageOnHit = _damage; };
  
  void isVisible(boolean is){
    isOnScreen = is;
  }
  
}

void updateGraphics(){
  
  //Loop through all enemies and draw them on screen
  for(int e = 0; e < maxEnemiesOnScreen; e++){
    image(enemies[e].Sprite, enemies[e].xPos, enemies[e].yPos, enemies[e].spriteWidth, enemies[e].spriteHeight);
  }
  
  //Draws the Players sprite
  image(Player1.Sprite, Player1.xPos, Player1.yPos, Player1.spriteWidth, Player1.spriteHeight);
  
  //Draws all bullets in frame
  for(int b = 0; b < Player1.bullets.size(); b++){
    Bullet getBullet = Player1.bullets.get(b);
    if(getBullet.isOnScreen){
      image(Player1.BulletSprite, getBullet.xPos, getBullet.xPos);
    }
  }
}

void updateMovement(){
  Player1.update();
  
}

void GameSetup(){
  for(int e = 0; e < maxEnemiesOnScreen; e++){
    enemies[e] = new Enemy(100, 75, 2);
    enemies[e].Sprite = loadImage("Enemy.png");
    
    enemies[e].spriteHeight = round(enemies[e].Sprite.height * enemies[e].spriteMultiplier);
    enemies[e].spriteWidth = round(enemies[e].Sprite.width * enemies[e].spriteMultiplier);
    
    enemies[e].xPos = round(random(1,windowWidth-enemies[e].spriteWidth));
    enemies[e].yPos = round(random(1,windowHeight-enemies[e].spriteHeight));
  }
  
  Player1.Sprite = loadImage("Slayer.png");
  Player1.BulletSprite = loadImage("Bullet.png");
  
  Player1.spriteHeight = round(Player1.Sprite.height * Player1.spriteMultiplier);
  Player1.spriteWidth = round(Player1.Sprite.width * Player1.spriteMultiplier);
}

void keyPressed() {
  if((int)key < 256){
    keyInput[(int)key] = true;
  }
}

void keyReleased() {
  if((int)key < 256){
    keyInput[(int)key] = false;
  }
}

boolean isKeyDown(char KEY){
  return keyInput[(int)KEY];
}

void DrawDebug(){
  text("maxEnemiesOnScreen="+maxEnemiesOnScreen, 20, 20);
  text("FPS="+round(frameRate), 20, 40);
  text("Delta Time="+deltaTime, 20, 60);
  text("X Acceleration="+Player1.speedAccX, 20, 100);
  text("Y Acceleration="+Player1.speedAccY, 20, 120);
}