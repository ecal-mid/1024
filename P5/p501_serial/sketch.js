const MATRIX_HEIGHT = 32;
const MATRIX_WIDTH = 32;
const MATRIX_SIZE = MATRIX_HEIGHT * MATRIX_WIDTH;

function setup() {
    createCanvas(MATRIX_HEIGHT, MATRIX_WIDTH);

    noSmooth();
    pixelDensity(1);
    noStroke();

    setupSerial();
}

function draw() {

    fill("red");
    background(0);
    circle(16,16,frameCount%32);

    sendPixelData();
}