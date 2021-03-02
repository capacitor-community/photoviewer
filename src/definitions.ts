export interface PhotoViewerPlugin {
  /**
   * Echo a given string
   *
   * @param options: capEchoOptions
   * @return Promise<capEchoResult>
   * @since 0.0.1
   */
  echo(options: capEchoOptions): Promise<capEchoResult>;
  /**
   * Show the PhotoViewer
   * @param options
   */
  show(options: capShowOptions): Promise<capShowResult>;
}
export interface capShowOptions {
  /**
   *  List of image
   */
  images: Image[];
  /**
   * Viewer options (optional)
   */
  options?: ViewerOptions;
}
export interface capEchoOptions {
  /**
   *  String to be echoed
   */
  value?: string;
}
export interface capEchoResult {
  /**
   * String returned
   */
  value?: string;
}
export interface capShowResult {
  /**
   * result set to true when successful else false
   */
  result?: boolean;
  /**
   * a returned message
   */
  message?: string;
}
export interface Image {
  /**
   * image url
   */
  url: string;
  /**
   * image title optional
   */
  title?: string;
}
export interface ViewerOptions {
  /**
   * display the share button (default true)
   */
  share?: boolean;
  /**
   * display the image title if any (default true)
   */
  title?: boolean;
  /**
   * transformer Android "zoom", "depth" or "none" (default "zoom")
   */
  transformer?: string;
  /**
   * Grid span count (default 3)
   */
  spancount?: number;
}
