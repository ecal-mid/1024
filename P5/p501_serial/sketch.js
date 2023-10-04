let port;
let connectBtn;
let canvas;
let img1;
let img2;
let img3;

const MATRIX_HEIGHT = 32;
const MATRIX_WIDTH = 32;
const MATRIX_SIZE = MATRIX_HEIGHT * MATRIX_WIDTH;

function setup() {
    canvas = createCanvas(MATRIX_HEIGHT, MATRIX_WIDTH);

    noSmooth();
    pixelDensity(1);
    noStroke();

    port = createSerial();

    let usedPorts = usedSerialPorts();
    if (usedPorts.length > 0) {
        port.open(usedPorts[0]);
    }

    createConnectButton();
}

function draw() {

    fill("red");
    background(0);
    circle(16,16,frameCount%32);

    sendPixelData();
}