import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3; // RGB
final int LED_SCALE     = 16;

Serial serial;
byte[] buffer;

PGraphics led;

void setup() {

  size(800, 600);

  noSmooth();

  led = createGraphics(MATRIX_WIDTH, MATRIX_HEIGHT);
  led.beginDraw();
  led.background(0);
  led.endDraw();

  buffer = new byte[MATRIX_WIDTH * MATRIX_HEIGHT * NUM_CHANNELS];

  println("-- available serial ports --");
  printArray(Serial.list());

  try {
    // init serial manually (on Windows):
    // serial = new Serial(this, "COM3");
    // or trough the helper function:
    serial = new Serial(this, "/dev/cu.usbmodem22425601");
  }
  catch (Exception e) {
    println(e);
  }

  serial =  null;
}

void keyPressed() {
  if (key == 's') {
    String fichier = System.currentTimeMillis() + ".png";
    led.save("out/" + fichier);
  }
}

void draw() {

  int ox = width / 2 - led.width * LED_SCALE / 2;
  int oy = height / 2 - led.height * LED_SCALE / 2;

  if (mousePressed) {
    int mx = (mouseX - ox) / LED_SCALE;
    int my = (mouseY - oy) / LED_SCALE;
    int px = (pmouseX - ox) / LED_SCALE;
    int py = (pmouseY - oy) / LED_SCALE;
    led.beginDraw();
    led.stroke(255, 0, 0);
    led.line(mx, my, px, py);
    led.endDraw();
  }

  background(200);

  image(led, ox, oy, led.width * LED_SCALE, led.height * LED_SCALE);

  // Write to the serial port (if open)
  if (serial != null) {
    led.loadPixels();
    int idx = 0;
    for (int i=0; i<led.pixels.length; i++) {
      color c = led.pixels[i];
      buffer[idx++] = (byte)(c >> 16 & 0xFF); // r
      buffer[idx++] = (byte)(c >> 8 & 0xFF);  // g
      buffer[idx++] = (byte)(c & 0xFF);       // b
    }
    serial.write('*');     // The 'data' command
    serial.write(buffer);  // ...and the pixel values
  }
}
