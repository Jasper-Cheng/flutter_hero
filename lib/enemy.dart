import 'package:flutter_hero/game_object.dart';

class Enemy extends GameObject {
  int speed=0;
  //从左往右或从右往左
  int moveDirection=0;
  Enemy(double screenWidth, double screenHeight, String baseFilename, int width, int height, 
      int numFrames, int frameSkip, this.moveDirection, this.speed) :
        super(screenWidth, screenHeight, baseFilename, width, height, numFrames, frameSkip);

  void move(){
    if(moveDirection==1){
      x=x+speed;
      if(x>screenWidth+width){
        x=-width.toDouble();
      }
    }else{
      x=x-speed;
      if(x<-width){
        x=screenWidth+width.toDouble();
      }
    }
  }
  
}