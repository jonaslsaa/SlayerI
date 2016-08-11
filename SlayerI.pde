public int windowWidth = 800;
public int windowHeight = 600;

public float deltaTime;
public float gameSpeedMultiplier = 1.0;

public Player Player1;
public Enemy[] enemies;

public PImage BulletSprite;
public PImage StoneTile;
public PImage BakedBG;
public int nTiles = 64;

public int maxEnemiesOnScreen = 16;
public int maxCountdown = 500;
public int countdown = 500;

public boolean keyInput[] = new boolean[256];

void setup(){
  size(800, 600);
  frameRate(600000);
  Player1 = new Player(100, 50, 2, 6);
  enemies = new Enemy[maxEnemiesOnScreen];
  GameSetup();
  
}

void draw(){
  if(frameCount == 1){
    MakeStoneTiles();
    println("Runned MakeStoneTiles();");
  } else if(frameCount == 300){
    BakedBG = loadImage("baked_background.png");
    println("loaded baked image with dimensions "+windowWidth+" x "+windowHeight);
  
  } else if(frameCount > 300) {
    DrawStoneTiles();
    
    updateDeltaTime();
    
    updateMovement();
    updateGraphics();
    
    SpawnEnemies();
    
    DrawDebug();
  }
}

void updateDeltaTime(){
  deltaTime = (30*gameSpeedMultiplier)/frameRate;
  maxCountdown=round(maxCountdown*deltaTime);
}

void stop() {
  String fileName = dataPath("baked_background.png");
  File f = new File(fileName);
  if (f.exists()) {
    f.delete();
  }
}

void SpawnEnemies(){
  countdown = round((countdown - 1) * deltaTime);
  for(int e = 0; e < maxEnemiesOnScreen; )

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
  float bulletCooldown = 0;
  
  public PImage Sprite;
  
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
    bulletUpdate();
    
    currentXSpeed = round(maxSpeed * speedAccX);
    currentYSpeed = round(maxSpeed * speedAccY);
    
    xPos = xPos + round(currentXSpeed * deltaTime);
    yPos = yPos + round(currentYSpeed * deltaTime);
    
  }

  void bulletUpdate(){
  
    for (int i = bullets.size(); i>0;i--){
        bullets.get(i-1).Update();
        if(bullets.get(i-1).xPos < -50  || bullets.get(i-1).yPos < -50 || bullets.get(i-1).xPos > windowWidth || bullets.get(i-1).yPos > windowWidth){
          bullets.remove(i-1);
        }
    }
    
    if (mousePressed && (mouseButton == LEFT)) {
        if (bulletCooldown <= 0){
          bulletCooldown = 80 * deltaTime;
          if(mouseY>yPos){
          bullets.add(new Bullet(xPos,yPos,PVector.angleBetween(new PVector(1,0),new PVector(mouseX-xPos,mouseY-yPos))));
          }else{
          bullets.add(new Bullet(xPos,yPos,-PVector.angleBetween(new PVector(1,0),new PVector(mouseX-xPos,mouseY-yPos))));
          }
        }
      }
    
    if(bulletCooldown > -10){
      bulletCooldown = bulletCooldown - (10 * deltaTime);
    }
  
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
  
  public float rotation;
  float dist;
  
  public int constSpeed = 5;
  
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
  
  void Update(){
    translate(xPos,yPos);
    rotate(rotation);
    image(BulletSprite, dist, 0, 10, 10);
    resetMatrix();
    dist += constSpeed;
  
  }

}

class Bullet{
  
  public int xPos, yPos;
  public float rotation;
  float dist;
  
  public int constSpeed = 4;
  
  public PImage Sprite;
  
  public int damageOnHit = 10;
  public boolean isOnScreen;
  
  
  Bullet(int _x, int _y, float _rot){
    xPos = _x;
    yPos = _y;
    rotation = _rot;
  
  };
  
  void SetVisible(boolean is){
    isOnScreen = is;
  }
  
  void Update(){
    translate(xPos,yPos);
    rotate(rotation);
    image(BulletSprite, dist, 0, 10, 10);
    resetMatrix();
    dist += constSpeed;
  
  }
  
}

void updateGraphics(){
  
  //Loop through all enemies and draw them on screen
  for(int e = 0; e < maxEnemiesOnScreen; e++){
    image(enemies[e].Sprite, enemies[e].xPos, enemies[e].yPos, enemies[e].spriteWidth, enemies[e].spriteHeight);
  }
  
  //Draws the Players sprite
  image(Player1.Sprite, Player1.xPos, Player1.yPos, Player1.spriteWidth, Player1.spriteHeight);
  
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
  BulletSprite = loadImage("Bullet.png");
  StoneTile = loadImage("stonetile.png");
  
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
  text("Bullets Alive="+Player1.bullets.size(), 20, 160);
  text("bulletCooldown="+Player1.bulletCooldown, 20, 180);
}


void DrawStoneTiles(){

  image(BakedBG, 0, 0);
}

void MakeStoneTiles(){
  for(int w = 0; w < round(windowWidth/nTiles)+1; w++){
    for(int h = 0; h < round(windowHeight/nTiles)+1; h++){
      image(StoneTile, w*nTiles, h*nTiles, nTiles, nTiles);
    }
  }
  println("rendered tiles");
  saveFrame("baked_background.png");
  println("tried to save image");
}