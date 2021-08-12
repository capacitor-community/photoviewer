<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h3 align="center">PHOTO VIEWER</h3>
<p align="center"><strong><code>@capacitor-community/photoviewer</code></strong></p>
<br>
<p align="center" style="font-size:50px;color:red"><strong>Capacitor 3 Android, iOS and Web </strong></p>
<p align="center" style="font-size:50px;color:red"><strong>Electron 🚧</strong></p><br>

<p align="center">
  Capacitor community plugin for Web and Native Photo Viewer allowing to open fullscreen a selected picture from a grid of pictures with zoom-in and sharing features. A picture can be acessed by url or base64. On iOS plugin, the creation of a movie from the pictures stored in the <strong>All Photos</strong> folder is now available.
</p>
<br>
<p align="center">
  <img src="https://img.shields.io/maintenance/yes/2021?style=flat-square" />
  <a href="https://www.npmjs.com/package/@capacitor-community/photoviewer"><img src="https://img.shields.io/npm/l/@capacitor-community/photoviewer?style=flat-square" /></a>
<br>
  <a href="https://www.npmjs.com/package/@capacitor-community/photoviewer"><img src="https://img.shields.io/npm/dw/@capacitor-community/photoviewer?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/@capacitor-community/photoviewer"><img src="https://img.shields.io/npm/v/@capacitor-community/photoviewer?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
<a href="#contributors-"><img src="https://img.shields.io/badge/all%20contributors-1-orange?style=flat-square" /></a>
<!-- ALL-CONTRIBUTORS-BADGE:END -->
</p>
<br>

## Maintainers

| Maintainer        | GitHub                                    | Social |
| ----------------- | ----------------------------------------- | ------ |
| Quéau Jean Pierre | [jepiqueau](https://github.com/jepiqueau) |        |

## Browser Support

The plugin follows the guidelines from the `Capacitor Team`,

- [Capacitor Browser Support](https://capacitorjs.com/docs/v3/web#browser-support)

meaning that it will not work in IE11 without additional JavaScript transformations, e.g. with [Babel](https://babeljs.io/).

## Installation

```bash
npm install @capacitor-community/photoviewer
npx cap sync
```

### iOS

- in Xcode, open `Info.plist` and add a new Information Property like `Privacy - Photo Library Usage Description` and set a value to `We need to write photos`. This is required to have the `Share`of images and the `create Movie` working.

### Android

- open the project `AndroidManifest.xml` and add the following to the application tag

```xml
    </application>
        ...
        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="${applicationId}.provider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths"></meta-data>
        </provider>
        ...
    </application>
```
as well the Internet permission
```xml
<manifest>
    ...
    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    ...
</manifest>

``` 

- on the `res` project folder create a folder `xml`if it does not exist and create a `file_paths.xml` file containing

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <files-path
        name="files"
        path="."/>

</paths>
```

- open the `build.gradle (Project:android)` and make sure that `kotlin` is declared

```js
...
buildscript {
    ext.kotlin_version = '1.5.0'

    repositories {
        google()
        jcenter()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:4.1.2'
        classpath 'com.google.gms:google-services:4.3.3'
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
        implementation "androidx.core:core-ktx:+"
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

| Name     | Android | iOS | Electron | Web |
| :------- | :------ | :-- | :------- | :-- |
| echo     |   ✅    |  ✅  |    ❌    |  ✅ |
| show     |   ✅    |  ✅  |    ❌    |  ✅ |


## Documentation

[API_Documentation](https://github.com/capacitor-community/photoviewer/blob/master/docs/API.md)

## Applications demonstrating the use of the plugin

### Ionic/Vue

- [vue-photoviewer-app](https://github.com/jepiqueau/vue-photoviewer-app)

## Usage

- [In your Ionic/Vue App](https://github.com/capacitor-community/photoviewer/blob/master/docs/Ionic-Vue-Usage.md)

- [In your Ionic/Angular App](https://github.com/capacitor-community/photoviewer/blob/master/docs/Ionic-Angular-Usage.md)



### iOS an Android

- In the Gallery make a `tap` will select the image and go fullscreen
- In Fulscreen
    - `tap` will hide the share and exit buttons and open the window for other gestures.
      - `double tap` to zoom in and out  
      - `pinch` with your two fingers
      - `tap` will show the share and exit buttons and leave the window for other gestures.

## Dependencies

The Android code is using `MikeOrtiz/TouchImageView` allowing for the zooming in picture (https://github.com/MikeOrtiz/TouchImageView)

The iOS code is using `SDWebImage` for http async image downloader (https://github.com/SDWebImage/SDWebImage)

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/jepiqueau"><img src="https://avatars3.githubusercontent.com/u/16580653?v=4" width="100px;" alt=""/><br /><sub><b>Jean Pierre Quéau</b></sub></a><br /><a href="https://github.com/capacitor-community/photoviewer/commits?author=jepiqueau" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
