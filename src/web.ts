import { WebPlugin } from '@capacitor/core';
import { defineCustomElements as jeepPhotoviewer } from 'jeep-photoviewer/loader';

import type {
  capEchoOptions,
  capEchoResult,
  capHttpOptions,
  capHttpResult,
  capPaths,
  capShowOptions,
  capShowResult,
  Image,
  PhotoViewerPlugin,
  ViewerOptions,
} from './definitions';

export class PhotoViewerWeb extends WebPlugin implements PhotoViewerPlugin {
  private _imageList: Image[] = [];
  private _options: ViewerOptions = {} as ViewerOptions;
  private _mode = 'one';
  private _startFrom = 0;
  private _container: any;
  private _modeList: string[] = ['one', 'gallery', 'slider'];
  private _photoViewer!: HTMLJeepPhotoviewerElement;

  constructor() {
    super();
    document.addEventListener('jeepPhotoViewerResult', this.jeepPhotoViewerResult, false);
  }

  async echo(options: capEchoOptions): Promise<capEchoResult> {
    return options;
  }
  async show(options: capShowOptions): Promise<capShowResult> {
    //    return new Promise<capShowResult>( (resolve, reject) => {
    jeepPhotoviewer(window);
    if (Object.keys(options).includes('images')) {
      this._imageList = options.images;
    }
    if (Object.keys(options).includes('options')) {
      this._options = options.options ?? ({} as ViewerOptions);
    }
    if (Object.keys(options).includes('mode')) {
      const mMode = options.mode;
      if (this._modeList.includes(mMode as string)) {
        this._mode = mMode ?? 'one';
      }
    }
    if (Object.keys(options).includes('startFrom')) {
      const mStartFrom = options.startFrom;
      this._startFrom = mStartFrom ?? 0;
    }
    this._photoViewer = document.createElement('jeep-photoviewer');
    this._photoViewer.imageList = this._imageList;
    this._photoViewer.mode = this._mode;
    if (this._mode === 'one' || this._mode === 'slider') {
      this._photoViewer.startFrom = this._startFrom;
    }
    const optionsKeys: string[] = Object.keys(this._options);
    let divid: string | undefined;
    if (optionsKeys.length > 0) {
      this._photoViewer.options = this._options;
      if (optionsKeys.includes('divid')) {
        divid = this._options.divid;
      } else {
        divid = 'photoviewer-container';
      }
    } else {
      divid = 'photoviewer-container';
    }
    this._container = document.querySelector(`#${divid}`);
    // check if already a photoviewer element
    if (this._container != null) {
      const isPVEl = this._container.querySelector('jeep-photoviewer');
      if (isPVEl != null) {
        this._container.removeChild(isPVEl);
      }

      this._container.appendChild(this._photoViewer);
      await customElements.whenDefined('jeep-photoviewer');

      return Promise.resolve({ result: true });
    } else {
      return Promise.reject("Div id='photoviewer-container' not found");
    }
  }
  async saveImageFromHttpToInternal(options: capHttpOptions): Promise<capHttpResult> {
    console.log('saveImageFromHttpToInternal', options);
    throw this.unimplemented('Not implemented on web.');
  }
  async getInternalImagePaths(): Promise<capPaths> {
    throw this.unimplemented('Not implemented on web.');
  }

  private jeepPhotoViewerResult = (ev: any) => {
    const res = ev.detail;
    if (res !== null) {
      this.notifyListeners('jeepCapPhotoViewerExit', res);
    }
  };
}
