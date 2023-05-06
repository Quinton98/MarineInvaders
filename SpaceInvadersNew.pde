
import processing.sound.pde.*;
SoundFile music;
Spaceship mySpaceship;
ArrayList bullets;
ArrayList bombs;
float distance_enemy;
int lives;
int cols= 10;
int rows =5;
int cols_select;
int rows_select;
Alien[][] aliens = new Alien[cols][rows];

Timer timer;

boolean gameOn=true;
int deadAliens=0;
int lastGuy=0;

import processing.sound.*;
void setup() {
 ocean = loadImage("oceans.jpeg");
 sub = loadImage("sub.png");
music = new SoundFile(this, "intensemusic.mp3");
music.play();

  size(1200, 700);
  smooth();

  lives = 5;

  mySpaceship = new Spaceship(200, 200, 200, 500, 700);
 
  bullets = new ArrayList();
  bombs = new ArrayList();

 
  for (int i=0; i< cols; i++) {
    for (int j=0; j<rows; j++) {
      aliens[i][j] = new Alien(140, 300, 300, 360, i*100, j*80, 1);
    }
  }


  
  timer = new Timer(350);
  timer.start();
}

void draw() {
  fill(0,50);
  image(ocean,600,350,1250,700);
  imageMode(CENTER);
  rect(0, 0, width, height);

  fill(255);
  textSize(15);
  text("Instructions:", 150, 90);
  text("Control the ship's movement along the x axis by moving your mouse", 150, 110);
  text("Click to fire", 150, 130);
  text("Don't get hit by the bullets!", 150, 150);
  textSize(50);
  fill (0, 255, 255);
  text("Marine Invaders", width/2 - 2, 50);

  
  mySpaceship.display();
  mySpaceship.move();
  mySpaceship.limit_x();
  mySpaceship.lastGuy();



  for (int i=0; i< cols; i++) {
    for (int j=0; j<rows; j++) {
      aliens[i][j].display();
      aliens[i][j].move();
      aliens[i][j].shift();
      aliens[i][j].exitStageLeft();
    }
  }



  for (int i=0; i < bullets.size(); i++) {

    Bullet b = (Bullet) bullets.get(i);
    b.display();
    b.fire();

    if (b.finished()) {
      bullets.remove(b);
    }
    for (int k=0; k< cols; k++) {
      for (int j=0; j<rows; j++) {
        if (b.intersect(aliens[k][j])) {
          bullets.remove(b);
          aliens[k][j].destroyed();
          deadAliens=deadAliens+1;
        }
      }
    }
  }

  for (int i=0; i < bombs.size(); i++) {

    Bomb b = (Bomb) bombs.get(i);
    b.display();
    b.fire();
    
    if( b.intersect() ){ 
      if( lives > 0 ){ 
        lives--; 
        bombs.remove(b); 
      }
    }
    
    if (b.finished()) {
      bombs.remove(b);
    }
  }


  for (int i=0; i< cols; i++) {
    for (int j=0; j<rows; j++) {
      int cols_select=int(random(10));
      int rows_select=int(random(5));   
      if (timer.isFinished() && aliens[cols_select][rows_select].imaDeadAlien==false) {
        bombs.add(new Bomb(140, 300, 300, aliens[cols_select][rows_select].true_xpos, aliens[cols_select][rows_select].true_ypos, -10));
        timer.start();
      }
    }
  }

  fill(255, 0, 0);
  textSize(22.5);
  text ("Lives = " + lives, 1060, 30);


  if (lives< 1) {
    fill(0);
    rect (0, 0, width, height);
    fill(255);
    textSize(200);
    text("Game Over", 50, width / 2 - 200);
  }
}
float xpos;
float ypos;





void mousePressed() {
  bullets.add(new Bullet(int(random(180, 220)), 200, 200, mySpaceship.xpos, 880, 10));
}



class Alien {
  color h;
  color s;
  color b;
  float a;
  float xpos;
  float true_xpos;
  float true_ypos;
  float ypos;
  float xspeed; 
  float d;
  float r;
  boolean imaDeadAlien=false;



  Alien(color h_, color s_, color b_, float a_, float xpos_, float ypos_, float xspeed_) {
    h= h_;
    s= s_;
    b= b_;
    a=a_;
    xpos = xpos_;
    ypos = ypos_;
    xspeed = xspeed_;
  } 

  void display() {
    noStroke();
    fill(#A00AED);
    r=40;
    true_xpos=xpos+200;
    true_ypos=ypos+200;
    ellipse(true_xpos, true_ypos, r, r);
    fill(#ff0000);
    ellipse(true_xpos - 6.5, true_ypos - 4, 5, 5);
    ellipse(true_xpos + 6.5, true_ypos - 4, 5, 5);
  }




  void move() {
    xpos = xpos + xspeed;
  } 

  void shift() {
    if (xpos+200 >= width-100) {
      ypos=ypos+40;
      xspeed=(xspeed*(-1));
    } 
    if (xpos+200<= 100) {
      ypos=ypos+40;
      xspeed=xspeed*(-1);
    }
  }
  void destroyed() {
    imaDeadAlien=true;
  }

  void exitStageLeft() {
    if (imaDeadAlien==true) {
      xpos=-2000;
      xspeed=0;
    }
  }
}

class Bomb {
  int h;
  int s;
  int b;
  float xpos;
  float ypos;
  float yspeed;


  Bomb(int temp_h, int temp_s, int temp_b, float temp_xpos, float temp_ypos, float temp_yspeed) {
    h= temp_h;
    s= temp_s;
    b= temp_b;
    xpos = temp_xpos;
    ypos = temp_ypos;
    yspeed = temp_yspeed;
  } 

  void display() {
    fill(h, s, b);
    rect(xpos, ypos, 4, 10);
  }




  void fire() {
    ypos=ypos-yspeed;
  }

  boolean finished() {

    if (ypos-yspeed < 50 || ypos-yspeed > 950) return true;
    else return false;
  }

  boolean intersect() { 
    float distance = dist(xpos, ypos, mySpaceship.xpos, mySpaceship.ypos);
    if (distance < 25) {
      return true;
    } 
    else {
      return false;
    }
  }
}


class Bullet {
  int h;
  int s;
  int b;
  float xpos;
  float ypos;
  float yspeed;


  Bullet(int temp_h, int temp_s, int temp_b, float temp_xpos, float temp_ypos, float temp_yspeed) {
    h= temp_h;
    s= temp_s;
    b= temp_b;
    xpos = temp_xpos;
    ypos = temp_ypos;
    yspeed = temp_yspeed;
  } 

  void display() {
    fill(h, s, b);
    rect(xpos, ypos, 4, 10);
  }




  void fire() {
    ypos=ypos-yspeed;
  }

  boolean finished() {

    if (ypos-yspeed < 50 || ypos-yspeed > 950) return true;
    else return false;
  }

  boolean intersect(Alien a) {
    float distance = dist(xpos, ypos, a.true_xpos, a.true_ypos);
    if (distance < 20) {
      return true;
    } 
    else {
      return false;
    }
  }
}





class Spaceship {
  
  int h;
  int s;
  int b;
  float xpos;
  float ypos;

  
  Spaceship(int temp_h, int temp_s, int temp_b, float temp_xpos, float temp_ypos) {
    h=temp_h;
    s=temp_s;
    b=temp_b;
    xpos=temp_xpos;
    ypos=temp_ypos;
  }

  void display() {
    noStroke();
    fill(h, s, b);
    ellipse(xpos, ypos, 50, 50);
    imageMode(CENTER);
    image(sub,xpos,ypos);
  }

  void move() {
    xpos=mouseX;
    noCursor();
  }

  void limit_x() {
    if (mouseX<100) {
      xpos=100;
    }
    if (mouseX>(width-100)) {
      xpos=(width-100);
    }
  } 





  void lastGuy() {
    println(deadAliens);
    if (deadAliens==49) {
      lastGuy=1000;
    } 
    else { 
      lastGuy=0;
    }
  }
}
class Timer {
  int savedTime;
  int totalTime;

  Timer(int tempTotalTime) {
    totalTime=tempTotalTime;
  } 

  void start() {
    savedTime= millis();
  }

  boolean isFinished() {
    int passedTime = millis()-savedTime-(lastGuy);

    if (passedTime > totalTime) {
      return true;
    } 
    else {
      return false;
    }
  }
} 
