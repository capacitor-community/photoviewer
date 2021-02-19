export interface PhotoViewerPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
