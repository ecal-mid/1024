import processing.serial.*;

final int MATRIX_WIDTH  = 32;
final int MATRIX_HEIGHT = 32;
final int NUM_CHANNELS  = 3; // RGB

Serial serial;
byte[] buffer;

PImage map;
float mx, my;

float vel, ang;

boolean[] keys = new boolean[256];

void setup() {
  size(32, 32);

  map = loadImage("city_carpet.png");

  ang = -PI/2;
  mx = -map.width/2;
  my = -map.height/2 - 50;

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

void draw() {


  float damping = 0.05;

  if      (keys[RIGHT]) ang += 0.06;
  else if (keys[LEFT])  ang -= 0.06;

  if      (keys[DOWN]) vel += ( 0.6 - vel) * damping;
  else if (keys[UP])   vel += (-0.6 - vel) * damping;
  else                 vel += ( 0.0 - vel) * damping;

  float vx = cos(ang) * vel;
  float vy = sin(ang) * vel;

  mx = constrain(mx + vx, -map.width + width, 0);
  my = constrain(my + vy, -map.height + height, 0);

  image(map, mx, my);

  translate(width/2, height/2);
  rotate(ang);
  strokeWeight(2);
  stroke(255, 0, 0);
  float l = 6;
  line(-l, 0, l, 0);
  line(l, 0, 0, l);
  line(l, 0, 0, -l);

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

void keyPressed() {
  keys[keyCode] = true;
}

void keyReleased() {
  keys[keyCode] = false;
}
