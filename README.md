<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">PHOTO VIEWER</h3>
<p align="center"><strong><code>@capacitor-community/photoviewer</code></strong></p>
<br>
<p align="left">
Capacitor community plugin for Web and Native Photo Viewer allowing to open fullscreen </p>
<p align="left">
- a selected picture from a grid of pictures with zoom-in and sharing features. </p>
<p align="left">
- a single picture with zoom-in and sharing features.</p>
<p align="left">
A picture can be acessed by image web url, base64 data or from internal device for iOS and Android.
</p>
<p align="left">
- iOS
</p>
<ul>
<li><strong><code>file:///var/mobile/Media/DCIM/100APPLE/YOUR_IMAGE.JPG</code></strong></li>
<li><strong><code>capacitor://localhost/_capacitor_file_/var/mobile/Containers/Data/Application/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX/Documents/photo1.jpg</code></strong></li>
</ul>
<p align="left">
- Android
</p>
<ul>
<li><strong><code>file:///sdcard/DCIM/YOUR_IMAGE.JPG</code></strong></li>
<li><strong><code>file:///sdcard/Pictures/YOUR_IMAGE.JPG</code></strong></li>
<li><strong><code>http://localhost/_capacitor_file_/storage/emulated/0/Pictures/JPEG_20221001_113835_7582877022250987909.jpg</code></strong></li>
</ul>

<p align="left">
On iOS plugin, the creation of a movie from the pictures stored in the <strong>All Photos</strong> folder is now available.
</p>

<br>
<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2025?style=flat-square" />
  <a href="https://www.npmjs.com/package/@capacitor-community/photoviewer"><img src="https://img.shields.io/npm/l/@capacitor-community/photoviewer?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/@capacitor-community/photoviewer"><img src="https://img.shields.io/npm/dw/@capacitor-community/photoviewer?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@capacitor-community/photoviewer"><img src="https://img.shields.io/npm/v/@capacitor-community/photoviewer?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="#contributors-"><img src="https://img.shields.io/badge/all%20contributors-8-orange?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>
<br>

## Maintainers

| Maintainer | GitHub                                    | Social                                        |
| ---------- | ----------------------------------------- | --------------------------------------------- |
| Robin Genz | [robingenz](https://github.com/robingenz) | [@robin_genz](https://twitter.com/robin_genz) |

## Browser Support

The plugin follows the guidelines from the `Capacitor Team`,

- [Capacitor Browser Support](https://capacitorjs.com/docs/v3/web#browser-support)

meaning that it will not work in IE11 without additional JavaScript transformations, e.g. with [Babel](https://babeljs.io/).

## Installation

```bash
npm install @capacitor-community/photoviewer
npx cap sync
```

Since version 3.0.4, modify the `capacitor.config.ts` to add the image location to save the image downloaded from an HTTP request to the internal disk.

```ts
const config: CapacitorConfig = {
  ...
  plugins: {
    PhotoViewer: {
      iosImageLocation: 'Library/Images',
      androidImageLocation: 'Files/Images',
    }
  }
  ...
};

export default config;


```
### iOS

- in Xcode, open `Info.plist` and add a new Information Property like `Privacy - Photo Library Usage Description` and set a value to `We need to write photos`. This is required to have the `Share`of images and the `create Movie` working.

### Android

- on the `res` project folder open the `file_paths.xml` file and add

```xml
    <files-path name="files" path="."/>
```

- open the `build.gradle (Project:android)` and make sure that `kotlin` is declared

```js
...
buildscript {
    ext.kotlin_version = '1.9.25'
    dependencies {
        ...
        classpath 'com.android.tools.build:gradle:8.8.1'
        classpath 'com.google.gms:google-services:4.4.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
...
```

- open the `build.gradle (Module: android.app)` and do the following

    - after `apply plugin: 'com.android.application'` add
        ```
        apply plugin: 'kotlin-android'
        apply plugin: 'kotlin-kapt'
        ```

    - in the `android` block add
        ```
        buildFeatures {
            dataBinding = true
        }
        ```

    - in the `repositories` block add
        ```
        maven { url 'https://jitpack.io' }
        ```
    - in the `dependencies` block add
        ```
        implementation "androidx.core:core-ktx:1.15.0"
        implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
        ```

- Now run `Sync Project with Gradle Files` and you are ready.

### Web, PWA

The plugin works with the companion Stencil component `jeep-photoviewer`.
It is mandatory to install it

```
npm install --save-dev jeep-photoviewer@latest
```


### Build your App

When your app is ready

```bash
npm run build
npx cap copy
npx cap copy web
npx cap open android   // Android
npx cap open ios       // iOS
npm run serve          // Web
```

## Supported methods

| Name                        | Android | iOS  | Electron | Web  |
| :-------------------------- | :------ | :--- | :------- | :--- |
| echo                        | ✅       | ✅    | ❌        | ✅    |
| show                        | ✅       | ✅    | ❌        | ✅    |
| saveImageFromHttpToInternal | ❌       | ✅    | ❌        | ❌    |
| getInternalImagePaths       | ❌       | ✅    | ❌        | ❌    |


## Documentation

[API_Documentation](https://github.com/capacitor-community/photoviewer/blob/master/docs/API.md)

## Applications demonstrating the use of the plugin

### Ionic/Angular

- [angular-photoviewer-app](https://github.com/jepiqueau/angular-photoviewer-app)

### Ionic/Vue

- [vue-photoviewer-app](https://github.com/jepiqueau/vue-photoviewer-app)

### React

- [vite-react-photoviewer-app](https://github.com/jepiqueau/vite-react-photoviewer-app)

## Usage

- [In your Ionic/Vue App](https://github.com/capacitor-community/photoviewer/blob/master/docs/Ionic-Vue-Usage.md)

- [In your Ionic/Angular App](https://github.com/capacitor-community/photoviewer/blob/master/docs/Ionic-Angular-Usage.md)



### iOS and Android

- In `Gallery` mode (Image Array with more than one Image):
    - make a `tap` will select the image and go fullscreen
    - In Fulscreen
        - `tap` will hide the share and exit buttons and open the window for other gestures.
        - `double tap` to zoom in and out
        - `pinch` with your two fingers
        - `tap` will show the share and exit buttons and leave the window for other gestures.
        - `double tap` will hide the buttons and zoom in straightforward (iOS only)
- In `One Image` mode (Image Array with one Image only):
    - `pinch-zoom` and `pan` with your two fingers
    - `double-tap` to zoom directly to the maximum zoom
- You can pass customHeaders in the options object to let the plugin pass those headers to the http request for the image. For example:

```ts
PhotoViewer.show({
  images: [
    {
      url: 'https://picsum.photos/id/237/200/300',
      title: 'Title'
    },
    {
      url: 'https://picsum.photos/id/238/200/300',
      title: 'Title'
    },
  ],
  options: {
    customHeaders: {
      accept: 'image/jpeg, image/png, image/gif, image/webp, image/svg+xml, image/*;q=0.8, */*;q=0.5',
      cookie: 'session=foo;',
    },
  },
  mode: 'slider'
})
```


## Dependencies

The Android code is using `MikeOrtiz/TouchImageView` allowing for the zooming in picture (https://github.com/MikeOrtiz/TouchImageView)

The iOS code is using `SDWebImage` for http async image downloader (https://github.com/SDWebImage/SDWebImage) and `ISVImageScrollView` for the pinch-zoom and pan in picture (https://github.com/yuriiik/ISVImageScrollView)

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<p align="center">
  <a href="https://github.com/jepiqueau" title="jepiqueau"><img src="https://github.com/jepiqueau.png?size=100" width="50" height="50" /></a>
  <a href="https://github.com/ludufre" title="ludufre"><img src="https://github.com/ludufre.png?size=100" width="50" height="50" /></a>
  <a href="https://github.com/rdlabo" title="rdlabo"><img src="https://github.com/rdlabo.png?size=100" width="50" height="50" /></a>
  <a href="https://github.com/bozhidarc" title="bozhidarc"><img src="https://github.com/bozhidarc.png?size=100" width="50" height="50" /></a>
  <a href="https://github.com/adnbrownie" title="adnbrownie"><img src="https://github.com/adnbrownie.png?size=100" width="50" height="50" /></a>
  <a href="https://github.com/chiraganand" title="chiraganand"><img src="https://github.com/chiraganand.png?size=100" width="50" height="50" /></a>
  <a href="https://github.com/https://github.com/camilocalvo" title="camilocalvo"><img src="https://github.com/camilocalvo.png?size=100" width="50" height="50" /></a>
  <a href="https://github.com/shiv19" title="shiv19"><img src="https://github.com/shiv19.png?size=100" width="50" height="50" /></a>
</p>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
