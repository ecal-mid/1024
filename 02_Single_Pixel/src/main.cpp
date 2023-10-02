#include <Arduino.h>

// TEENSY
#include <MatrixHardware_Teensy4_ShieldV5.h>
#include <SmartMatrix.h>

#define COLOR_DEPTH 24

const uint16_t TOTAL_WIDTH = 32;  // Total size of the chained matrices
const uint16_t TOTAL_HEIGHT = 32;
const uint16_t kRefreshDepth = 48;  // Valid: 24, 36, 48
const uint16_t kDmaBufferRows = 4;  // Valid: 2-4

//const uint16_t kPanelType = SM_PANELTYPE_HUB75_64ROW_MOD32SCAN;
const uint16_t kPanelType = SM_PANELTYPE_HUB75_32ROW_MOD16SCAN;

const uint16_t kMatrixOptions = (SM_HUB75_OPTIONS_NONE);
// const uint16_t kMatrixOptions = (SM_HUB75_OPTIONS_ESP32_INVERT_CLK);
// const uint16_t kMatrixOptions = (SM_HUB75_OPTIONS_FM6126A_RESET_AT_START);

const uint16_t kbgOptions = (SM_BACKGROUND_OPTIONS_NONE);

uint16_t getMaxValue(uint8_t *arr, uint16_t len);

SMARTMATRIX_ALLOCATE_BUFFERS(matrix, TOTAL_WIDTH, TOTAL_HEIGHT, kRefreshDepth, kDmaBufferRows, kPanelType, kMatrixOptions);
SMARTMATRIX_ALLOCATE_BACKGROUND_LAYER(bg, TOTAL_WIDTH, TOTAL_HEIGHT, COLOR_DEPTH, kbgOptions);

void setup() {

	//pinMode(PICO_LED_PIN, OUTPUT);

	bg.enableColorCorrection(false);
	matrix.addLayer(&bg);
	matrix.setBrightness(255);
	matrix.begin();

}

uint32_t frame = 0;
void loop() {
	bg.fillScreen( {0,0,0});


	bg.drawPixel(0, frame % 32, {255, 0, 0});


	bg.swapBuffers(true);

	frame++;
	delay(100);
}
