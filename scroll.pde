ScrollView view = new ScrollView();
ScrollBarView verticalScrollBar = new ScrollBarView(ScrollBarView.VERTICAL);
ScrollBarView horizontalScrollBar = new ScrollBarView(ScrollBarView.HORIZONTAL);

void setSize(int width, int height) {
  this.width = width;
  this.height = height;
  verticalScrollBar.onSizeChanged(40, height - 40);
  horizontalScrollBar.onSizeChanged(width - 40, 40);
}

void setup() {
  // initial window size
  size(640, 360, P2D);
  
  // allow window to be resized
  surface.setResizable(true);
  
  view.setup(P2D);
  view.onSizeChanged(720, 480);

  verticalScrollBar.setup(P2D);
  horizontalScrollBar.setup(P2D);

  verticalScrollBar.document = view;
  horizontalScrollBar.document = view;
}

void draw(View view) {
  if (view.canvas != null) {
    view.canvas.beginDraw();
    view.draw(view.canvas);
    view.canvas.endDraw();
    // draw the graphics object onto our screen
    image(view.canvas, view.getX(), view.getY(), view.getWidth(), view.getHeight());
  }
}

// by default, draw() is called continuously

void draw() {
  draw(view);
  draw(verticalScrollBar);
  draw(horizontalScrollBar);
}

ViewTracker tracker = new ViewTracker();

void mousePressed() {
  if (tracker.mousePressed(horizontalScrollBar)) return;
  if (tracker.mousePressed(verticalScrollBar)) return;
  if (tracker.mousePressed(view)) return;
}

void mouseDragged() {
  tracker.mouseDragged();
}

void mouseReleased() {
  tracker.mouseReleased();
}
