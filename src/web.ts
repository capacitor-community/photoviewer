import { WebPlugin } from '@capacitor/core';

import type {
  PhotoViewerPlugin,
  capEchoOptions,
  capEchoResult,
  capShowOptions,
  capShowResult,
} from './definitions';

export class PhotoViewerWeb extends WebPlugin implements PhotoViewerPlugin {
  async echo(options: capEchoOptions): Promise<capEchoResult> {
    console.log('ECHO', options);
    return options;
  }
  async show(options: capShowOptions): Promise<capShowResult> {
    console.log('show', options);
    return Promise.resolve({
      result: false,
      message: `Not yet implemented on Web Platform`,
    });
  }
}
