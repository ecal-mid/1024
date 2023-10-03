import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3; // RGB

Serial serial;
byte[] buffer;

int posX = 5;
int posY = 3;

int vitX = 2;
int vitY = 3;

void setup() {

  size(32, 32);


  buffer = new byte[MATRIX_WIDTH * MATRIX_HEIGHT * NUM_CHANNELS];

  println("-- available serial ports --");
  printArray(Serial.list());

  try {
    // init serial manually (on Windows):
    // serial = new Serial(this, "COM3");
    // or trough the helper function:
    serial = new Serial(this, "/dev/cu.usbmodem131734201");
  }
  catch (Exception e) {
    println(e);
  }

  background(0);
}

void keyPressed() {
  background(random(255), random(255), random(255));

  posX = int(random(0, width));
  posY = int(random(0, height));

  vitX = int(random(1, 6));
  vitY = int(random(1, 6));
}

void draw() {

  posX = posX + vitX;
  posY = posY + vitY;


  if (posX < 0 || posX >= width) {
    vitX = -vitX;
  }

  if (posY < 0 || posY >= height) {
    vitY = -vitY;
  }



  //background(0);
  noStroke();
  fill(255);
  rect(posX, posY, 1, 1);



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
