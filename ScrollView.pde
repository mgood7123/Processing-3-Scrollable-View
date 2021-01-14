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
