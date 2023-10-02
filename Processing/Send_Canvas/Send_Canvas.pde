/**
 * Example 1.
 * This sketch sends all the pixels of the canvas to the serial port.
 * A helper function to scan all the serial ports for a configured controller is provided.
 */

import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3;

Serial serial;
byte[]buffer;

void setup() {
  // The Processing preprocessor only accepts literal values for size()
  // so we can't do: size(MATRIX_WIDTH, NUM_TILES * MATRIX_HEIGHT);
  // NOTE: the default layout is vertically stacked tiles.
  size(32, 32, P3D);

  buffer = new byte[MATRIX_WIDTH * MATRIX_HEIGHT * NUM_CHANNELS];

  // init serial manually (on Windows):
  // serial = new Serial(this, "COM3");
  // or trough the helper function:
  serial = new Serial(this, "/dev/cu.usbmodem93893901", 6000000);
  

  frameRate(20);
}

void draw() {

  background(0);
  
  translate(width/2, height/2);
  rotateX(frameCount * 0.021);
  rotateY(frameCount * 0.022);
  rotateZ(frameCount * 0.023);
  noFill();
  stroke(255);
  box(16);






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
