import 'package:flutter/cupertino.dart';
import 'package:flutter_hero/game_object.dart';

class Player extends GameObject{
  int speed=0;
  //-1左，0静止,1右
  int moveHorizontal=0;
  //-1上，0静止,1下
  int moveVertical=0;
  //携带的水晶能量
  double energy=0.0;

  Player(double screenWidth, double screenHeight, String baseFilename, int width, int height,
      int numFrames, int frameSkip,this.speed) :
        super(screenWidth, screenHeight, baseFilename, width, height, numFrames, frameSkip);

  //预先定义好常规角度对应的弧度map表,以提高响应时间
  Map anglesToRadiansConversionTable={
    "angle45":0.7853981633974483,
    "angle90":1.5707963267948966,
    "angle135":2.356194490192345,
    "angle180":3.141592653589793,
    "angle225":3.9269908169872414,
    "angle270":4.71238898038469,
    "angle315":5.497787143782138
  };
  double radians=0.0;


  @override
  Widget draw(){
    return visible?Positioned(left: x,top: y,child:
    Transform.rotate(angle: radians,child: frames[currentFrames])):
    Positioned(child: Container());
  }

  void orientationChanged(){
    radians=0.0;
    if(moveHorizontal==1&&moveVertical==-1){
      radians=anglesToRadiansConversionTable["angle45"];
    }else if(moveHorizontal==1&&moveVertical==0){
      radians=anglesToRadiansConversionTable["angle90"];
    }else if(moveHorizontal==1&&moveVertical==1){
      radians=anglesToRadiansConversionTable["angle135"];
    }else if(moveHorizontal==0&&moveVertical==1){
      radians=anglesToRadiansConversionTable["angle180"];
    }else if(moveHorizontal==-1&&moveVertical==1){
      radians=anglesToRadiansConversionTable["angle225"];
    }else if(moveHorizontal==-1&&moveVertical==0){
      radians=anglesToRadiansConversionTable["angle270"];
    }else if(moveHorizontal==-1&&moveVertical==-1){
      radians=anglesToRadiansConversionTable["angle315"];
    }
  }

  void move(){
    if(x>0&&moveHorizontal==-1)x=x-speed;
    if(x<(screenWidth-width)&&moveHorizontal==1)x=x+speed;
    if(y>40&&moveVertical==-1)y=y-speed;
    if(y<(screenHeight-height-10)&&moveVertical==1)y=y+speed;
  }
}