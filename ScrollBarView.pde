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
  
  void drawTrack(PGraphics canvas) {
    canvas.rectMode(CORNER);
    canvas.stroke(0);
    colorGrey(canvas);
    canvas.rect(trackX, trackY, trackWidth, trackHeight);
  }
  
  void drawThumb(PGraphics canvas) {
    canvas.rectMode(CORNER);
    canvas.stroke(0);
    colorPurple(canvas);
    canvas.rect(thumbX, thumbY, thumbWidth, thumbHeight);
  }

  @Override
  void draw(PGraphics canvas) {
    if (thumbSize < trackLength) {
      if (trackWidth != 0 && trackHeight != 0 && thumbWidth != 0 && thumbHeight != 0) {
        drawTrack(canvas);
        drawThumb(canvas);
      }
    }
  }
  
  int minimum = 10;
  int maximum = 10;
  float viewportSize = 0;
  float oldViewportSize = 0;
  float contentSize = 0;
  float maximumContentOffset = 0;
  float trackLength = 0;
  int thumbSize = 0;
  float viewportOffset = 0;
  boolean allowOverflow = false;
  
  public abstract class OverflowRunnable {
    abstract public void run(int value);
  }
  
  OverflowRunnable onOverflow;
  
  @Override
  void onSizeChanged(int w, int h, int oldW, int oldH) {
    super.onSizeChanged(w, h, oldW, oldH);
 
    if (viewportSize != oldViewportSize) {
      oldViewportSize = viewportSize;
    }

    if (orientation == HORIZONTAL) {
      maximum = w;
      setY(height - 20);
      viewportSize = width;
      trackLength = w;
      if (document != null) {
        contentSize = document.getWidth();
      }
      trackWidth = w;
      trackHeight = h;
      thumbHeight = h;
    } else {
      maximum = h;
      setX(width - 20);
      viewportSize = height;
      trackLength = h;
      if (document != null) {
        contentSize = document.getHeight();
      }
      trackHeight = h;
      trackWidth = w;
      thumbWidth = w;
    }
    
    maximumContentOffset = contentSize-viewportSize;
    thumbSize = (int) ((viewportSize/contentSize) * trackLength);
    thumbSize = max(thumbSize, minimum);
    thumbSize = min(thumbSize, maximum);
    float maximumThumbPosition = trackLength-thumbSize;

    if (orientation == HORIZONTAL) {
      thumbWidth = thumbSize;
      if (maximumContentOffset == 0) {
        thumbX = 0;
      } else if (maximumContentOffset < 0) {
        thumbX = 0;
        if (document != null) {
          if (!allowOverflow) {
            if (onOverflow != null) {
              onOverflow.run(document.getWidth());
            }
          }
        }
      } else {
        if (document != null) {
          viewportOffset = document.scrollX;
          if (!allowOverflow && viewportOffset > 0 && viewportOffset > maximumContentOffset) {
            float offset = viewportOffset - maximumContentOffset;
            viewportOffset -= offset;
            document.scrollX = (int) viewportOffset;
          }
          thumbX = (int) (maximumThumbPosition * (viewportOffset / maximumContentOffset));
        } //<>//
      }
    } else {
      thumbHeight = thumbSize;
      if (maximumContentOffset == 0) {
        thumbY = 0;
      } else if (maximumContentOffset < 0) {
        thumbY = 0;
        if (document != null) {
          if (!allowOverflow) {
            if (onOverflow != null) {
              onOverflow.run(document.getHeight());
            }
          }
        }
      } else {
        if (document != null) {
          viewportOffset = document.scrollY;
          if (!allowOverflow && viewportOffset > 0 && viewportOffset > maximumContentOffset) {
            float offset = viewportOffset - maximumContentOffset;
            viewportOffset -= offset;
            document.scrollY = (int) viewportOffset;
          }
          thumbY = (int) (maximumThumbPosition * (viewportOffset / maximumContentOffset));
        }
      }
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
            if (document != null) {
              float multiplier = (float)thumbX / (float) (trackWidth - thumbWidth);
              float documentWidth = document.getWidth();
              float absoluteOffset = multiplier * (float) (documentWidth - width);
              document.scrollX = (int)absoluteOffset;
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
            if (document != null) {
              float multiplier = (float)thumbY / (float) (trackHeight - thumbHeight);
              float documentHeight = document.getHeight();
              float absoluteOffset = multiplier * (float) (documentHeight - height);
              document.scrollY = (int)absoluteOffset;
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
