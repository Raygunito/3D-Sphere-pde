class Orb {
    PVector position;
    PVector velocity;
    float r;
    float damping = 0.85;
    
    Orb(float x, float y, float z, float rayon) {
        position = new PVector(x, y, z);
        // velocity = new PVector(0,0,0);
        velocity = new PVector(random(-1, 1),random(-1, 1),0);
        r = rayon;
    }
        
    void move() {
        velocity.add(gravity);
        position.add(velocity);
        // println("("+position.x + ", "+position.y+", "+ position.z+ ")");
    }
            
    void display() {
        noStroke();
        fill(0,255,0);
        pushMatrix();
        translate(position.x, position.y, position.z);
        sphere(r);
        popMatrix();
    }
                
    void checkCollision(Ground ground) {
      // println(ground.getHeightOfGround(position.x,position.y));
        if (ground.isCut) {
            if (position.z - r < ground.getHeightOfGround(position.x,position.y) && velocity.z < 0 && position.x >= ground.x1 && position.x < ground.x2 && position.y >= ground.y1 && position.y < ground.y2) {
                
                float sizeCelluleX = ground.distX/ground.morceauX;
                float sizeCelluleY = ground.distY/ground.morceauY;
                int indiceX = floor(position.x/sizeCelluleX);
                int indiceY = floor(position.y/sizeCelluleY);
                if (indiceX >= ground.morceauX-1 || indiceX <0 || indiceY>=ground.morceauY-1 || indiceY<0){
                  return ;
                }
                //UP LEFT
                PVector p1 = ground.rectCoord[indiceX][indiceY];
                //UP RIGHT
                PVector p2 = ground.rectCoord[indiceX+1][indiceY];
                //DOWN RIGHT
                PVector p3 = ground.rectCoord[indiceX+1][indiceY+1];
                //DOWN LEFT
                PVector p4 = ground.rectCoord[indiceX][indiceY+1];

                float xCoord = (position.x% sizeCelluleX)/sizeCelluleX;
                float yCoord = (position.y% sizeCelluleY)/sizeCelluleY;

                PVector base1 = PVector.sub(p2, p1);
                PVector base2 = PVector.sub(p3, p1);
                if (xCoord < 1-yCoord) {
                  base1 = PVector.sub(p2, p1);
                  base2 = PVector.sub(p3, p1);
                }else {
                  if (yCoord < 1-xCoord){
                    base1 = PVector.sub(p4, p1);
                    base2 = PVector.sub(p3, p4);
                  }else{
                    if (xCoord >= 1-yCoord) {
                      base1 = PVector.sub(p3, p2);
                      base2 = PVector.sub(p3, p4);
                    }else{
                      base1 = PVector.sub(p2, p1);
                      base2 = PVector.sub(p3, p2);
                    }
                  }
                }

                PVector delta = PVector.sub(base2,base1).normalize();
                PVector normal = base1.cross(base2).normalize();
                PVector incidence = PVector.mult(velocity,-1);
                incidence.normalize();
                
                float dot = incidence.dot(normal);

                velocity.set((2*normal.x*dot - incidence.x), (2*normal.y*dot - incidence.y), -1*(2*normal.z*dot - incidence.z)* velocity.z);
                // velocity.z *=-1;
                velocity.mult(damping);
                if (position.z - r <= ground.getHeightOfGround(position.x,position.y) && position.z - r >= (ground.getHeightOfGround(position.x,position.y) - (r*0.2))) {
                    position.z = ground.getHeightOfGround(position.x,position.y) + r;
                }
            }
      } else{
            if (position.z - r < ground.z && velocity.z < 0 && position.x >= ground.x1 && position.x < ground.x2 && position.y >= ground.y1 && position.y < ground.y2) {
                velocity.z *=-1;
                velocity.mult(damping);
                //If the ball is very near to the ground within a treshold we just assume there is no more bounce
                if (position.z - r <= ground.z && position.z - r >= ground.z - (r*0.2)) {
                    position.z = ground.z + r;
                }
            }
        }
    }
}
                    