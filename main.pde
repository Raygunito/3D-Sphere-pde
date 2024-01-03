/*
On utilisera comme système de coordonnée suivant (celui utilisé par Processing) : 
(x,y) la position
(z) la profondeur
De plus Processing utilise la méthode de la main gauche, 
  la profondeur Z est négative lorsqu'on s'éloigne de la caméra, 
  et positive lorsqu'on se rapproche de la caméra.
*/
int defaultZ = -100;
PVector gravity = new PVector(0,0, - 0.0981);
int offX = 0;
int offY = 0;
Ground ground;
Orb ball;
float verticalTranslate = 0;

void setup() {
    size(1280, 720, P3D);
    ground = new Ground(0, 0, defaultZ, width , height, defaultZ);
    ground.split(4,4);
    ball = new Orb(width / 2,height / 2,150,10);
}

void draw() {
    background(0);
    lights();
    float rotY = map(mouseY,0,height,-PI/5,PI/5);
    rotateX(rotY);
    translate(0, height / 3,-300); 
    rotateX(radians(60)); 
    translate(offX,offY,0);
    drawAxles();
    pushMatrix();
    ball.display();
    ball.move();
    ball.checkCollision(ground);
    ground.display();
    popMatrix();
    if(keyPressed){
        if (key == CODED){
           if (keyCode == UP){
               offY += 5;
        } else if (keyCode == DOWN){
               offY -= 5;
        } else if (keyCode == LEFT) {
               offX += 5;
        } else if (keyCode == RIGHT){
               offX -= 5;
        }
      }
    }
}

void drawAxles(){
  stroke(255,0,0); 
  line(0,0, 150,0);
  stroke(0,255,0); 
  line(0, 0, 0, 150);
  stroke(0,0,255);
  line(0,0,0,0,0,-150);
}