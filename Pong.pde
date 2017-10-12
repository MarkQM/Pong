//import processing.sound.*;
//SoundFile paddle1sound;
//SoundFile paddle2sound;
//SoundFile player1win;
//SoundFile player2win;

//PImage bg;
//PImage cPaddle;
//PImage hPaddle;
//PImage ballImage;


String message1 = "Toggle Mouse Control [ON]";
String message2 = "Toggle Mouse Control [OFF]";
String message3 = "Toggle Human Player [OFF]";
String message4 = "Toggle Human Player [ON]";

boolean mouseOn;
boolean menu;
boolean humanPlayer2;

boolean ballChecked;

float AIinertia;

int menuSelect;
int computerDifficulty;

int borderDist;

int rad;
float xpos;
float ypos;

int ypad1;
int ypad2;

int pad1Size;
int pad2Size;

int pad1Width;
int pad2Width;

float xspeed;
float yspeed;

int player1Score;
int player2Score;

boolean standbyMode;


void setup(){
  size(500, 300);
  fill(255);
  ellipseMode(CENTER);
  rectMode(RADIUS);
  frameRate(60);
  textSize(width/40);
  noStroke();
  
  //bg = loadImage("pong_background.png");
  //cPaddle = loadImage("computer_paddle.png");
  //hPaddle = loadImage("human_paddle.png");
  //ballImage = loadImage("ball.png");
  
  //paddle1sound = new SoundFile(this, "paddle1sound.mp3");
  //SoundFile paddle2sound = new SoundFile(this, "paddle2sound.mp3");
  //SoundFile player1win = new SoundFile(this, "player1win.mp3");
  //SoundFile player2win = new SoundFile(this, "player2win.mp3");
  
  player1Score = 0;
  player2Score = 0;
  
  standbyMode = true;
  mouseOn = true;
  menu = true;
  humanPlayer2 = false;
  
  menuSelect = 0;
  computerDifficulty = 1;
  
  borderDist = 20;
  
  
  ypad1 = height/2;
  ypad2 = height/2;
  
  rad = 5+width/40;
  xpos = width/2;
  ypos = height/2;
  
  pad1Size = 40;
  pad2Size = 40;
  
  pad1Width = width/50;
  pad2Width = width/50;
  
  xspeed = 0;
  yspeed = 0;
  
}



void draw(){
  background(0);
  //image(bg, 0, 0, width, height);
  
  
  if(menu){
    runMenu();
  }
  else{
    playGame();
  }
}


void playGame(){
  humanControl();
  
  if(!humanPlayer2){
  computerControl();
  }
  
  drawPaddle1();
  drawPaddle2();
  drawBall();
  if(!standbyMode){
  handleBall();
  }
}

void humanControl(){
  if(mouseOn){
    ypad2 = mouseY;
  }
}

void computerControl(){
  
  switch(computerDifficulty){
    case 1:
       basicAI();
       break;
    
    case 2:
       moderateAI();
       break;
    
    case 3:
        hardAI();
        break;
    
  }
}


void drawPaddle1(){
  rect(borderDist, ypad1, pad1Width, pad1Size);
}


void drawPaddle2(){
  rect(width-borderDist, ypad2, pad2Width, pad2Size);
}


void drawBall(){
  ellipse(xpos, ypos, rad, rad);
  
}


void collide1(){
  
  xpos = borderDist + pad1Width+0.1;
  
  xspeed = random(1,1.3)*(6.5 + (abs(ypad1 - ypos))*3.5/(pad1Size));
  yspeed = random(1,1.5)*-((ypad1 - ypos)*6/pad1Size);
  
  //if(xspeed >= pad2Width){
  //  xspeed = pad2Width-0.1;
    
  //}
  
  ballChecked = false;
  
  //println((abs(ypad1 - ypos))*4/(pad1Size));
  
}


void collide2(){
 
 
  xpos = width - borderDist - pad2Width-0.1;
  
  xspeed = random(1,1.3)*-(5.5 + (abs(ypad2 - ypos)*4/pad2Size));
  yspeed = random(1,1.5)*-((ypad2 - ypos)*6/pad2Size);
  
  //if(xspeed >= pad1Width){
  //  xspeed = pad1Width-0.1;
  //}
  
  ballChecked = false;
  
  //println((abs(ypad2 - ypos)*4/pad2Size));
  
}


void handleBall(){
  
  checkBall();

  //xpos+=xspeed;
  //ypos+=yspeed;
  //println("x: " + xpos + " y: " + ypos);
  
  if(ypos + rad >= height){
    ypos = height-0.1 - rad;
    yspeed = -yspeed;
  }
  
  if(ypos - rad <= 0){
    ypos = 0.1 + rad;
    yspeed = -yspeed;
  }
  
  if(ypos-rad <= ypad1+pad1Size && ypos+rad >= ypad1-pad1Size
  && xpos >= borderDist && xpos <= borderDist + pad1Width){
    collide1();
    //println("hit1!" + xpos);
  }
  
  if(ypos-rad <= ypad2+pad2Size && ypos+rad >= ypad2-pad2Size
  && xpos <= width - borderDist && xpos >= width - borderDist - pad2Width){
    collide2();
    //println("hit2!" + xpos);
  }
  
  if(xpos < 0){
    player1Score++;
    //println("hitbox1:" + (borderDist));
    //println("hitbox2:" + (borderDist + pad1Width));
    //println(xpos);
    reset();
  }
  
  if(xpos > width){
    player2Score++;
    //println("hitbox3: " + (width - borderDist));
    //println("hitbox4: " + (width - borderDist - pad2Width));
    //println(xpos);
    reset();
  }
  
}

void startGame(){
  standbyMode = false;
  xspeed = random(-5,-3);
  yspeed = random(-1,1);
}

void reset(){
  standbyMode = true;
  
  xspeed = 0;
  yspeed = 0;
  
  ypad1 = height/2;
  ypad2 = height/2;
  
  xpos = width/2;
  ypos = height/2;
  
}

void keyPressed(){
  
  if(menu){
    
    if(key == ENTER){
      execute();
    }
    
    if(keyCode == UP){
      menuSelect--;
      if(menuSelect<0){
        menuSelect = 2;
      }
    }
    
    if(keyCode == DOWN){
      menuSelect++;
      menuSelect = menuSelect%3;
    }
  }
  
  
  if(!mouseOn && !menu){
    if(keyCode == UP && ypad2>pad2Size){
      ypad2-=height/10;
    }
    if(keyCode == DOWN && ypad2<height-pad2Size){
      ypad2+=height/10;
    }
  }
  
  if(humanPlayer2 && !menu){
    
    if(key == 'w' && ypad1>pad1Size){
      ypad1 -= height/10;
    }
    
    if(key == 's' && ypad1<height-pad1Size){
      ypad1 += height/10;
    }
  }
  
  
  if(key == ' '&& standbyMode && !menu){
    startGame();
  }
  
  if(key == '1'){
    computerDifficulty = 1;
  }
  
  if(key == '2'){
    computerDifficulty = 2;
  }
  
  if(key == '3'){
    computerDifficulty = 3;
    
  }
  
  
  if(keyCode == BACKSPACE){
    reset();
    menu = true;
    
  }
  
}

void checkBall(){
  if(xpos + xspeed - rad < borderDist + pad1Width && !ballChecked){
    xpos = borderDist + pad1Width + rad;
    ballChecked = true;
  }
  
  else if(xpos + xspeed + rad > width - borderDist - pad2Width && !ballChecked){
    xpos = width - borderDist - pad2Width - rad;
    ballChecked = true;
  }
  
  else{
    xpos += xspeed;
    ypos += yspeed;
  }
  
  
}
  
void mousePressed(){
  if(standbyMode && mouseOn && !menu){
    startGame();
  }
}

void runMenu(){
  
  drawMenu();
  //println(menuSelect);
}
  
  

void drawMenu(){

  
  fill(255);
  switch(menuSelect){
    case 0:
      ellipse((width/3), (5*height/8), (width/40), (width/40));
      break;
      
    case 1:
      ellipse(width/3, (6*height/8), width/40, width/40);
      break;
      
    case 2:
      ellipse(width/3, (7*height/8), width/40, width/40);
      break;
  }
  
  text("Play", width/3 + 20, 5*height/8); 
  
  if(mouseOn){
  text(message1, width/3 + 20, 6*height/8);
  }
  else{
      text(message2, width/3 + 20, 6*height/8);
  }
  
  if(!humanPlayer2){
  text(message3, width/3 + 20, 7*height/8);
  }
  else{
    text(message4, width/3 + 20, 7*height/8);
  }
}

void execute(){
    switch(menuSelect){
    case 0: 
      menu=false;
      break;
      
    case 1:
      mouseOn = !mouseOn;
      break;
      
    case 2:
      humanPlayer2 = !humanPlayer2;
      break;
  }
}

void basicAI(){
  
  AIinertia = random(0.8,2.5);
  
  if(xpos < 3*width/4){
  
    if(ypos > ypad1+pad1Size/3){
      ypad1+=(height/100)*AIinertia;
    
    }
  
    if(ypos < ypad1-pad1Size/3){
      ypad1 -= (height/100)*AIinertia;
    }
  }
}

void moderateAI(){
  
   AIinertia = random(0.9,3);
  
  if(xpos < 4*width/5){
    
    if(ypos > ypad1+(pad1Size/2)){
      ypad1 += (height/100)*AIinertia;
    
    }
  
    if(ypos < ypad1-(pad1Size/2)){
      ypad1 -= (height/100)*AIinertia;
    }
    
  }
}

void hardAI(){
  
  AIinertia = random(1.6,4);
  
  if(xpos > 4*width/5){
    
    if(ypos > ypad2 || ypad2 + pad2Size/2 < height){
      ypad1 += (height/200)*AIinertia;
    }
    
    else if(ypos < ypad2 || ypad2 - pad2Size > 0){
      ypad1 -= (height/200)*AIinertia;
      
    }
  }
  
  else if(ypos > ypad1+(3*pad1Size/4)){
      ypad1 += (height/80)*AIinertia; 
    }
  
  else if(ypos < ypad1-(3*pad1Size/4)){
      ypad1 -= (height/80)*AIinertia;
    }
  
}