ScrollView view = new ScrollView();
ScrollBarView horizontalScrollBar = new ScrollBarView();
ScrollBarView verticalScrollBar = new ScrollBarView();

void setup() {
  // initial window size
  size(640, 360, P2D);
  
  // allow window to be resized
  surface.setResizable(true);
  
  view.setup();
  
  horizontalScrollBar.orientation = ScrollBarView.HORIZONTAL;
  verticalScrollBar.orientation = ScrollBarView.VERTICAL;
}

// by default, draw() is called continuously

void draw() {
  view.draw();
  
  // draw the graphics object onto our screen
  // with the top left and top right (origin) offset
  // being the value of scrollX and scrollY
  image(view.graphicsObject, view.scrollX, view.scrollY);
  horizontalScrollBar.draw();
  verticalScrollBar.draw();
}

void mousePressed() {}
void mouseDragged() {}
void mouseReleased() {}

class ScrollBarView {
  final static int HORIZONTAL = 0;
  final static int VERTICAL = 1;
  int trackWidth = 0, trackHeight = 0;
  int thumbX = 0, thumbY = 0, thumbWidth = 0, thumbHeight = 0;
  int orientation;
  int size = 40;
  
  void colorPurple() {
    fill(155, 155, 255);
  }

  void colorGrey() {
    fill(155, 155, 155);
  }
  
  void computeTrackSize() {
    if (orientation == VERTICAL) {
      trackWidth = size;
      trackHeight = height - size;
    } else {
      trackWidth = width - size;
      trackHeight = size;
    }
  }

  void drawTrack() {
    computeTrackSize();
    rectMode(CORNER);
    stroke(0);
    colorGrey();
    if (orientation == VERTICAL) {
      rect(width - size, 0, trackWidth, trackHeight);
    } else {
      rect(0, height - size, trackWidth, trackHeight);
    }
  }
  
  void computeThumbSize() {
    if (orientation == VERTICAL) {
      thumbWidth = size;
      thumbHeight = 10;
    } else {
      thumbWidth = 10;
      thumbHeight = size;
    }
  }

  void drawThumb() {
    computeThumbSize();
    rectMode(CORNER);
    stroke(0);
    colorPurple();
    if (orientation == VERTICAL) {
      rect(width - size, thumbY, thumbWidth, thumbHeight);
    } else {
      rect(thumbX, height - size, thumbWidth, thumbHeight);
    }
  }

  void draw() {
    drawTrack();
    drawThumb();
  }
}

class ScrollView {
  PGraphics graphicsObject;
  int scrollX = 0;
  int scrollY = 0;
  PImage img;
  
  void setup() {
    // load an image from the web
    img = loadImage("http://processing.org/img/processing-web.png");
  
    // create a graphics object with a dimension of 720p
    graphicsObject = createGraphics(720, 480, P2D);
  }
  
  void draw() {
    graphicsObject.beginDraw();
    graphicsObject.background(0);
    if (img != null) {
      for (int i = 0; i < 5; i++) {
        graphicsObject.image(img, 0, img.height * i);
      }
    }
    graphicsObject.endDraw();
  }
}
