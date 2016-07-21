import processing.video.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


Minim minim;
AudioOutput out;
Noise noise;


wave wave = new wave(10);
float b_amount = 1.5;
float threshold = 0.3;

final color black = color(0,0,0);
final color white = color(255,255,255);


boolean c_disp = true;
color rgb; 
float brightness;


Capture camera;


void setup() {

  fullScreen();

  frameRate(30);
  // size(480,320);
 
  minim = new Minim(this);
  out = minim.getLineOut();
  
  noise = new Noise(1.0, Noise.Tint.WHITE);
  noise.patch(out);

  camera = new Capture(this, width, height);
  camera.start();

}



void draw() {

  loadPixels();


  for(int x=0; x<width; x+=1){
    for (int y = 0; y < height; y+=1) {

      float t = round( random(0,10) *10);
      t /= 10;

      if(t <= b_amount) set(x,y, black );
      else             set(x,y, white);

    }
  }



  camera.loadPixels(); 


  for(int x=width; x>0; x-=3){
    for (int y = 0; y < height; y+=2) {

      // int i = y*width + x;
      int i = y*width + width - x;
      rgb = camera.pixels[i];
      brightness = map( max(red(rgb), green(rgb), blue(rgb)), 0, 255, 0, 1);
      float t = random(0,1)*brightness;

      if(t<=threshold)
        set(x,y,black );

    }
  }




  wave.display();
  wave.update();


}


class wave{

  int speed,speed_org;
  int x,y;

  color c;

  wave(int temp_s){

    speed = temp_s;
    speed_org = temp_s;
    x = 0;
    y = 0;
    c = black;

  }

  void display(){

    for(int x=0; x<width; x+=1){
      set(x,y,c);
      set(x,y+1,c);
    }

  }

  void update(){


    if(frameCount % (height/speed) == 0) {

      //c_disp = !c_disp;
      // b_amount = (int)(random(6,11));
   
    }

    this.y =(y-speed >height )? 0 : y + speed;


    if(c_disp) c = black;
    else c= color(128);

  }


}





void captureEvent(Capture camera) {
  camera.read();

}