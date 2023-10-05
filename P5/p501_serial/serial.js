const { setupSerial, sendPixelData } = (() => {

    const DATA_CMD = "*".charCodeAt(0) // 42;
    const FINISH_WRITE = null;

    let port, connectBtn, container
    let writing = FINISH_WRITE;
    let opacity = 3;
    let fadeBtn = true;

    function setupSerial(...args) { // [filter], baudRate

        container = createDiv();
        container.position(0, 0);
        container.mouseOver(() => {
            opacity = 3;
            fadeBtn = false;
        });
        container.mouseOut(() => {
            fadeBtn = true;
        });

        try {
            port = createSerial(...args);
            const [usedPort] = usedSerialPorts();
            if (usedPort) port.open(usedPort);

            port.port.ondisconnect = () => {
                
                // port.close()
                // try reconnect at interval
            };

            connectBtn = createButton('');
            connectBtn.mouseClicked(togglePort);
            connectBtn.parent(container);
        } catch (e) {
            let txt = ''
            const chromium = navigator.userAgent.indexOf("Chrome") !== -1;

            if (chromium) {
                txt = `Try <a href=${reRoute({ hostname: 'localhost' })}>localhost</a> or <a href=${reRoute({ protocol: 'https' })}>https<a>.`
            } else {
                txt += `You must be on Chrome.`
            }
            const parag = createP(`Serial Unavailable. ` + txt);
            parag.parent(container);
        }

        return port;
    }

    function sendPixelData() {
        updateButton(); // update html of button

        if (!port) return;

        loadPixels();
        const buffer = new Uint8Array(width * height * 3 + 1);

        buffer[0] = DATA_CMD; // The 'data' command

        // Copy every element from pixel to buffer, skipping every 4th element
        let bufferIndex = 1;
        for (let i = 0; i < pixels.length; i += 4) {
            buffer[bufferIndex++] = pixels[i + 0];
            buffer[bufferIndex++] = pixels[i + 1];
            buffer[bufferIndex++] = pixels[i + 2];
        }

        if (port.opened()) {

            const isOpen = port.port.writable && !port.port.writable.locked

            if (isOpen && writing === FINISH_WRITE) {

                writing = port.write(buffer)
                writing.then(() => {
                    writing = FINISH_WRITE;
                }) // Send the buffer

            }

        } else {
            writing = FINISH_WRITE;
        }

    }

    async function togglePort() {
        if (!port) return;
        if (port.opened()) {
            await writing
            port.close()
        } else {
            port.open();
        }
    }

    function updateButton() {
        if (!connectBtn) return;

        if (fadeBtn) opacity = max(0.1, opacity - 0.05);

        let txt = '...';

        if (port) {
            txt = port.opened() ? 'Disconnect' : 'Connect to Matrix';
        }
        connectBtn.html(txt);
        container.style('opacity', min(opacity, 1));
    }

    function reRoute(options) {
        const url = new URL(window.location.href);
        Object.assign(url, options);
        return url.href;
    }

    return { setupSerial, sendPixelData }
})()
