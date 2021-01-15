ScrollView view = new ScrollView();
ScrollBarView verticalScrollBar = new ScrollBarView(ScrollBarView.VERTICAL);
ScrollBarView horizontalScrollBar = new ScrollBarView(ScrollBarView.HORIZONTAL);

void callOnSizeChanged(View view, int w, int h) {
  view.onSizeChanged(w, h, view.getWidth(), view.getHeight());
}

void setSize(int width, int height) {
  this.width = width;
  this.height = height;
  callOnSizeChanged(verticalScrollBar, 20, height - 20);
  callOnSizeChanged(horizontalScrollBar, width - 20, 20);
}

void setup() {
  // initial window size
  size(640, 360, P2D);

  // allow window to be resized
  surface.setResizable(true);
  
  view.setup(P2D);
  callOnSizeChanged(view, 720, 480);

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
    image(view.canvas, view.getX() - view.scrollX, view.getY() - view.scrollY, view.getWidth(), view.getHeight());
  }
}

// by default, draw() is called continuously

void draw() {
  background(0);
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
