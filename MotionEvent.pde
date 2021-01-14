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
