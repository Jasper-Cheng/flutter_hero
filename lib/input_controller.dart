import 'package:flutter/cupertino.dart';
import 'package:flutter_hero/player.dart';

late double touchAnchorX;
late double touchAnchorY;
int moveSensitivity=20;
late Player player;
void init(Player inPlayer){
  player=inPlayer;
}
void onPanStart(DragStartDetails details){
  touchAnchorX=details.globalPosition.dx;
  touchAnchorY=details.globalPosition.dy;
  player.moveHorizontal=0;
  player.moveVertical=0;
}

void onPanUpdate(DragUpdateDetails details){
  if(details.globalPosition.dx<touchAnchorX-moveSensitivity){
    player.moveHorizontal=-1;
    player.orientationChanged();
  }else if(details.globalPosition.dx>touchAnchorX+moveSensitivity){
    player.moveHorizontal=1;
    player.orientationChanged();
  }else{
    player.moveHorizontal=0;
    player.orientationChanged();
  }
  if(details.globalPosition.dy<touchAnchorY-moveSensitivity){
    player.moveVertical=-1;
    player.orientationChanged();
  }else if(details.globalPosition.dy>touchAnchorY+moveSensitivity){
    player.moveVertical=1;
    player.orientationChanged();
  }else{
    player.moveVertical=0;
    player.orientationChanged();
  }
}

void onPanEnd(dynamic details){
  player.moveHorizontal=0;
  player.moveVertical=0;
}
