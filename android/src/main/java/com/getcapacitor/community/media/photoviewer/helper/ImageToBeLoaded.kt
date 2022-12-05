package com.getcapacitor.community.media.photoviewer.helper

import android.net.Uri
import android.os.Environment
import java.io.File

class ImageToBeLoaded {
  fun getToBeLoaded( url: String) : Any? {
    var toBeLoaded: Any? = null
    val imgUrl = url
    val isCap: Boolean = imgUrl.contains("_capacitor_file_")
    if ((imgUrl.substring(0, 4).equals("http") && !isCap) ||
      imgUrl.contains("base64") ) {
      toBeLoaded = imgUrl
    }
    if (imgUrl.substring(0, 4).equals("file") || isCap) {
      val uri: Uri = Uri.parse(imgUrl)
      val element: String? = uri.getLastPathSegment()
      var file: File? = null
      if(isCap) {
        val filePath = uri.getPath()?.removePrefix("/_capacitor_file_")
        file = filePath?.let { File(it) }
      } else {
        if (imgUrl.contains("DCIM")) {
          file = element?.let {
            File(
              Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM)
                .toString(), it
            )
          }
        }
        if (imgUrl.contains("Pictures")) {
          file = element?.let {
            File(
              Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
                .toString(), it
            )
          }
        }
      }
      toBeLoaded = file
    }
    return toBeLoaded
  }
}
