import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hero/enemy.dart';
import 'package:flutter_hero/game_object.dart';
import 'package:flutter_hero/player.dart';

import 'input_controller.dart' as input_controller;

late State state;
Random random=Random();
int score=0;
late double screenWidth;
late double screenHeight;
late AnimationController gameLoopController;
late Animation gameLoopAnimation;
late GameObject crystal;
List fish=[];
List robots=[];
List aliens=[];
List asteroids=[];
late Player player;
late GameObject planet;
List explosions=[];
late AudioCache audioCache;
bool isTimerSet=false;
bool isTouchCrystal=false;

void firstTimeInitialization(BuildContext inContext,dynamic inState){
  state=inState;
  audioCache=AudioCache();
  audioCache.loadAll(["delivery.mp3","explosion.mp3","fill.mp3","thrust.mp3"]);
  screenWidth=MediaQuery.of(inContext).size.width;
  screenHeight=MediaQuery.of(inContext).size.height;
  crystal = GameObject(screenWidth, screenHeight, "crystal", 32, 30, 4, 6);
  planet = GameObject(screenWidth, screenHeight, "planet", 64, 64, 1, 0);
  player=Player(screenWidth, screenHeight, "player", 40, 34, 2, 6, 10);
  fish=[
    Enemy(screenWidth, screenHeight, "fish", 48, 48, 2, 6, 1, 4),
    Enemy(screenWidth, screenHeight, "fish", 48, 48, 2, 6, 1, 4),
    Enemy(screenWidth, screenHeight, "fish", 48, 48, 2, 6, 1, 4),
  ];
  robots=[
    Enemy(screenWidth, screenHeight, "robot", 48, 48, 2, 6, 1, 4),
    Enemy(screenWidth, screenHeight, "robot", 48, 48, 2, 6, 1, 4),
    Enemy(screenWidth, screenHeight, "robot", 48, 48, 2, 6, 1, 4),
  ];
  aliens=[
    Enemy(screenWidth, screenHeight, "alien", 48, 48, 2, 6, 1, 4),
    Enemy(screenWidth, screenHeight, "alien", 48, 48, 2, 6, 1, 4),
    Enemy(screenWidth, screenHeight, "alien", 48, 48, 2, 6, 1, 4),
  ];
  asteroids=[
    Enemy(screenWidth, screenHeight, "asteroid", 48, 48, 2, 6, 1, 4),
    Enemy(screenWidth, screenHeight, "asteroid", 48, 48, 2, 6, 1, 4),
    Enemy(screenWidth, screenHeight, "asteroid", 48, 48, 2, 6, 1, 4),
  ];
  gameLoopController=AnimationController(vsync: inState,duration: const Duration(milliseconds: 1000));
  gameLoopAnimation=Tween(begin: 0,end: 17).animate(CurvedAnimation(parent: gameLoopController, curve: Curves.linear));
  gameLoopAnimation.addStatusListener((status) {
    if(status==AnimationStatus.completed){
      gameLoopController.reset();
      gameLoopController.forward();
    }
  });
  gameLoopAnimation.addListener(() {
    gameLoop();
  });
  resetGame(true);
  input_controller.init(player);
  gameLoopController.forward();
}


Future<void> resetGame(bool inResetEnemies)async {
  if(isTimerSet){

  }
  player.energy=0.0;
  player.x=(screenWidth/2)-(player.width/2);
  player.y=screenHeight-player.height-24;
  player.moveVertical=0;
  player.moveHorizontal=0;
  player.orientationChanged();
  crystal.y=34.0;
  randomlyPositionObject(crystal);
  planet.y=screenHeight-planet.height-10;
  randomlyPositionObject(planet);
  if(inResetEnemies){
    List xValsFish=[70.0,192.0,312.0];
    List xValsRobtos=[64.0,192.0,320.0];
    List xValsAliens=[44.0,192.0,340.0];
    List xValsAsteroids=[24.0,192.0,360.0];
    for(int i=0;i<3;i++){
      fish[i].x=xValsFish[i];
      robots[i].x=xValsRobtos[i];
      aliens[i].x=xValsAliens[i];
      asteroids[i].x=xValsAsteroids[i];
      fish[i].y=110.0;
      robots[i].y=fish[i].y+120;
      aliens[i].y=robots[i].y+130;
      asteroids[i].y=aliens[i].y+140;
      fish[i].visible=true;
      robots[i].visible=true;
      aliens[i].visible=true;
      asteroids[i].visible=true;
    }
  }
  explosions=[];
  player.visible=true;
}

void gameLoop(){
  crystal.animate();
  for(int i=0;i<3;i++){
    fish[i].move();
    fish[i].animate();
    robots[i].move();
    robots[i].animate();
    aliens[i].move();
    aliens[i].animate();
    asteroids[i].move();
    asteroids[i].animate();
  }
  player.move();
  player.animate();
  for(int i=0;i<explosions.length;i++){
    explosions[i].animate();
    if(!isTimerSet){
      Timer(const Duration(seconds: 2),(){
        resetGame(true);
        isTimerSet=false;
      });
      isTimerSet=true;
    }
  }
  if(collision(crystal)){
    transferEnergy(true);
  }else if(collision(planet)){
    transferEnergy(false);
  }else{
    if(player.energy>0&&player.energy<1){
      player.energy=0;
    }
  }
  for(int i=0;i<3;i++){
    if(!isTimerSet&&collision(fish[i])||collision(robots[i])||
        collision(aliens[i])||collision(asteroids[i])){
      audioCache.load("explosion.mp3");
      player.visible=false;
      GameObject explosion=GameObject(screenWidth, screenHeight, "explosion", 50, 50, 5, 4);
      explosion.x=player.x;
      explosion.y=player.y;
      explosions.add(explosion);
      score=score-50;
      if(score<0)score=0;
    }
  }
  state.setState(() {});
}

bool collision(GameObject object){
  if(!player.visible||!object.visible)return false;
  num left1=player.x;
  num right1=left1+player.width;
  num top1=player.y;
  num bottom1=top1+player.height;
  num left2=object.x;
  num right2=left2+object.width;
  num top2=object.y;
  num bottom2=top2+object.height;
  if(bottom1<top2)return false;
  if(top1>bottom2)return false;
  if(right1<left2)return false;
  return left1<=right2;
}

void randomlyPositionObject(GameObject object){
  object.x=(random.nextInt(screenWidth.toInt()-object.width)).toDouble();
  if(collision(object))randomlyPositionObject(object);
}
void transferEnergy(bool touchingCrystal){
  if(touchingCrystal){
    if(player.energy==0)audioCache.load("fill.mp3");
    player.energy=player.energy+0.01;
    if(player.energy>=1){
      player.energy=1;
      isTouchCrystal=true;
      randomlyPositionObject(crystal);
    }else{
      audioCache.load("delivery.mp3");
    }
  }else{
    if(!isTouchCrystal)return;
    player.energy=player.energy-0.01;
    if(player.energy>0){
      audioCache.load("delivery.mp3");
    }else{
      isTouchCrystal=false;
      player.energy=0;
      randomlyPositionObject(planet);
      audioCache.load("explosion.mp3");
      score=score+100;
      for(int i=0;i<3;i++){
        fish[i].visible=false;
        robots[i].visible=false;
        aliens[i].visible=false;
        asteroids[i].visible=false;
        GameObject explosion=GameObject(screenWidth, screenHeight, "explosion", 50, 50, 5, 4);
        explosion.x=fish[i].x;
        explosion.y=fish[i].y;
        GameObject explosion2=GameObject(screenWidth, screenHeight, "explosion", 50, 50, 5, 4);
        explosion2.x=robots[i].x;
        explosion2.y=robots[i].y;
        GameObject explosion3=GameObject(screenWidth, screenHeight, "explosion", 50, 50, 5, 4);
        explosion3.x=aliens[i].x;
        explosion3.y=aliens[i].y;
        GameObject explosion4=GameObject(screenWidth, screenHeight, "explosion", 50, 50, 5, 4);
        explosion4.x=asteroids[i].x;
        explosion4.y=asteroids[i].y;
        explosions.add(explosion);
        explosions.add(explosion2);
        explosions.add(explosion3);
        explosions.add(explosion4);
      }
    }
  }
}
