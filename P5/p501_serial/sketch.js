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

    fill("black");
    background(0);


    fill("white");
    
    // polar coordinates
    const radius = width/4
    const angle = frameCount * 0.1
    const x = width/2 + radius * cos(angle)
    const y = height/2 + radius * sin(angle)
    
    const thickness = 1;

    rect(round(x), 0, thickness, height);
    rect(0, round(y), width, thickness);
    
    sendPixelData();
}