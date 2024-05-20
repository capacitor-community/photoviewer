<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h2 align="center">API PLUGIN DOCUMENTATION</h2>
<p align="center"><strong><code>@capacitor-community/photoviewer</code></strong></p>
<p align="center">
  Capacitor community plugin for Native Photo Viewer allowing to open fullscreen a selected picture from a grid of pictures with zoom-in and sharing features. A picture can be acessed by url or base64.</p>
<p align="center">
  On iOS plugin, the creation of a movie from the pictures stored in the <strong>All Photos</strong> folder is now available.</p>

## Methods Index

<docgen-index>

* [`echo(...)`](#echo)
* [`show(...)`](#show)
* [`saveImageFromHttpToInternal(...)`](#saveimagefromhttptointernal)
* [`getInternalImagePaths()`](#getinternalimagepaths)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: capEchoOptions) => Promise<capEchoResult>
```

Echo a given string

| Param         | Type                                                      | Description                                    |
| ------------- | --------------------------------------------------------- | ---------------------------------------------- |
| **`options`** | <code><a href="#capechooptions">capEchoOptions</a></code> | : <a href="#capechooptions">capEchoOptions</a> |

**Returns:** <code>Promise&lt;<a href="#capechoresult">capEchoResult</a>&gt;</code>

**Since:** 0.0.1

--------------------


### show(...)

```typescript
show(options: capShowOptions) => Promise<capShowResult>
```

Show the PhotoViewer

| Param         | Type                                                      | Description                                  |
| ------------- | --------------------------------------------------------- | -------------------------------------------- |
| **`options`** | <code><a href="#capshowoptions">capShowOptions</a></code> | <a href="#capshowoptions">capShowOptions</a> |

**Returns:** <code>Promise&lt;<a href="#capshowresult">capShowResult</a>&gt;</code>

**Since:** 0.0.1

--------------------


### saveImageFromHttpToInternal(...)

```typescript
saveImageFromHttpToInternal(options: capHttpOptions) => Promise<capHttpResult>
```

Download an image from http and save it locally

| Param         | Type                                                      | Description                                  |
| ------------- | --------------------------------------------------------- | -------------------------------------------- |
| **`options`** | <code><a href="#caphttpoptions">capHttpOptions</a></code> | <a href="#caphttpoptions">capHttpOptions</a> |

**Returns:** <code>Promise&lt;<a href="#caphttpresult">capHttpResult</a>&gt;</code>

**Since:** 3.0.4

--------------------


### getInternalImagePaths()

```typescript
getInternalImagePaths() => Promise<capPaths>
```

Get the internal image path list

**Returns:** <code>Promise&lt;<a href="#cappaths">capPaths</a>&gt;</code>

**Since:** 3.0.4

--------------------


### Interfaces


#### capEchoResult

| Prop        | Type                | Description     |
| ----------- | ------------------- | --------------- |
| **`value`** | <code>string</code> | String returned |


#### capEchoOptions

| Prop        | Type                | Description         |
| ----------- | ------------------- | ------------------- |
| **`value`** | <code>string</code> | String to be echoed |


#### capShowResult

| Prop             | Type                 | Description                                                 |
| ---------------- | -------------------- | ----------------------------------------------------------- |
| **`result`**     | <code>boolean</code> | result set to true when successful else false               |
| **`message`**    | <code>string</code>  | a returned message                                          |
| **`imageIndex`** | <code>number</code>  | Result <a href="#image">Image</a> index at closing returned |


#### capShowOptions

| Prop            | Type                                                    | Description                                                |
| --------------- | ------------------------------------------------------- | ---------------------------------------------------------- |
| **`images`**    | <code>Image[]</code>                                    | List of image                                              |
| **`options`**   | <code><a href="#vieweroptions">ViewerOptions</a></code> | Viewer options (optional)                                  |
| **`mode`**      | <code>string</code>                                     | Viewer mode ("gallery","slider","one")                     |
| **`startFrom`** | <code>number</code>                                     | Viewer image index to start from for mode ("slider","one") |


#### Image

| Prop        | Type                | Description          |
| ----------- | ------------------- | -------------------- |
| **`url`**   | <code>string</code> | image url            |
| **`title`** | <code>string</code> | image title optional |


#### ViewerOptions

| Prop                     | Type                                                  | Description                                                                                                |
| ------------------------ | ----------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| **`share`**              | <code>boolean</code>                                  | display the share button (default true)                                                                    |
| **`title`**              | <code>boolean</code>                                  | display the image title if any (default true)                                                              |
| **`transformer`**        | <code>string</code>                                   | transformer Android "zoom", "depth" or "none" (default "zoom")                                             |
| **`spancount`**          | <code>number</code>                                   | Grid span count (default 3)                                                                                |
| **`maxzoomscale`**       | <code>number</code>                                   | Max Zoom Scale (default 3)                                                                                 |
| **`compressionquality`** | <code>number</code>                                   | Compression Quality for Sharing <a href="#image">Image</a> range [0-1] (default 0.8)                       |
| **`backgroundcolor`**    | <code>string</code>                                   | Background Color ["white", "ivory", "lightgrey", "darkgrey", "grey", "dimgrey", "black"] (default "black") |
| **`divid`**              | <code>string</code>                                   | Div HTML Element Id (Web only) (default 'photoviewer-container')                                           |
| **`movieoptions`**       | <code><a href="#movieoptions">MovieOptions</a></code> | Movie Options iOS only                                                                                     |
| **`customHeaders`**      | <code>{ [key: string]: string; }</code>               | Custom Headers                                                                                             |


#### MovieOptions

| Prop            | Type                | Description                                                              |
| --------------- | ------------------- | ------------------------------------------------------------------------ |
| **`name`**      | <code>string</code> | Movie Name (default "myMovie") iOS only                                  |
| **`imagetime`** | <code>number</code> | <a href="#image">Image</a> Time Duration in Seconds (default 3) iOS only |
| **`mode`**      | <code>string</code> | Movie Mode "portrait" / "landscape" (default "landscape") iOS only       |
| **`ratio`**     | <code>string</code> | Movie Ratio "4/3" / "16/9" (default "16/9") iOS only                     |


#### capHttpResult

| Prop          | Type                | Description                                         |
| ------------- | ------------------- | --------------------------------------------------- |
| **`webPath`** | <code>string</code> | Web View-friendly path of the internal stored image |
| **`message`** | <code>string</code> | message                                             |


#### capHttpOptions

| Prop           | Type                | Description                            |
| -------------- | ------------------- | -------------------------------------- |
| **`url`**      | <code>string</code> | https url of an image                  |
| **`filename`** | <code>string</code> | file name of the internal stored image |


#### capPaths

| Prop           | Type                  | Description     |
| -------------- | --------------------- | --------------- |
| **`pathList`** | <code>string[]</code> | image path list |

</docgen-api>

### Listeners

The listeners are attached to the plugin not to the DOM document element.

| Listener                   | Type                                | Description                             |
| -------------------------- | ----------------------------------- | -------------------------------------------- |
| **jeepCapPhotoViewerExit** | [capExitListener](#capexitlistener) | Emitted when the close button is pressed |

#### capExitListener

| Prop           | Type    | Description                                  |
| -------------- | ------- | -------------------------------------------- |
| **result**     | boolean | true if successful false otherwise           |
| **imageIndex** | number  | last selected image index in slider/one mode |
| **message**    | string  | error message if result is false             |
