class Ground {
    float x1, y1, z1, x2, y2, z2;
    float x, y, z, len, distX, distY, distZ;
    PVector[][] rectCoord;
    int morceauX;
    int morceauY;
    boolean isCut = false;
    //Constructor
    Ground(float x1, float y1, float z1, float x2, float y2, float z2) {
        this.x1 = x1;
        this.y1 = y1;
        this.z1 = z1;
        this.x2 = x2;
        this.y2 = y2;
        this.z2 = z2;
        
        x = x1;
        y = y1;
        z = z1;
        
        len = dist(x1, y1, z1, x2, y2, z2);
        distX = x2 - x1;
        distY = y2 - y1;
        distZ = z2 - z1;
        println("X "+ distX);
        println("Y "+ distY);
        println("Z "+ distZ);
}
    
    //Display method
    void display() {
        fill(200);
        if (!isCut) {
            pushMatrix();
            translate(x, y, z);
            beginShape(QUADS);
            vertex(0, 0, 0);
            vertex(0, distY, 0);
            vertex(distX, distY, 0);
            vertex(distX, 0, 0);
            endShape();
            popMatrix();
        } else{
            for (int i = 0; i < morceauY - 1; i++) {
                for (int j = 0; j < morceauX - 1; j++) {
                    float rectX1 = rectCoord[j][i].x;
                    float rectY1 = rectCoord[j][i].y;
                    float rectZ1 = rectCoord[j][i].z;
                    
                    float rectX2 = rectCoord[j + 1][i].x;
                    float rectY2 = rectCoord[j + 1][i].y;
                    float rectZ2 = rectCoord[j + 1][i].z;
                    
                    float rectX3 = rectCoord[j + 1][i + 1].x;
                    float rectY3 = rectCoord[j + 1][i + 1].y;
                    float rectZ3 = rectCoord[j + 1][i + 1].z;
                    
                    float rectX4 = rectCoord[j][i + 1].x;
                    float rectY4 = rectCoord[j][i + 1].y;
                    float rectZ4 = rectCoord[j][i + 1].z;
                    
                    pushMatrix();
                    translate(rectX1, rectY1, rectZ1);
                    fill(131,101,57);
                    beginShape(QUADS);
                    vertex(0, 0, 0);
                    vertex(rectX2 - rectX1, rectY2 - rectY1, rectZ2 - rectZ1);
                    vertex(rectX3 - rectX1, rectY3 - rectY1, rectZ3 - rectZ1);
                    vertex(rectX4 - rectX1, rectY4 - rectY1, rectZ4 - rectZ1);
                    endShape();
                    popMatrix();
                }
        }
        }
}
    
    void split(int nbX, int nbY) {
        nbX++;
        nbY++;
        float smallerRectWidth = distX / nbX;
        float smallerRectHeight = distY / nbY;
        this.morceauX = nbX;
        this.morceauY = nbY;
        this.rectCoord = new PVector[nbX][nbY];
        for (int i = 0; i < nbY; i++) {
            for (int j = 0; j < nbX; j++) {
                float rectX = x + j * smallerRectWidth;
                float rectY = y + i * smallerRectHeight;
                float noiseValue = noise(rectX * 0.01, rectY * 0.01);
                float rectZ = z + map(noiseValue, 0, 1, 0, 100);
                rectCoord[j][i] = new PVector(rectX, rectY, rectZ);
                // println(rectCoord[j][i]);
            }
        }
        isCut = true;
    }
    float getHeightOfGround(float groundX, float groundY){
      if (!isCut) {
        if (groundX < x1 || groundX > x2 || groundY< y1 || groundY > y2){
          return 9999;
        }
        float uncutX = groundX /distX;
        float uncutY = groundY /distY;
        if (uncutX <= (1-uncutY)){
          return barycentre(new PVector(0, 0, z1), new PVector(1,0, z2), new PVector(0,1, z1), new PVector(uncutX, uncutY));
        }else{
          return barycentre(new PVector(1,0,z2), new PVector(1,1,z2), new PVector(0,1,z1), new PVector(uncutX, uncutY));
        }

      }
      float sizeCelluleX = distX/morceauX;
      float sizeCelluleY = distY/morceauY;
      int indiceX = floor(groundX/sizeCelluleX);
      int indiceY = floor(groundY/sizeCelluleY);
      if (indiceX >= morceauX-1 || indiceX <0 || indiceY>=morceauY-1 || indiceY<0){
        return defaultZ;
      }
      //UP LEFT
      PVector p1 = rectCoord[indiceX][indiceY];
      //UP RIGHT
      PVector p2 = rectCoord[indiceX+1][indiceY];
      //DOWN RIGHT
      PVector p3 = rectCoord[indiceX+1][indiceY+1];
      //DOWN LEFT
      PVector p4 = rectCoord[indiceX][indiceY+1];
      // println("P1 Z :"+(p1) +",P2 Z :"+(p2)+", P3 Z :"+(p3)+",P4 Z :"+(p4));
      float xCoord = (groundX% sizeCelluleX)/sizeCelluleX;
      float yCoord = (groundY% sizeCelluleY)/sizeCelluleY;
      float hauteur;
      // Barycentric coordinate system
      if (xCoord <= (1-yCoord)){
        hauteur = barycentre(new PVector(0, 0, p1.z), new PVector(1,0, p2.z), new PVector(0,1, p4.z), new PVector(xCoord, yCoord));
      }else{
        hauteur = barycentre(new PVector(1,0,p2.z), new PVector(1,1,p3.z), new PVector(0,1,p4.z), new PVector(xCoord, yCoord));
      }
      return hauteur;
    }

    float barycentre(PVector p1,PVector p2,PVector p3,PVector pos){
      float det = (p2.y - p3.y) * (p1.x - p3.x) + (p3.x - p2.x) * (p1.y - p3.y);
		  float l1 = ((p2.y - p3.y) * (pos.x - p3.x) + (p3.x - p2.x) * (pos.y - p3.y)) / det;
		  float l2 = ((p3.y - p1.y) * (pos.x - p3.x) + (p1.x - p3.x) * (pos.y - p3.y)) / det;
		  float l3 = 1.0f - l1 - l2;
		  return l1 * p1.z + l2 * p2.z + l3 * p3.z;
    }
}
