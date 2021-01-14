class ViewTracker {
  View trackedView = null;

  boolean withinViewX(View view, int point) {
    return point > view.getX() && point < (view.getX() + view.getWidth());
  }

  boolean withinViewY(View view, int point) {
    return point > view.getY() && point < (view.getY() + view.getHeight());
  }

  boolean withinView(View view) {
    return withinViewX(view, mouseX) && withinViewY(view, mouseY);
  }

  boolean mousePressed(View view) {
    if (withinView(view)) {
      trackedView = view;
      view.onTouch(new MotionEvent(mouseX, mouseY, MotionEvent.ACTION_DOWN));
      return true;
    }
    return false;
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
}
