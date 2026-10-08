#include <Wire.h>

// RP Console Repairs: AtomS3 + M5Stack INA226-10A connection test
// AtomS3 HY2.0: SDA GPIO2, SCL GPIO1. INA226 address: 0x41.

void setup() {
  Serial.begin(115200);
  Wire.begin(2, 1);
  Wire.setClock(100000);
  delay(1500);
  Serial.println("RP Console Repairs - INA226 Connection Test");
}

void loop() {
  Wire.beginTransmission(0x41);
  byte result = Wire.endTransmission();
  Serial.println(result == 0 ? "INA226 FOUND!" : "INA226 NOT FOUND");
  delay(2000);
}
