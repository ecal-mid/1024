function sendPixelData() {
    updateButton(); // update html of button
    loadPixels();
    let buffer = new Uint8Array(width * height * 3 + 1);

    buffer[0] = 42; // The 'data' command

    // Copy every element from pixel to buffer, skipping every 4th element
    let bufferIndex = 1;
    for (let i = 0; i < pixels.length; i += 4) {
        buffer[bufferIndex++] = pixels[i + 0];
        buffer[bufferIndex++] = pixels[i + 1];
        buffer[bufferIndex++] = pixels[i + 2];
    }

    if (port.opened()) {
        port.write(buffer); // Send the buffer
    }
}
function createConnectButton() {
    connectBtn = createButton('Connect to Matrix');
    connectBtn.mousePressed(connectBtnClick);
}

function connectBtnClick() {
    if (!port.opened()) {
        port.open();
    } else {
        port.close();
    }
}

function updateButton() {
    if (!port.opened()) {
        connectBtn.html('Connect to Matrix');
    } else {
        connectBtn.html('Disconnect');
    }
}
