PGraphics area;
int scrollX = 0;
int scrollY = 0;
PImage img;

void setup() {
  // initial window size
  size(640, 360, P2D);

  // allow window to be resized
  surface.setResizable(true);
  
  // load an image from the web
  img = loadImage("http://processing.org/img/processing-web.png");

  // create a graphics object with a dimension of 720p
  area = createGraphics(720, 480, P2D);
}

void drawScrollArea() {
  area.beginDraw();
  area.background(0);
  if (img != null) {
    for (int i = 0; i < 5; i++) {
      area.image(img, 0, img.height * i);
    }
  }
  area.endDraw();
}

// by default, draw() is called continuously

void draw() {
  drawScrollArea();
  
  // draw the graphics object onto our screen
  // with the top left and top right (origin) offset
  // being the value of scrollX and scrollY
  image(area, scrollX, scrollY);
}

void mousePressed() {}
void mouseDragged() {}
void mouseReleased() {}
