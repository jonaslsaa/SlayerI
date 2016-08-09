public int windowWidth;
public int windowHeight;

public float deltaTime;
public float gameSpeedMultiplier = 1.0;

public Player Player1;
public Enemy[] enemies;

public int maxEnemiesOnScreen = 8;

void setup(){
  Player1 = new Player(100, 50, 2);
  enemies = new Enemy[maxEnemiesOnScreen];
  
  for(int e = 0; e <= maxEnemiesOnScreen; e++){
    enemies = new Enemy();
  }
  
}

void draw(){
  updateGraphics();

}

void updateDeltaTime(){
  deltaTime = (30*gameSpeedMultiplier)/frameRate;
  
}


class Player{
  
  public int xPos = windowWidth/2;
  public int yPos = windowHeight/2;
  
  public int speed = 5;
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
  
  public int speed = 5;
  public int health;
  public int damage;
  
  public PImage Sprite;
  
  Enemy(int _h, int _d, int _s){
    health = _h;
    damage = _d;
    speed = _s;
  
  }

}

void updateGraphics(){


}