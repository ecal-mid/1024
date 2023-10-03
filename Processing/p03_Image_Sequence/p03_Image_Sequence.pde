import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3; // RGB

Serial serial;
byte[] buffer;

int current = 0;
ArrayList<PImage>sequence;



void setup() {

  size(32, 32);


  sequence = new ArrayList<PImage>();

  PImage spriteSheet = loadImage("font_atlas.png");

  int numX = spriteSheet.width/32;
  int numY = spriteSheet.height/32;

  for (int j=0; j<numY; j++) {
    for (int i=0; i<numX; i++) {
      PImage img = spriteSheet.get(i * 32, j * 32, 32, 32);
      sequence.add(img);
    }
  }

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

}

void keyPressed() {
  if (keyCode == RIGHT) {
    current = (current + 1) % sequence.size();
  } else if (keyCode == LEFT) {
    current = (current - 1 + sequence.size()) % sequence.size();
  }
}

void draw() {

  background(0);

  //if (frameCount % 10 == 0) {
  //  current = (current + 1) % sequence.size();
  //}

  image(sequence.get(current), 0, 0);

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
