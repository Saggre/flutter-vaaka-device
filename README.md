# Wireless Smart Scale Application (WIP)

**This project has been abandoned.** In order to continue, the project needs to be documented and refactored to work
with a more recent Flutter version.

## Working principle

The app broadcasts itself in the local network when looking for a scale to connect to.\
The scale listens to this broadcast and acks when one is found.\
After the scale has been connected, it starts sending weight packets and receiving tare and calibration commands.\
Weight packets are parsed and sunk into a stream controller, that can be listened to.

![Scale 3D rendering](.github/assets/FTwP5CW.png)

## Application design

The app uses BLoC pattern via the `bloc` library and implements it with `flutter_bloc` state-reactive components.

## UI Designs / Screenshots

<p float="left">
  <img alt="" src="https://i.imgur.com/ngLMOvS.jpg" width="300" />
  <img alt="" src="https://i.imgur.com/IEmJHML.jpg" width="300" />
  <img alt="" src="https://i.imgur.com/jOCzgCl.jpg" width="300" />
  <img alt="" src="https://i.imgur.com/ycvAAiq.jpg" width="300" />
  <img alt="" src="https://i.imgur.com/8CutTmB.jpg" width="300" />
  <img alt="" src="https://i.imgur.com/eWXBJaL.jpg" width="300" />
  <img alt="" src="https://i.imgur.com/0NsK8V2.jpg" width="300" />
  <img alt="" src="https://i.imgur.com/xPrXAt3.jpg" width="300" />
</p>
