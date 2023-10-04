let port;
let pg;
let connectBtn; // ne pas toucher

const MATRIX_HEIGHT = 32;
const MATRIX_WIDTH = 32;
const MATRIX_SCALE = 20;
const MATRIX_SIZE = MATRIX_HEIGHT * MATRIX_WIDTH;

function setup() {
    createCanvas(MATRIX_HEIGHT*MATRIX_SCALE, MATRIX_WIDTH*MATRIX_SCALE);
    pg = createGraphics(MATRIX_HEIGHT, MATRIX_HEIGHT);

    pg.noSmooth();
    noSmooth();
    pg.pixelDensity(1);
    pg.noStroke();

    port = createSerial();

    let usedPorts = usedSerialPorts();
    if (usedPorts.length > 0) {
        port.open(usedPorts[0]);
    }

    createConnectButton();
}

function draw() {
    // ! -> utiliser pg. pour dessiner sur le canvas -> par ex circle -> pg.circle

    //draw test pattern
    pg.background(10);
    pg.fill("red");
    pg.circle(16, 16, frameCount%32);

    
    image(pg, 0, 0, width, height); // draw the graphics buffer to the large screen
    sendPixelData();
    updateButton();
}