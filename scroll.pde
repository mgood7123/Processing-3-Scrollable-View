ScrollView view = new ScrollView();
ScrollBarView verticalScrollBar = new ScrollBarView(ScrollBarView.VERTICAL);
ScrollBarView horizontalScrollBar = new ScrollBarView(ScrollBarView.HORIZONTAL);

void setSize(int width, int height) {
  verticalScrollBar.setX(width - 40);
  horizontalScrollBar.setY(height - 40);
  verticalScrollBar.setWidth(40);
  verticalScrollBar.setHeight(height - 40);
  horizontalScrollBar.setHeight(40);
  horizontalScrollBar.setWidth(width - 40);
}

void setup() {
  // initial window size
  size(640, 360, P2D);
  
  // allow window to be resized
  surface.setResizable(true);
  
  view.setup(P2D);
  
  view.setWidth(720);
  view.setHeight(480);

  verticalScrollBar.setup(P2D);
  horizontalScrollBar.setup(P2D);
}

void draw(View view) {
  view.canvas.beginDraw();
  view.draw(view.canvas);
  view.canvas.endDraw();
  // draw the graphics object onto our screen
  image(view.canvas, view.getX(), view.getY(), view.getWidth(), view.getHeight());
}

// by default, draw() is called continuously

void draw() {
  draw(view);
  draw(verticalScrollBar);
  draw(horizontalScrollBar);
}

void mousePressed() {}
void mouseDragged() {}
void mouseReleased() {}

abstract class View {
  PGraphics canvas = null;
  private int x = 0;
  private int y = 0;
  private int width = 0;
  private int height = 0;
  private String mode = null;
  
  protected void setup(String mode) {
    this.mode = mode;
    setup();
  };
  
  abstract void setup();
  
  abstract void draw(PGraphics canvas);
  
  void setX(int x) { this.x = x; }
  int getX() { return x; }

  void setY(int y) { this.y = y; }
  int getY() { return y; }
  
  private void resize() {
    if (width != 0 && height != 0 && mode != null) {
      canvas = createGraphics(width, height, mode);
    } else {
      canvas = null;
    }
  }
  
  void setWidth(int width) {
    this.width = width;
    resize();
  }
  
  int getWidth() { return width; }
  
  void setHeight(int height) { 
    this.height = height;
    resize();
  }

  int getHeight() { return height; }
}

class ScrollView extends View {
  int scrollX = 0;
  int scrollY = 0;
  PImage img;
  
  @Override
  void setup() {
    // load an image from the web
    img = loadImage("http://processing.org/img/processing-web.png");
  }
  
  @Override
  void draw(PGraphics canvas) {
    canvas.background(0);
    if (img != null) {
      for (int i = 0; i < 5; i++) {
        canvas.image(img, 0, img.height * i);
      }
    }
  }
}

class ScrollBarView extends View {
  final static int HORIZONTAL = 0;
  final static int VERTICAL = 1;
  int trackX = 0, trackY = 0, trackWidth = 0, trackHeight = 0;
  int thumbX = 0, thumbY = 0, thumbWidth = 0, thumbHeight = 0;
  int orientation;
  
  ScrollBarView(int orientation) {
    this.orientation = orientation;
  }
  
  @Override
  void setup() {}
  
  void colorPurple(PGraphics canvas) {
    canvas.fill(155, 155, 255);
  }

  void colorGrey(PGraphics canvas) {
    canvas.fill(155, 155, 155);
  }
  
  void computeTrackSize() {
    trackWidth = getWidth();
    trackHeight = getHeight();
  }

  void drawTrack(PGraphics canvas) {
    computeTrackSize();
    canvas.rectMode(CORNER);
    canvas.stroke(0);
    colorGrey(canvas);
    canvas.rect(trackX, trackY, trackWidth, trackHeight);
  }
  
  void computeThumbSize() {
    if (orientation == VERTICAL) {
      thumbWidth = getWidth();
      thumbHeight = 10;
    } else {
      thumbWidth = 10;
      thumbHeight = getHeight();
    }
  }

  void drawThumb(PGraphics canvas) {
    computeThumbSize();
    canvas.rectMode(CORNER);
    canvas.stroke(0);
    colorPurple(canvas);
    canvas.rect(thumbX, thumbY, thumbWidth, thumbHeight);
  }

  @Override
  void draw(PGraphics canvas) {
    drawTrack(canvas);
    drawThumb(canvas);
  }
}
