#include <Arduino.h>
#include "pico_driver_v5_pinout.h"
#include <SmartMatrix.h>

#define COLOR_DEPTH 24

const uint16_t TOTAL_WIDTH = 64;  // Total size of the chained matrices
const uint16_t TOTAL_HEIGHT = 64;
const uint16_t kRefreshDepth = 48;  // Valid: 24, 36, 48
const uint16_t kDmaBufferRows = 4;  // Valid: 2-4
const uint16_t kPanelType = SM_PANELTYPE_HUB75_64ROW_MOD32SCAN;
//const uint16_t kPanelType = SM_PANELTYPE_HUB75_32ROW_MOD16SCAN;

const uint16_t kMatrixOptions = (SM_HUB75_OPTIONS_NONE);
const uint16_t kbgOptions = (SM_BACKGROUND_OPTIONS_NONE);

uint16_t getMaxValue(uint8_t *arr, uint16_t len);

SMARTMATRIX_ALLOCATE_BUFFERS(matrix, TOTAL_WIDTH, TOTAL_HEIGHT, kRefreshDepth, kDmaBufferRows, kPanelType, kMatrixOptions);
SMARTMATRIX_ALLOCATE_BACKGROUND_LAYER(bg, TOTAL_WIDTH, TOTAL_HEIGHT, COLOR_DEPTH, kbgOptions);

rgb24 WHITE = rgb24(255, 255, 255);
rgb24 BLACK = rgb24(0, 0, 0);


void setup() {

	Serial.begin(9600);

	pinMode(PICO_LED_PIN, OUTPUT);

	bg.enableColorCorrection(false);
	matrix.addLayer(&bg);
	matrix.setBrightness(255);
	matrix.begin();

	bg.fillScreen(BLACK);

}

void loop() {
	bg.fillScreen(BLACK);
	bg.drawPixel(10, 10, {255, 0, 0});
	bg.drawPixel(20, 10, rgb24(255, 0, 0));
	bg.swapBuffers(true);
	delay(2);
}
