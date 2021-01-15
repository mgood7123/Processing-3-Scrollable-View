class ScrollView extends View {
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
      canvas.image(img, 0, 0, getWidth(), getHeight());
    }
  }
}
