import { WebPlugin } from '@capacitor/core';
import { defineCustomElements as jeepPhotoviewer } from 'jeep-photoviewer/loader';

import type {
  PhotoViewerPlugin,
  capEchoOptions,
  capEchoResult,
  capShowOptions,
  capShowResult,
  Image,
  ViewerOptions,
} from './definitions';

export class PhotoViewerWeb extends WebPlugin implements PhotoViewerPlugin {
  private _imageList: Image[] = [];
  private _options: ViewerOptions = {} as ViewerOptions;
  private _mode = 'one';
  private _startFrom = 0;
  private _container: any;
  private _modeList: string[] = ['one', 'gallery', 'slider'];

  async echo(options: capEchoOptions): Promise<capEchoResult> {
    return options;
  }
  async show(options: capShowOptions): Promise<capShowResult> {
    return new Promise<capShowResult>((resolve, reject) => {
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
      const photoViewer: HTMLJeepPhotoviewerElement =
        document.createElement('jeep-photoviewer');
      photoViewer.imageList = this._imageList;
      photoViewer.mode = this._mode;
      if (this._mode === 'one' || this._mode === 'slider') {
        photoViewer.startFrom = this._startFrom;
      }
      const optionsKeys: string[] = Object.keys(this._options);
      let divid: string | undefined;
      if (optionsKeys.length > 0) {
        photoViewer.options = this._options;
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

        photoViewer.addEventListener(
          'jeepPhotoViewerResult',
          async (ev: any) => {
            const res = ev.detail;
            if (res === null) {
              reject('Error: event does not include detail ');
            } else {
              this.notifyListeners('jeepCapPhotoViewerExit', res);
              this._container.removeChild(photoViewer);
              resolve(res);
            }
          },
          false,
        );

        this._container.appendChild(photoViewer);
      } else {
        reject("Div id='photoviewer-container' not found");
      }
    });
  }
}
