public class PID {
  private final float KP = 0.160;
  private final float KI = 160.0;
  private final float KD = 0.000160;

  private final float dt;
  private final float goal;

  private float error_now = 0.0;
  private float error_previous = 0.0;
  private float integral = 0.0;
  private float derivative = 0.0;
  private float input;
  private float[] error;

  public PID(int[] b) {
    goal = 1.0 * b[b.length - 1];
    dt = 1.0 / b.length;

    error = new float[b.length];

    input = step(b[0]);
    error[0] = goal - b[0];

    for (int i = 1; i < b.length; i++) {
      input = step(0.5 * input + 0.5 * b[i]);
      error[i] = error_now;
    }
  }

  public int getError() {
    return (int)abs(error_now);
  }

  public float[] getErrors() {
    return error;
  }

  public float step(float v) {
    error_now = goal - v;
    integral = integral + dt * error_now;
    derivative = (error_now - error_previous) / dt;
    error_previous = error_now;
    return (KP * error_now + KI * integral + KD * derivative);
  }
}
