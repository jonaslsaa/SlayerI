public int windowWidth = 800;
public int windowHeight = 600;

public float deltaTime;
public float gameSpeedMultiplier = 1.0;

public Player Player1;
public Enemy[] enemies;

public int maxEnemiesOnScreen = 8;

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
  public int spriteHeight = 20;
  public int spriteWidth;
  
  Enemy(int _h, int _d, int _s){
    health = _h;
    damage = _d;
    speed = _s;
    
    spriteWidth = round(spriteHeight * 2.46153846154);
  }

}

void updateGraphics(){
  for(int e = 0; e < maxEnemiesOnScreen; e++){
    image(enemies[e].Sprite, enemies[e].xPos, enemies[e].yPos, enemies[e].spriteHeight, enemies[e].spriteWidth);
  }

}

void updateMovement(){


}

void GameSetup(){
  for(int e = 0; e < maxEnemiesOnScreen; e++){
    enemies[e] = new Enemy(100, 75, 2);
    enemies[e].Sprite = loadImage("Enemy.png");
    enemies[e].xPos = round(random(1,windowWidth-enemies[e].spriteWidth));
    enemies[e].yPos = round(random(1,windowHeight-enemies[e].spriteHeight));
  }
  
}