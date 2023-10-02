#include <Arduino.h>

#include <MatrixHardware_Teensy4_ShieldV5.h>
#include <SmartMatrix.h>

#define COLOR_DEPTH 24

const uint16_t TOTAL_WIDTH = 32;  // Total size of the chained matrices
const uint16_t TOTAL_HEIGHT = 32;
const uint16_t kRefreshDepth = 48;  // Valid: 24, 36, 48
const uint16_t kDmaBufferRows = 4;  // Valid: 2-4
//  const uint16_t kPanelType = SM_PANELTYPE_HUB75_64ROW_MOD32SCAN;
const uint16_t kPanelType = SM_PANELTYPE_HUB75_32ROW_MOD16SCAN;

const uint8_t NUM_CHANNELS = 3;
const uint16_t NUM_LEDS = TOTAL_WIDTH * TOTAL_HEIGHT;
const uint16_t BUFFER_SIZE = NUM_LEDS * NUM_CHANNELS;
uint8_t buf[BUFFER_SIZE];

const uint16_t kMatrixOptions = (SM_HUB75_OPTIONS_NONE);
const uint16_t kbgOptions = (SM_BACKGROUND_OPTIONS_NONE);

uint16_t getMaxValue(uint8_t *arr, uint16_t len);

SMARTMATRIX_ALLOCATE_BUFFERS(matrix, TOTAL_WIDTH, TOTAL_HEIGHT, kRefreshDepth, kDmaBufferRows, kPanelType, kMatrixOptions);
SMARTMATRIX_ALLOCATE_BACKGROUND_LAYER(bg, TOTAL_WIDTH, TOTAL_HEIGHT, COLOR_DEPTH, kbgOptions);


void setup() {

	Serial.begin(6000000);

	bg.enableColorCorrection(false);
	matrix.addLayer(&bg);
	matrix.setBrightness(255);
	matrix.begin();


}

void loop() {

	char chr = Serial.read();
	if (chr == '*') {
		// masterFrame
		uint16_t count = Serial.readBytes((char *)buf, BUFFER_SIZE);
		Serial.println(count);
		if (count == BUFFER_SIZE) {
			rgb24 *buffer = bg.backBuffer();
			uint16_t idx = 0;
			for (uint16_t i = 0; i < NUM_LEDS; i++) {
				rgb24 *col = &buffer[i];
				col->red   = buf[idx++];
				col->green = buf[idx++];
				col->blue  = buf[idx++];
			}
			bg.swapBuffers(false);
		}
	}
	//digitalWrite(PICO_LED_PIN, !digitalRead(PICO_LED_PIN));
}
