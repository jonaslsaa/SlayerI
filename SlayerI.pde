public int windowWidth = 800;
public int windowHeight = 600;

public float deltaTime;
public float gameSpeedMultiplier = 1.0;

public Player Player1;
public Enemy[] enemies;

public PImage BulletSprite;
public PImage StoneTile;
public PImage GameOver;
public PImage BakedBG;
public int tileSize = 96; //Scale of tiles (auto adjusted)

public int maxEnemiesOnScreen = 1;
public int maxCountdown = 500;
public int countdown;

public int SCORE = 0;

public boolean keyInput[] = new boolean[256];

void setup(){
  size(800, 600);
  println("LOADING...");
  frameRate(144);
  Player1 = new Player(100, 50, 6);
  enemies = new Enemy[maxEnemiesOnScreen];
  countdown = maxCountdown;
  GameSetup();
  
}

void draw(){
  if(frameCount == 1){
    MakeStoneTiles();
    text("LOADING...", windowWidth/2-40, windowHeight/2-15);
  } else if(frameCount == 300){
    BakedBG = loadImage("/DATA/baked_background.png");
    println("Loaded baked image with dimensions "+windowWidth+" x "+windowHeight);
  println("LOADED!");
  } else if(frameCount > 300) {
    DrawStoneTiles();
    
    updateDeltaTime();
    
    updateMovement();
    updateGraphics();
    updateCollisions();
    SpawnEnemies();
    
    DrawDebug();
    checkDead();
  }
}

void updateDeltaTime(){
  deltaTime = (30*gameSpeedMultiplier)/frameRate;
}

void stop() {
  String fileName = dataPath("/DATA/baked_background.png");
  File f = new File(fileName);
  if (f.exists()) {
    f.delete();
  }
}

void SpawnEnemies(){
  countdown = countdown - 1;
  if(countdown <= 0){ // If countdown is zero
    maxCountdown = round(maxCountdown * 0.95);
    countdown = maxCountdown;
    for(int e = 0; e < maxEnemiesOnScreen; e++){ //Find dead enemy and resuect him
      if(enemies[e].health <= 0){
        enemies[e].health = 100;
        enemies[e].spawnConfusion = 100;
        enemies[e].xPos = round(random(0, windowWidth));
        enemies[e].yPos = round(random(0, windowHeight));
        break;
      }
    }
  }
}

void checkDead(){
  if(Player1.isDead){
    fill(200,0,0);
    image(GameOver, windowWidth/2-200, windowHeight/2-275, 400, 200);
    text("SCORE: "+SCORE, windowWidth/2-20, windowHeight/2-33);
    fill(255);
    countdown = maxCountdown;
  }
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
  float bulletCooldown = 0;
  public boolean isDead = false;
  
  public PImage Sprite;
  
  public float spriteMultiplier = .15;
  public int spriteHeight;
  public int spriteWidth;
  
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  
  Player(int _h, int _d, int _s){
    health = _h;
    damage = _d;
    maxSpeed = _s;
    
  }
  
  
  
  void update(){
    if(!isDead){
      accelarationUpdate();
      bulletUpdate();
      
      currentXSpeed = round(maxSpeed * speedAccX);
      currentYSpeed = round(maxSpeed * speedAccY);
      
      xPos = xPos + round(currentXSpeed * deltaTime);
      yPos = yPos + round(currentYSpeed * deltaTime);
    }
  }

  void bulletUpdate(){
  
    for (int i = bullets.size(); i>0;i--){
        bullets.get(i-1).Update();
        if(bullets.get(i-1).dist > windowWidth+windowHeight){
          bullets.remove(i-1);
        }
    }
    
    if (mousePressed && (mouseButton == LEFT)) {
        if (bulletCooldown <= 0){
          bulletCooldown = 80 * deltaTime;
          SCORE = SCORE + 1;
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
  public int currentXSpeed;
  public int currentYSpeed;
  public float currentXSpeedF;
  public float currentYSpeedF;
  public float constSpeed = 1;
  
  public boolean isDead = false;
  
  public int speed;
  public int health;
  public int damage;
  
  public int spawnConfusion = 0;
  
  public PImage Sprite;
  
  public float spriteMultiplier = .1;
  public int spriteHeight;
  public int spriteWidth;
  
  Enemy(int _h, int _d, int _s){
    health = _h;
    damage = _d;
    speed = _s;
    
  }
  
  void Update(int Tx, int Ty){
    if(health > 0 && spawnConfusion <= 0){
      
      if(Tx > xPos){
        currentXSpeedF = random(constSpeed*0.75, constSpeed*1.25);
      }
      else if(Tx < xPos){
        currentXSpeedF = -random(constSpeed*0.75, constSpeed*1.25);
      }
      else{
      }
      
      if(Ty > yPos){
        currentYSpeedF = random(constSpeed*0.75, constSpeed*1.25);
      }
      else if(Ty < yPos){
        currentYSpeedF = -random(constSpeed*0.75, constSpeed*1.25);
      }
    
      currentXSpeed = round(currentXSpeedF);
      currentYSpeed = round(currentYSpeedF);
      
      xPos = xPos + currentXSpeed;
      yPos = yPos + currentYSpeed;
    }
    
    if(health > 0 && spawnConfusion > -1){
      spawnConfusion = spawnConfusion - 1;
    }
    
    if(health <= 0){
      isDead = true;
      xPos = -100;
      yPos = -100;
    }
    
    println(health);
  }
}

class Bullet{
  
  public int xPos, yPos = 0;
  public float rotation = 0;
  float dist;
  
  public int constSpeed = 4;
  
  public PImage Sprite;
  
  public int damageOnHit = 50;
  public boolean isOnScreen;
  
  
  Bullet(int _x, int _y, float _rot){
    xPos = _x;
    yPos = _y;
    rotation = _rot;
  
  };
  
  void SetVisible(boolean is){
    isOnScreen = is;
  }
  
  void Update(){ // Special thank you to William for hepling me with the bullets
    translate(xPos,yPos);
    rotate(rotation);
    image(BulletSprite, dist, 0, 10, 10);
    resetMatrix();
    dist += constSpeed;
  
  }
}

void updateCollisions(){
  for(int e = 0; e < maxEnemiesOnScreen; e++){
    
    if(enemies[e].spawnConfusion < 1){
      
      if(  (Player1.xPos >= enemies[e].xPos && Player1.xPos <= enemies[e].xPos + enemies[e].spriteWidth) || (Player1.xPos + Player1.spriteWidth >= enemies[e].xPos && Player1.xPos + Player1.spriteWidth <= enemies[e].xPos + enemies[e].spriteWidth) ) {
        if(  (Player1.yPos >= enemies[e].yPos && Player1.yPos <= enemies[e].yPos + enemies[e].spriteHeight) || (Player1.yPos + Player1.spriteHeight >= enemies[e].yPos && Player1.yPos + Player1.spriteHeight <= enemies[e].yPos + enemies[e].spriteHeight)  ){
          if(!Player1.isDead){
            SCORE = round( SCORE * ( (frameCount - 300) / (30*deltaTime) ) );
          }
          enemies[e].isDead = true;
          Player1.isDead = true;
          enemies[e].health = 0;
          Player1.health = 0;
        }
      }
    }
  }
  
  for (int i = Player1.bullets.size(); i>0;i--){
    for(int e = 0; e < maxEnemiesOnScreen; e++){
      if(  (Player1.bullets.get(i-1).xPos >= enemies[e].xPos && Player1.bullets.get(i-1).xPos <= enemies[e].xPos + enemies[e].spriteWidth) || (Player1.bullets.get(i-1).xPos + 10 >= enemies[e].xPos && Player1.bullets.get(i-1).xPos + 10 <= enemies[e].xPos + enemies[e].spriteWidth) ) {
        if(  (Player1.bullets.get(i-1).yPos >= enemies[e].yPos && Player1.bullets.get(i-1).yPos <= enemies[e].yPos + enemies[e].spriteHeight) || (Player1.bullets.get(i-1).yPos + 10 >= enemies[e].yPos && Player1.bullets.get(i-1).yPos + 10 <= enemies[e].yPos + enemies[e].spriteHeight)  ){
          enemies[e].health = enemies[e].health - Player1.bullets.get(i-1).damageOnHit;
          Player1.bullets.remove(i-1);
        }
      }
    }
  }
  
}

void updateGraphics(){
  
  //Loop through all enemies and draw them on screen
  for(int e = 0; e < maxEnemiesOnScreen; e++){
    if(enemies[e].health > 0){
      image(enemies[e].Sprite, enemies[e].xPos, enemies[e].yPos, enemies[e].spriteWidth, enemies[e].spriteHeight);
    }
  }
  
  if(!Player1.isDead){ //Draws the Players sprite
    image(Player1.Sprite, Player1.xPos, Player1.yPos, Player1.spriteWidth, Player1.spriteHeight);
  }
  
}

void updateMovement(){
  Player1.update();
  
  for(int e = 0; e < maxEnemiesOnScreen; e++){
    if(enemies[e].health > 1 && !enemies[e].isDead){
      enemies[e].Update(Player1.xPos, Player1.yPos);
    }
  }
}

void GameSetup(){
  for(int e = 0; e < maxEnemiesOnScreen; e++){
    enemies[e] = new Enemy(0, 75, 2);
    enemies[e].Sprite = loadImage("/DATA/enemy.png");
    
    enemies[e].spriteHeight = round(enemies[e].Sprite.height * enemies[e].spriteMultiplier);
    enemies[e].spriteWidth = round(enemies[e].Sprite.width * enemies[e].spriteMultiplier);
  }
  
  Player1.Sprite = loadImage("/DATA/slayer.png");
  BulletSprite = loadImage("/DATA/bullet.png");
  GameOver = loadImage("/DATA/gameover.png");
  StoneTile = loadImage("/DATA/stonetile.png");
  
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
  text("countdown="+countdown, 20, 200);
  text("maxCountdown="+maxCountdown, 20, 220);
}


void DrawStoneTiles(){

  image(BakedBG, 0, 0);
}

void MakeStoneTiles(){
  for(int w = 0; w < round(windowWidth/tileSize)+1; w++){
    for(int h = 0; h < round(windowHeight/tileSize)+1; h++){
      image(StoneTile, w*tileSize, h*tileSize, tileSize, tileSize);
    }
  }
  println("rendered tiles for bake");
  saveFrame("baked_background.png");
  println("saved baked image");
}