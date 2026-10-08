#include <Wire.h>

// RP Console Repairs: AtomS3 + M5Stack INA226-10A monitor
// SDA=GPIO2, SCL=GPIO1, INA226 I2C address=0x41.
// 10 A version shunt = 0.005 ohm (NOT the 1 A version).

const uint8_t INA_ADDR = 0x41;
const float SHUNT_OHMS = 0.005f;

// Fetch a 16-bit register; INA226 sends the high byte first.
bool readRegister(uint8_t reg, uint16_t &value) {
  Wire.beginTransmission(INA_ADDR);
  Wire.write(reg);
  if (Wire.endTransmission(false) != 0) return false;
  if (Wire.requestFrom(INA_ADDR, (uint8_t)2) != 2) return false;
  value = ((uint16_t)Wire.read() << 8) | Wire.read();
  return true;
}

void setup() {
  Serial.begin(115200);
  Wire.begin(2, 1);
  Wire.setClock(100000);
  delay(1500);
  Serial.println("RP CONSOLE REPAIRS");
  Serial.println("BENCH PSU LIVE MONITOR");
}

void loop() {
  uint16_t busRaw = 0;
  uint16_t shuntRaw = 0;
  bool okBus = readRegister(0x02, busRaw);     // Bus voltage, 1.25 mV/bit
  bool okShunt = readRegister(0x01, shuntRaw); // Shunt voltage, 2.5 uV/bit

  if (!okBus || !okShunt) {
    Serial.println("INA226 NOT FOUND");
  } else {
    float voltage = busRaw * 0.00125f;
    float shuntVoltage = (int16_t)shuntRaw * 0.0000025f;
    float current = shuntVoltage / SHUNT_OHMS;
    float power = voltage * current; // Calculated; not calibrated INA226 power register

    Serial.print("V: "); Serial.print(voltage, 3);
    Serial.print("  A: "); Serial.print(current, 3);
    Serial.print("  W: "); Serial.println(power, 3);
  }
  delay(1000);
}
