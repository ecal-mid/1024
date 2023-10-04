function sendPixelData() {
    pg.loadPixels();
    let buffer = new Uint8Array(pg.width*pg.height*3 + 1);

    buffer[0] = 42; // The 'data' command

    // Copy every element from pixel to buffer, skipping every 4th element
    let bufferIndex = 1; // index of the pixel to copy -> start at 1 to skip the * command
    for (let i = 0; i < pg.pixels.length; i+=4) {
        buffer[bufferIndex++] = pg.pixels[i+0];
        buffer[bufferIndex++] = pg.pixels[i+1];
        buffer[bufferIndex++] = pg.pixels[i+2];
    }
    
    if (port.opened()) {
        port.write(buffer); // Send the buffer
    }
}
function createConnectButton () {
    connectBtn = createButton('Connect to Matrix');
    connectBtn.position(width/2 - connectBtn.width/2, height + 20);  // center and position the button under the canvas
    connectBtn.mousePressed(connectBtnClick);
}

function connectBtnClick() {
    if (!port.opened()) {
        port.open(); // Replace with your port name
    } else {
        port.close();
    }
}

function updateButton () {
    if (!port.opened()) {
        connectBtn.html('Connect to Matrix');
    } else {
        connectBtn.html('Disconnect');
    }
}
