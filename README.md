# Nodex PIR Sensor

ESPHome motion sensor: Wemos D1 mini + Panasonic EKMC PaPIRs.

## Setup

1. Plug the sensor into USB power.
2. On your phone, join the Wi-Fi network **Nodex PIR Setup**.
3. A page opens; choose your Wi-Fi network and enter the password.
4. In Home Assistant, a notification appears: **New device discovered**. Click **Configure**.

## Settings (in Home Assistant, under the device's Configuration section)

| Setting | What it does | Default |
|---|---|---|
| Motion hold time | How long *Motion* stays on after the last detection | 5 s |
| Minimum trigger time | Ignore detections shorter than this (raise if you get false triggers) | 0 ms |
| Occupancy timeout | How long *Occupancy* stays on after motion stops | 120 s |
| Motion detection | Turn sensing off without unplugging | On |
| LED on motion | Light the on-board LED when motion is detected | Off |
| Motion LED brightness | How bright the LED is when motion lights it | 20 % |

The **LED** also appears as a normal light, so you can turn it on, off or dim it from Home Assistant or automations.

**Motion** is best for alerts and quick triggers. **Occupancy** is best for lights and heating.

## Customising

In the ESPHome dashboard, the device shows as discovered. Click **Take Control** to
copy this config into your own ESPHome and change anything you like.

## Wiring

PIR output to D0 (GPIO16). Change `pir_pin` in the config if you wire it elsewhere.

## Updates

New firmware appears in Home Assistant as **Firmware update available** on the device. Click **Install**.
