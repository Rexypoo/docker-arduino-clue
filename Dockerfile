FROM rexypoo/arduino AS base

RUN apt-get update && apt-get -yq install \
    python3 \
    python3-pip \
 && pip3 install adafruit-nrfutil

USER "$USER"

# Install the target device
RUN arduino --pref "boardsmanager.additional.urls=https://www.adafruit.com/package_adafruit_index.json" --save-prefs \
 && arduino --install-boards adafruit:nrf52 \
 && arduino \
    --pref "target_package=adafruit" \
    --pref "target_platform=nrf52" \
    --pref "custom_debug=cluenrf52840_l0" \
    --pref "custom_softdevice=cluenrf52840_s140v6" \
    --pref "board=cluenrf52840" \
    --save-prefs

# Install libraries

# Arcada and dependencies
RUN arduino --install-library "Adafruit Arcada Library" \
 && arduino --install-library "Adafruit FreeTouch Library" \
 && arduino --install-library "Adafruit ImageReader Library" \
 && arduino --install-library "Adafruit NeoPixel" \
 && arduino --install-library "Adafruit ADT7410 Library" \
 && arduino --install-library "Adafruit ST7735 and ST7789 Library" \
 && arduino --install-library "Adafruit ILI9341" \
 && arduino --install-library "Adafruit SPIFlash" \
 && arduino --install-library "Adafruit LIS3DH" \
 && arduino --install-library "Adafruit ZeroTimer Library" \
 && arduino --install-library "Adafruit TouchScreen" \
 && arduino --install-library "Adafruit LSM6DS" \
 && arduino --install-library "Adafruit LIS3MDL" \
 && arduino --install-library "Adafruit BMP280 Library" \
 && arduino --install-library "Adafruit SHT31 Library" \
 && arduino --install-library "Adafruit APDS9960 Library" \
 && arduino --install-library "Adafruit MSA301" \
 && arduino --install-library "Adafruit EPD" \
 && arduino --install-library "Adafruit PixelDust" \
 && arduino --install-library "ArduinoJson" \
 && arduino --install-library "Adafruit WavePlayer Library" \
 && arduino --install-library "Adafruit TinyUSB Library" \
 && arduino --install-library "SdFat - Adafruit Fork" \
 && arduino --install-library "Adafruit Circuit Playground" \
 && arduino --install-library "Adafruit Unified Sensor" \
 && arduino --install-library "Adafruit BusIO" \
 && arduino --install-library "Audio - Adafruit Fork" \
 && arduino --install-library "CircularBuffer"

# Unified Sensor and dependencies
RUN arduino --install-library "Adafruit Unified Sensor" \
 && arduino --install-library "Adafruit BME280 Library" \
 && arduino --install-library "Adafruit BMP280 Library" \
 && arduino --install-library "Adafruit DPS310" \
 && arduino --install-library "Adafruit ADXL343" \
 && arduino --install-library "Adafruit MSA301" \
 && arduino --install-library "Adafruit Arcada Library" \
 && arduino --install-library "Adafruit FXOS8700" \
 && arduino --install-library "Adafruit FXAS21002C" \
 && arduino --install-library "Adafruit LSM6DS" \
 && arduino --install-library "Adafruit LIS3MDL" \
 && arduino --install-library "Adafruit ICM20649" \
 && arduino --install-library "Adafruit MPU6050" \
 && arduino --install-library "Adafruit LIS2MDL" \
 && arduino --install-library "Adafruit LSM9DS1 Library" \
 && arduino --install-library "Adafruit LSM9DS0 Library" \
 && arduino --install-library "Adafruit AHRS" \
 && arduino --install-library "Adafruit Arcada Library" \
 && arduino --install-library "Adafruit Sensor Calibration" \
 && arduino --install-library "Adafruit SHT31 Library" \
 && arduino --install-library "Adafruit APDS9960 Library" \
 && arduino --install-library "Adafruit LPS2X" \
 && arduino --install-library "Adafruit HTS221"

# Others that might be needed
RUN arduino --install-library "Adafruit GFX Library"
# && arduino --install-library "Adafruit STMPE610"

USER root

# Move libraries to install path to prevent volume issues
# Change ownership to shorten startup time
RUN mv /developer/Arduino/libraries/* /opt/arduino/libraries/ \
 && chown -R root:dialout /opt/arduino/libraries \
 && chown -R root:dialout /developer/.arduino15/packages \
 && chmod -R g=u /developer/.arduino15/packages

# Build with 'docker build -t arduino-clue .'
LABEL org.opencontainers.image.url="https://hub.docker.com/r/rexypoo/arduino-clue" \
      org.opencontainers.image.documentation="https://hub.docker.com/r/rexypoo/arduino-clue" \
      org.opencontainers.image.source="https://github.com/Rexypoo/docker-arduino-clue" \
      org.opencontainers.image.version="0.1a" \
      org.opencontainers.image.licenses="MIT" \
      org.opencontainers.image.description="Arduino on Docker with support for Adafruit Clue" \
      org.opencontainers.image.title="rexypoo/arduino-clue" \
      org.label-schema.docker.cmd='mkdir -p "$HOME"/Arduino && \
      docker run -d --rm \
      --name arduino-clue \
      --env DISPLAY \
      --volume /tmp/.X11-unix:/tmp/.X11-unix:ro \
      --volume "$HOME"/Arduino:/developer/Arduino \
      --device /dev/ttyACM0 \
      rexypoo/arduino-clue' \
      org.label-schema.docker.cmd.devel="docker run -it --rm --entrypoint bash rexypoo/arduino-clue" \
      org.label-schema.docker.cmd.debug="docker exec -it arduino-clue bash"
