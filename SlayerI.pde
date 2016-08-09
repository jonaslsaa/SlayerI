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
  
  Player1 = new Player(100, 50, 2, 5);
  enemies = new Enemy[maxEnemiesOnScreen];
  GameSetup();
  
}

void draw(){
  background(0);
  
  updateMovement();
  updateGraphics();
}

void updateDeltaTime(){
  deltaTime = (30*gameSpeedMultiplier)/frameRate;
  
}


class Player{
  
  public int xPos = windowWidth/2;
  public int yPos = windowHeight/2;
  
  public int speed;
  public int health;
  public int damage;
  public int regenHP;
  
  public PImage Sprite;
  public float spriteMultiplier = .15;
  public int spriteHeight;
  public int spriteWidth;
  
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();
  
  Player(int _h, int _d, int _r, int _s){
    health = _h;
    damage = _d;
    regenHP = _r;
    speed = _s;
    
    
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

  int damageOnHit;
  boolean isOnScreen;
    
  Bullet(int _damage){damageOnHit = _damage};
  
}

void updateGraphics(){
  for(int e = 0; e < maxEnemiesOnScreen; e++){
    image(enemies[e].Sprite, enemies[e].xPos, enemies[e].yPos, enemies[e].spriteWidth, enemies[e].spriteHeight);
  }
  
  image(Player1.Sprite, Player1.xPos, Player1.yPos, Player1.spriteWidth, Player1.spriteHeight);
}

void updateMovement(){


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