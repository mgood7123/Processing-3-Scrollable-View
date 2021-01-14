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
  
    void colorPurple(PGraphics canvas) {
    canvas.fill(155, 155, 255);
  }

  void colorGrey(PGraphics canvas) {
    canvas.fill(155, 155, 155);
  }
  
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
  
  void onSizeChanged(int w, int h) {
    setWidth(w);
    setHeight(h);
  }
}
