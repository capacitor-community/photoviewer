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
  private _container: any;

  async echo(options: capEchoOptions): Promise<capEchoResult> {
    console.log('ECHO', options);
    return options;
  }
  async show(options: capShowOptions): Promise<capShowResult> {
    return new Promise<capShowResult>((resolve, reject) => {
      console.log('show', options);
      jeepPhotoviewer(window);
      if (Object.keys(options).includes('images')) {
        this._imageList = options.images;
      }
      if (Object.keys(options).includes('options')) {
        this._options = options.options ?? ({} as ViewerOptions);
      }
      const photoViewer: HTMLJeepPhotoviewerElement = document.createElement(
        'jeep-photoviewer',
      );
      photoViewer.imageList = this._imageList;
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
      this._container = document.querySelector(
        `#${divid}`,
      );
      photoViewer.addEventListener(
        'jeepPhotoViewerResult',
        async (ev: any) => {
          const res = ev.detail;
          if (res === null) {
            reject('Error: event does not include detail ');
          } else {
            this._container.removeChild(photoViewer);
            console.log(`res ${JSON.stringify(res)}`);
            resolve(res);
          }
        },
        false,
      );

      if (this._container != null) {
        this._container.appendChild(photoViewer);
      } else {
        reject("Div id='photoviewer-container' not found");
      }
    });
  }
}
