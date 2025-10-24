# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

## [7.1.0](https://github.com/capacitor-community/photoviewer/compare/v7.0.0...v7.1.0) (2025-10-24)


### Features

* **ios:** Add SPM support ([#87](https://github.com/capacitor-community/photoviewer/issues/87)) ([c18877e](https://github.com/capacitor-community/photoviewer/commit/c18877e20dcb00b2b84729c0f523d24572e8fe1e))

## [7.0.0](https://github.com/capacitor-community/photoviewer/compare/v4.0.1...v7.0.0) (2025-03-14)


### ⚠ BREAKING CHANGES

* This plugin now only supports Capacitor 7.

### Features

* update to Capacitor 7 ([#78](https://github.com/capacitor-community/photoviewer/issues/78)) ([d44fa5d](https://github.com/capacitor-community/photoviewer/commit/d44fa5d8a7088081280c2be30de67840593ab2e4))

### [4.0.1](https://github.com/capacitor-community/photoviewer/compare/v4.0.0...v4.0.1) (2024-09-04)


### Bug Fixes

* base64 string support ([#69](https://github.com/capacitor-community/photoviewer/issues/69)) ([92aea3c](https://github.com/capacitor-community/photoviewer/commit/92aea3c3cca3a07c480906e0b672e268197c4f53))

## [4.0.0](https://github.com/capacitor-community/photoviewer/compare/v3.2.0...v4.0.0) (2024-08-31)


### ⚠ BREAKING CHANGES

* This plugin now only supports Capacitor 6.

### Features

* update to Capacitor 6 ([#63](https://github.com/capacitor-community/photoviewer/issues/63)) ([809ae22](https://github.com/capacitor-community/photoviewer/commit/809ae225196c1df44735f590bda74c44128cd72f))

## 3.2.0 (2024-05-20)

### Cease of Maintenance

 - Update README.md

### Chore

 - Update to @capacitor/core 5.7.5
 - Update to @capacitor/ios 5.7.5
 - Update to @capacitor/android 5.7.5

### Added Features

 - Feat/custom headers PR#60 by Shiva Prasad

## 3.0.6 (2023_12_21)
#### Chore

 - Update to @capacitor/core 5.3.0
 - Update to @capacitor/ios 5.3.0
 - Update to @capacitor/android 5.3.0

## 3.0.5 (2023-12-21)

#### Bug fixes

 - Android Close button stops working after device is rotated issue#50
 - Android Display timeout disabled with plugin installed issue#43
 - iOS Photo and close button partially disappear off of screen when device is rotated issue#57 (PR#58 from camilocalvo)
 
## 3.0.4 (2023-09-24)

### Added Features

 - iOS Add method saveImageFromHttpToInternal
 - iOS Add method getInternalImagePaths
 - Add iOSImageLocation definition in capacitor.config.ts

### Bug fixes

 - Android fix App crashing when calling PhotoViewer.show after updating to version 3.0 and capacitor 5 issue#51


## 3.0.3 (2023-09-17)

### Bug fixes

 - Android fix closing with transition issue#38
 - Android fix App in prod calls ANR when user exits from image viewer issue#48
 - Android fix Image title on Android issue#39
 - Android fix Close button stops working after device is rotated issue#50

## 3.0.2 (2023-09-16)

### Bug fixes

 - Fix Web listener `jeepCapPhotoViewerExit`not fired.

## 3.0.1 (2023-09-12)

#### Chore

 - Update to @capacitor/core 5.3.0
 - Update to @capacitor/ios 5.3.0
 - Update to @capacitor/android 5.3.0

### Bug fixes

 - Fix request READ_MEDIA_IMAGES permission for Android SDK >= 33 PR#46 from Chirag Anand
 - Fix Kotlin Version for Capacitor in README.md PR#47 from Chirag Anand

## 3.0.0 (2023-05-22)

## 3.0.0-beta.1 (2023-05-21)

### Bug fixes

- Fix OS Share & Close button not visible issue#42
- Fix iOS invisible close button when opens images list in a slider mode 
issue#36

## 3.0.0-beta.0 (2023-05-16)

#### Chore

 - Update to @capacitor/core 5.0.3
 - Update to @capacitor/ios 5.0.3
 - Update to @capacitor/android 5.0.3

## 2.1.0 (2023-05-21)

#### Chore

 - Update to @capacitor/core 4.8.0
 - Update to @capacitor/ios 4.8.0
 - Update to @capacitor/android 4.8.0

### Bug fixes

- Fix OS Share & Close button not visible issue#42
- Fix iOS invisible close button when opens images list in a slider mode 
issue#36

## 2.0.10 (2023-01-26)

### Bug fixes

 - Android change onTouch() method signature #32 (PR from Nils Braune)

## 2.0.9 (2023-01-18)

#### Chore

 - Update to @capacitor/core 4.6.1
 - Update to @capacitor/ios 4.6.1
 - Update to @capacitor/android 4.6.1

### Bug fixes

 - Change method signature in OnSwipeTouchListener.kt #31 (PR from 
Nils Braune)

## 2.0.8 (2022-12-06)

### Bug fixes

- fix the web swipe-up & swipe-down gesture in jeep-photoviewer

## 2.0.7 (2022-12-05)

### Added Features

 - Add swipe-up & swipe-down gesture issue#26

## 2.0.6 (2022-12-03)

#### Chore

 - Update to @capacitor/core 4.5.0
 - Update to @capacitor/ios 4.5.0
 - Update to @capacitor/android 4.5.0

### Bug fixes

- fix The close button is not visible in iOS with Light theme on issue#27

## 2.0.5 (2022-10-04)

### Bug fixes

- fix bug in Android permissions

## 2.0.4 (2022-10-04)

### Bug fixes

  - fix issue #22 and issue #24

## 2.0.3 (2022-09-29)

### Bug fixes

 - fix local image web path (iOS)

## 2.0.2 (2022-09-29)

#### Chore

 - Update to @capacitor/core 4.2.0
 - Update to @capacitor/ios 4.2.0
 - Update to @capacitor/android 4.2.0

### Added Features

 - Add local image web path (iOS, Android) issue#22

## 2.0.1 (2022-09-28)

  - publish as `latest` release in npm

## 2.0.0-0 (2022-09-05)

#### Chore

 - Update to @capacitor/core 4.0.1
 - Update to @capacitor/ios 4.0.1
 - Update to @capacitor/android 4.0.1

## 1.1.3 (2022-03-09)

### Bug fixes

 - 1.1.2 was taken from a wrong 1.1.1
 
## 1.1.2 (2022-03-09)

### Chore

 - Update to @capacitor/core@3.4.1
 - Update to @capacitor/ios@3.4.1
 - Update to @capacitor/android@3.4.1
 - Update to jeep-photoviewer@1.1.4

### Bug fixes

 - Unable to show the SliderViewController issue#14
 - Google Play crash console issue#15
 
## 1.1.1 (2022-02-05)

### Chore

 - Update to jeep-photoviewer@1.1.3

### Bug fixes

 - Hide placeholder when black PNG image with transparency in gallery mode Web

## 1.1.0 (2022-02-04)

### Chore

 - Update to @capacitor/core@3.4.0
 - Update to @capacitor/ios@3.4.0
 - Update to @capacitor/android@3.4.0
 - Update to jeep-photoviewer@1.1.1

### Added Features

 - Add `backgroundcolor` option for iOS, Android & Web


## 1.0.9 (2022-01-22) 

### Bug fixes

 - Fix indexImage in SliderViewController iOS
 - Fix documentation `Ionic-Angular-Usage.md` && `Ionic-Vue-Usage.md`

## 1.0.8 (2022-01-19) 

### Added Features

 - Add `Slider` mode for iOS, Android & Web
 - Add `jeepCapPhotoViewerExit` plugin event listener

### Bug fixes

 - Add an option to open slider directly issue#11

## 1.0.7 (2022-01-11)

 - fix Web plugin for jeep-photoviewer@1.0.5

## 1.0.6 (2022-01-09)

### Bug fixes

 - Fix Android Image share

## 1.0.5 (2022-01-05)

### Added Features

 - Android add back press button on the three main fragments
 - iOS add close button in the photo gallery page
 - Link to a Vite React application

### Bug fixes

 - Update Readme for Android project issue#9
 - Add a link to a Vite React application issue#10


## 1.0.4 (2021-12-23)

### Added Features

 - Fix Android Manually close the image on back pressed issue#8

## 1.0.3 (2021-12-15)

### Chore

 - Update to @capacitor/core@3.3.2
 - Update to @capacitor/ios@3.3.2
 - Update to @capacitor/android@3.3.2

### Bug fixes

 - Fix iOS Wrong image ratio / Image cut off issue#7

## 1.0.2 (2021-11-04)

### Bug fixes

 - Fix issue#4

## 1.0.1 (2021-10-17)

### Bug fixes

 - Add s.dependency 'ISVImageScrollView' to the CapacitorCommunityPhotoviewer.podspec

## 1.0.0 (2021-10-17)

### Chore

 - Update to @capacitor/core@3.2.5
 - Update to @capacitor/ios@3.2.5
 - Update to @capacitor/android@3.2.5

### Add Features (iOS, Android)

 - One image mode pinch-zoom and pan

### Bug fixes

 - Fix issue#2

## 0.0.5 (2021-09-21)

### Bug fixes

 - fix all issues listed in issue#2 for iOS only

## 0.0.4 (2021-09-20)

### Add Features (Android)

 - Display a fullscreen view when the image list contains one image

## 0.0.3 (2021-09-19)

### Chore

 - Update to @capacitor/core@3.2.3
 - Update to jeep-photoviewer@1.0.1

### Add Features (Web, iOS)

 - Display a fullscreen view when the image list contains one image

## 0.0.2 (2021-08-12)

### Chore

 - Update to @capacitor/core@3.1.2

### Add Features

 - Add Ionic-Angular-Usage.md

## 0.0.1 (2021-07-13)

### Chore

 - Update to @capacitor/core@3.1.1

## 0.0.1-rc.1 (2021-05-16)

### Chore

 - Update to @capacitor/core@3.0.0-rc.3

## 0.0.1-beta.3 (2021-03-28)

### Bug fixes

 - fix issue with jeep-photoviewer loader
 
## 0.0.1-beta.2 (2021-03-27)

### Chore

 - Update to @capacitor/core@3.0.0-rc.0

### Added Features

 - Web plugin by using `jeep-photoviewer` Stencil component.
 - Add movie creation to iOS plugin


## 0.0.1-beta.1 (2021-03-08) 

### Chore

 - Update to @capacitor/android@3.0.0-beta.6

### Added Features

 - Android Rotation Portrait to Landscape 
 - Android Close button when image in fullscreen
 - Android Hiding Share and Close button on singleTap

## 0.0.1-alpha.2 (2021-03-06) 

### Added Features

 - iOS Reading Base64 images
 - iOS Sharing an image
 - iOS Gestures for Zooming in/out
 - maxzoomscale options
 - compression quality options


## 0.0.1-alpha.1 (2021-03-02) 

- Initial commit for Photoviewer Android and iOS
