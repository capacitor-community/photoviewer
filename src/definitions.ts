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
   *
   * @param options capShowOptions
   * @return Promise<capShowResult>
   * @since 0.0.1
   */
  show(options: capShowOptions): Promise<capShowResult>;

  /**
   * Download an image from http and save it locally
   *
   * @param options capHttpOptions
   * @return Promise<capHttpResult>
   * @since 3.0.4
   */
  saveImageFromHttpToInternal(options: capHttpOptions): Promise<capHttpResult>;

  /**
   * Get the internal image path list
   *
   * @return Promise<capPaths>
   * @since 3.0.4
   */
  getInternalImagePaths(): Promise<capPaths>;
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
  /**
   * Viewer mode ("gallery","slider","one")
   */
  mode?: string;
  /**
   * Viewer image index to start from for mode ("slider","one")
   */
  startFrom?: number;
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
  /**
   * Result Image index at closing returned
   */
  imageIndex?: number;
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
  /**
   * Max Zoom Scale (default 3)
   */
  maxzoomscale?: number;
  /**
   * Compression Quality for Sharing Image range [0-1] (default 0.8)
   */
  compressionquality?: number;
  /**
   * Background Color
   * ["white", "ivory", "lightgrey", "darkgrey", "grey", "dimgrey", "black"]
   * (default "black")
   */
  backgroundcolor?: string;
  /**
   * Div HTML Element Id (Web only) (default 'photoviewer-container')
   */
  divid?: string;
  /**
   * Movie Options iOS only
   */
  movieoptions?: MovieOptions;
  /**
   * Custom Headers
   */
  customHeaders?: { [key: string]: string };
}
export interface MovieOptions {
  /**
   * Movie Name (default "myMovie") iOS only
   */
  name?: string;
  /**
   * Image Time Duration in Seconds (default 3) iOS only
   */
  imagetime?: number;
  /**
   * Movie Mode "portrait" / "landscape" (default "landscape") iOS only
   */
  mode?: string;
  /**
   * Movie Ratio "4/3" / "16/9" (default "16/9") iOS only
   */
  ratio?: string;
}
export interface capHttpOptions {
  /**
   * https url of an image
   */
  url: string;
  /**
   * file name of the internal stored image
   */
  filename: string;
}
export interface capHttpResult {
  /**
   * Web View-friendly path of the internal stored image
   */
  webPath?: string;
  /**
   * message
   */
  message?: string;
}
export interface capPaths {
  /**
   * image path list
   */
  pathList: string[];
}
