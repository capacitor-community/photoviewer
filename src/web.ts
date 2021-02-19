import { WebPlugin } from '@capacitor/core';

import type { PhotoViewerPlugin } from './definitions';

export class PhotoViewerWeb extends WebPlugin implements PhotoViewerPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
