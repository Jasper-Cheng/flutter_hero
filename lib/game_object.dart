import 'package:flutter/cupertino.dart';

class GameObject{
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  String baseFilename = "";

  int width = 0;
  int height = 0;

  double x = 0.0;
  double y = 0.0;

  //frame总数
  int numFrames = 0;
  //多长时间跳到下一个frame
  int  frameSkip = 0;
  //当前是那一个frame
  int currentFrames = 0;
  //0-frameSkip之间的计数
  int frameCount = 0;
  List frames = [];

  bool visible = true;

  GameObject(this.screenWidth,
      this.screenHeight,
      this.baseFilename,
      this.width,
      this.height,
      this.numFrames,
      this.frameSkip){
    for(int i=0;i<numFrames;i++){
      frames.add(Image.asset("assets/$baseFilename-$i.png"));
    }
  }

  void animate(){
    frameCount++;
    if(frameCount>frameSkip){
      frameCount=0;
      currentFrames++;
      if(currentFrames==numFrames){
        currentFrames=0;
      }
    }
  }

  Widget draw(){
    return visible? Positioned(left: x,top: y,child: frames[currentFrames]):
    Positioned(child: Container());
  }

}