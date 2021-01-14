class ScrollBarView extends View {
  final static int HORIZONTAL = 0;
  final static int VERTICAL = 1;
  int trackX = 0, trackY = 0, trackWidth = 0, trackHeight = 0;
  int thumbX = 0, thumbY = 0, thumbWidth = 0, thumbHeight = 0;
  int orientation = VERTICAL;
  
  View document;
  
  ScrollBarView(int orientation) {
    this.orientation = orientation;
  }
  
  @Override
  void setup() {}
    
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
  
  @Override
  void onSizeChanged(int w, int h) {
    super.onSizeChanged(w, h);
    if (orientation == HORIZONTAL) {
      // window height
      setY(height - 40);
    } else {
      // window width
      setX(width - 40);
    }
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
