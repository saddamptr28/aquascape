#include <Arduino.h>
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"

// Insert your network credentials
#define WIFI_SSID "DEWIKOST"
#define WIFI_PASSWORD "123456789"

// Insert Firebase project API Key
#define API_KEY "AIzaSyBgD_196K9e0NmyVbGtHxlyVAdgpGu5Yyo"

// Insert RTDB URL
#define DATABASE_URL "https://aquascape-ffef6-default-rtdb.asia-southeast1.firebasedatabase.app/"

// pH Sensor connected to analog pin 34 (ESP32)
#define PH_SENSOR_PIN 34

//Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
bool signupOK = false;

void setup() {
  Serial.begin(115200);
  
  // Connect to Wi-Fi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println("\nConnected with IP: " + WiFi.localIP().toString());

  // Configure Firebase
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  config.token_status_callback = tokenStatusCallback;

  // Sign up to Firebase
  if (Firebase.signUp(&config, &auth, "", "")) {
    signupOK = true;
    Firebase.begin(&config, &auth);
    Firebase.reconnectWiFi(true);
  } else {
    Serial.printf("Firebase SignUp Error: %s\n", config.signer.signupError.message.c_str());
  }
}

void loop() {
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    
    // Read pH sensor value (raw analog value)
    int phValue = analogRead(PH_SENSOR_PIN);
    float voltage = phValue * (3.3 / 4095.0); // Convert analog value to voltage (ESP32 ADC is 12-bit)
    
    // Example pH conversion formula (adjust based on calibration)
    float pH = 7 - ((voltage - 2.5) / 0.18);

    // Write the pH value to the database
    if (Firebase.RTDB.setFloat(&fbdo, "sensors/ph", pH)) {
      Serial.println("pH value sent to Firebase: " + String(pH));
    } else {
      Serial.println("FAILED to send pH value. Reason: " + fbdo.errorReason());
    }
  }
}
