package com.getcapacitor.community.media.photoviewer.helper

import android.net.Uri
import android.os.Environment
import java.io.File

class ImageToBeLoaded {
  fun getToBeLoaded( url: String) : Any? {
    var toBeLoaded: Any? = null
    val imgUrl = url
    val isCap: Boolean = imgUrl.contains("_capacitor_file_")

    if (imgUrl.startsWith("file://")) {
      // Handle file:// URLs
      val filePath = imgUrl.substring(7) // Remove "file://" prefix
      val file = File(filePath)
      if (file.exists()) {
        toBeLoaded = file
      }
    } else if (isCap) {
      // Handle Capacitor file URLs
      val filePath = imgUrl.substringAfter("_capacitor_file_")
      val file = File(filePath)
      if (file.exists()) {
        toBeLoaded = file
      }
    } else if (imgUrl.startsWith("http") || imgUrl.contains("base64")) {
      // Handle http URLs or base64 data
      toBeLoaded = imgUrl
    }

    return toBeLoaded
  }
}
