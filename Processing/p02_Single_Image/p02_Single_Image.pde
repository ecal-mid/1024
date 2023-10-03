import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3; // RGB

Serial serial;
byte[] buffer;

PImage img;


void setup() {

  size(32, 32);

  img = loadImage("cat.png");

  buffer = new byte[MATRIX_WIDTH * MATRIX_HEIGHT * NUM_CHANNELS];
  
  println("-- available serial ports --");
  printArray(Serial.list());

  try {
    // init serial manually (on Windows):
    // serial = new Serial(this, "COM3");
    // or trough the helper function:
    serial = new Serial(this, "/dev/cu.usbmodem93893901", 6000000);
  }
  catch (Exception e) {
    println(e);
  }
}

void draw() {

  background(0);

  image(img, 0, 0);

  // Write to the serial port (if open)
  if (serial != null) {
    loadPixels();
    int idx = 0;
    for (int i=0; i<pixels.length; i++) {
      color c = pixels[i];
      buffer[idx++] = (byte)(c >> 16 & 0xFF); // r
      buffer[idx++] = (byte)(c >> 8 & 0xFF);  // g
      buffer[idx++] = (byte)(c & 0xFF);       // b
    }
    serial.write('*');     // The 'data' command
    serial.write(buffer);  // ...and the pixel values
  }
}
