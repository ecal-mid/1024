import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3; // RGB
final int LED_SCALE     = 16;

Serial serial;
byte[] buffer;

PGraphics led;

int[] grid;

void setup() {

  size(800, 600);

  noSmooth();

  grid = new int[MATRIX_WIDTH * MATRIX_HEIGHT];

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
}

void mousePressed() {

  int ox = width / 2 - led.width * LED_SCALE / 2;
  int oy = height / 2 - led.height * LED_SCALE / 2;
  int gx = (mouseX - ox) / LED_SCALE;
  int gy = (mouseY - oy) / LED_SCALE;


  if (gx >=0 && gx < MATRIX_WIDTH && gy >= 0 && gy < MATRIX_HEIGHT) {
    int idx = gy * MATRIX_WIDTH + gx;
    if (grid[idx]==0) {
      grid[idx] = int(random(1, 3));
    }
  }
}

void keyPressed() {
  if (key == 'n') {  
    for(int i=0; i<grid.length; i++) {
      grid[i] = 0;
    }  
  }
}

void draw() {
  
  

  if (mousePressed) {
    int ox = width / 2 - led.width * LED_SCALE / 2;
    int oy = height / 2 - led.height * LED_SCALE / 2;
    int gx = (mouseX - ox) / LED_SCALE;
    int gy = (mouseY - oy) / LED_SCALE;


    if (gx >=0 && gx < MATRIX_WIDTH && gy >= 0 && gy < MATRIX_HEIGHT) {
      int idx = gy * MATRIX_WIDTH + gx;
      if (grid[idx]==0) {
        grid[idx] = int(random(1, 3));
      }
    }
  }

  for (int j=MATRIX_HEIGHT-2; j>=0; j--) {
    for (int i=0; i<MATRIX_WIDTH; i++) {
      // position actuelle
      int x1 = i;
      int y1 = j;

      // position en bas
      int x2 = x1;
      int y2 = y1 + 1;

      int index1 = y1 * MATRIX_WIDTH + x1;
      int index2 = y2 * MATRIX_WIDTH + x2;

      if (grid[index2] == 0) {
        grid[index2] = grid[index1];
        grid[index1] = 0;
      }
    }
  }





  int ox = width / 2 - led.width * LED_SCALE / 2;
  int oy = height / 2 - led.height * LED_SCALE / 2;

  led.beginDraw();
  led.loadPixels();
  for (int i=0; i<grid.length; i++) {
    int v = grid[i];

    if      (v == 1) led.pixels[i] = color(255, 0, 0);
    else if (v == 2) led.pixels[i] = color(255, 255, 0);
    else led.pixels[i] = color(0);
  }
  led.updatePixels();
  led.endDraw();


  background(200);

  image(led, ox, oy, led.width * LED_SCALE, led.height * LED_SCALE);

  // Write to the serial port (if open)
  if (serial != null) {
    led.loadPixels();
    int idx = 0;
    for (int i=0; i<led.pixels.length; i++) {
      color c = led.pixels[i];
      buffer[idx++] = (byte)(c >> 16 & 0xFF); // r
      buffer[idx++] = (byte)(c >> 8 & 0xFF); // g
      buffer[idx++] = (byte)(c & 0xFF); // b
    }
    serial.write('*'); // The 'data' command
    serial.write(buffer); // ...and the pixel values
  }
}
