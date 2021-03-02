<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h2 align="center">API PLUGIN DOCUMENTATION 🚧</h2>
<p align="center"><strong><code>@capacitor-community/photoviewer</code></strong></p>
<p align="center">
  Capacitor community plugin for Native Photo Viewer allowing to open fullscreen a selected picture from a grid of pictures with zoom-in and sharing features. A picture can be acessed by url or base64.

## Methods Index

<docgen-index>

* [`echo(...)`](#echo)
* [`show(...)`](#show)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: capEchoOptions) => any
```

Echo a given string

| Param         | Type                                                      | Description                                    |
| ------------- | --------------------------------------------------------- | ---------------------------------------------- |
| **`options`** | <code><a href="#capechooptions">capEchoOptions</a></code> | : <a href="#capechooptions">capEchoOptions</a> |

**Returns:** <code>any</code>

**Since:** 0.0.1

--------------------


### show(...)

```typescript
show(options: capShowOptions) => any
```

Show the PhotoViewer

| Param         | Type                                                      |
| ------------- | --------------------------------------------------------- |
| **`options`** | <code><a href="#capshowoptions">capShowOptions</a></code> |

**Returns:** <code>any</code>

--------------------


### Interfaces


#### capEchoOptions

| Prop        | Type                | Description         |
| ----------- | ------------------- | ------------------- |
| **`value`** | <code>string</code> | String to be echoed |


#### capEchoResult

| Prop        | Type                | Description     |
| ----------- | ------------------- | --------------- |
| **`value`** | <code>string</code> | String returned |


#### capShowOptions

| Prop          | Type                                                    | Description               |
| ------------- | ------------------------------------------------------- | ------------------------- |
| **`images`**  | <code>{}</code>                                         | List of image             |
| **`options`** | <code><a href="#vieweroptions">ViewerOptions</a></code> | Viewer options (optional) |


#### Image

| Prop        | Type                | Description          |
| ----------- | ------------------- | -------------------- |
| **`url`**   | <code>string</code> | image url            |
| **`title`** | <code>string</code> | image title optional |


#### ViewerOptions

| Prop              | Type                 | Description                                                    |
| ----------------- | -------------------- | -------------------------------------------------------------- |
| **`share`**       | <code>boolean</code> | display the share button (default true)                        |
| **`title`**       | <code>boolean</code> | display the image title if any (default true)                  |
| **`transformer`** | <code>string</code>  | transformer Android "zoom", "depth" or "none" (default "zoom") |
| **`spancount`**   | <code>number</code>  | Grid span count (default 3)                                    |


#### capShowResult

| Prop          | Type                 | Description                                   |
| ------------- | -------------------- | --------------------------------------------- |
| **`result`**  | <code>boolean</code> | result set to true when successful else false |
| **`message`** | <code>string</code>  | a returned message                            |

</docgen-api>
