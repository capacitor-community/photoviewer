import { registerPlugin } from '@capacitor/core';

import type { PhotoViewerPlugin } from './definitions';

const PhotoViewer = registerPlugin<PhotoViewerPlugin>('PhotoViewer', {
  web: () => import('./web').then((m) => new m.PhotoViewerWeb()),
});

export * from './definitions';
export { PhotoViewer };
