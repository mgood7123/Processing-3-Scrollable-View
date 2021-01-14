ScrollView view = new ScrollView();
ScrollBarView verticalScrollBar = new ScrollBarView(ScrollBarView.VERTICAL);
ScrollBarView horizontalScrollBar = new ScrollBarView(ScrollBarView.HORIZONTAL);

void setSize(int width, int height) {
  this.width = width;
  this.height = height;
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

  verticalScrollBar.document = view;
  horizontalScrollBar.document = view;
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

boolean withinViewX(View view, int point) {
  return point > view.getX() && point < (view.getX() + view.getWidth());
}

boolean withinViewY(View view, int point) {
  return point > view.getY() && point < (view.getY() + view.getHeight());
}

boolean withinView(View view) {
  return withinViewX(view, mouseX) && withinViewY(view, mouseY);
}

class MotionEvent {
  static final int ACTION_DOWN = 0;
  static final int ACTION_MOVE = 1;
  static final int ACTION_UP = 2;
  int rawX;
  int rawY;
  int action;
  int getRawX() { return rawX; }
  int getRawY() { return rawY; }
  int getAction() { return action; }
  MotionEvent(int x, int y, int event) {
    rawX = x;
    rawY = y;
    action = event;
  }
}

View trackedView = null;

boolean beginViewTracking(View view) {
  if (withinView(view)) {
    trackedView = view;
    view.onTouch(new MotionEvent(mouseX, mouseY, MotionEvent.ACTION_DOWN));
    return true;
  }
  return false;
}

void mousePressed() {
  if (beginViewTracking(horizontalScrollBar)) return;
  if (beginViewTracking(verticalScrollBar)) return;
  if (beginViewTracking(view)) return;
}

void mouseDragged() {
  if (trackedView != null) {
    trackedView.onTouch(new MotionEvent(mouseX, mouseY, MotionEvent.ACTION_MOVE));    
  }
}

void mouseReleased() {
  if (trackedView != null) {
    trackedView.onTouch(new MotionEvent(mouseX, mouseY, MotionEvent.ACTION_UP));
    trackedView = null;
  }
}

abstract class View {
  PGraphics canvas = null;
  private int viewX = 0;
  private int viewY = 0;
  private int viewWidth = 0;
  private int viewHeight = 0;
  private String mode = null;
  
  final void setup(String mode) {
    this.mode = mode;
    setup();
  };
  
  void onTouch(MotionEvent event) {};
  
  abstract void setup();
  
  abstract void draw(PGraphics canvas);
  
  void setX(int x) { viewX = x; }
  int getX() { return viewX; }

  void setY(int y) { viewY = y; }
  int getY() { return viewY; }
  
  private void resize() {
    if (getWidth() != 0 && getHeight() != 0 && mode != null) {
      canvas = createGraphics(getWidth(), getHeight(), mode);
    } else {
      canvas = null;
    }
  }
  
  void setWidth(int width) {
    viewWidth = width;
    resize();
  }
  
  int getWidth() { return viewWidth; }
  
  void setHeight(int height) { 
    viewHeight = height;
    resize();
  }

  int getHeight() { return viewHeight; }
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
  
  View document;
  
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
    if (orientation == HORIZONTAL) {
      if (trackWidth == 0 || document.getWidth() == 0) {
        thumbWidth = 10;
      } else {
        float windowWidth = width;
        float documentWidth = document.getWidth();
        float visiblePercent = windowWidth / documentWidth;
        thumbWidth = (int) (trackWidth * visiblePercent);
      }
      thumbHeight = getHeight();
    } else {
      thumbWidth = getWidth();
      if (trackHeight == 0 || document.getHeight() == 0) {
        thumbHeight = 10;
      } else {
        float windowHeight = height;
        float documentHeight = document.getHeight();
        float visiblePercent = windowHeight / documentHeight;
        thumbHeight = (int) (trackHeight * visiblePercent);
      }
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
  
  boolean dragging = false;
  int xOffset;
  int yOffset;
  
  @Override
  void onTouch(MotionEvent event) {
    switch (event.getAction()) {
      case MotionEvent.ACTION_DOWN:
        if (orientation == HORIZONTAL) {
          int x = getX() + thumbX;
          if (event.getRawX() > x && event.getRawX() < (x + thumbWidth)) {
            dragging = true;
            xOffset = event.getRawX()-x;
          } else {
            dragging = false;
          }
        } else {
          int y = getY() + thumbY;
          if (event.getRawY() > y && event.getRawY() < (y + thumbHeight)) {
            dragging = true;
            yOffset = event.getRawY()-y;
          } else {
            dragging = false;
          }
        }
        break;
      case MotionEvent.ACTION_MOVE:
        if (dragging) {
          if (orientation == HORIZONTAL) {
            thumbX = event.getRawX() - xOffset;
            if (thumbX < 0) {
              thumbX = 0;
            } else {
              int x = getWidth() - thumbWidth;
              if (thumbX > x) {
                thumbX = x;
              }
            }
          } else {
            thumbY = event.getRawY() - yOffset;
            if (thumbY < 0) {
              thumbY = 0;
            } else {
              int y = getHeight() - thumbHeight;
              if (thumbY > y) {
                thumbY = y;
              }
            }
          }
        }
        break;
      case MotionEvent.ACTION_UP:
        dragging = false;
        break;
    }
  }
}
