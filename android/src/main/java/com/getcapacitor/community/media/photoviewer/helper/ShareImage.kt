package com.getcapacitor.community.media.photoviewer.helper

import android.content.ClipData
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.os.StrictMode
import android.view.Gravity
import android.widget.Toast
import androidx.core.content.FileProvider
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.target.Target
import com.bumptech.glide.request.transition.Transition
import com.getcapacitor.community.media.photoviewer.adapter.Image
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class ShareImage {
    private var tmpImage: File? = null

    fun shareImage(image: Image, appId: String, appContext: Context,
                          compressionQuality: Double) {
        if (Build.VERSION.SDK_INT >= 24) {
            try {
                val m = StrictMode::class.java.getMethod("disableDeathOnFileUriExposure")
                m.invoke(null)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        // convert TouchImageView to Bitmap File and share
        deleteTmpImage()
        createTmpImageAndShare(image, compressionQuality, appId, appContext)
        return
    }
    private fun shareIntentCreation(appId: String, appContext: Context) {
        // create the shareIntent
        try {
            val uri: Uri = FileProvider.getUriForFile(appContext,
                "$appId.fileprovider", tmpImage!!)
            val shareIntent = Intent()
            shareIntent.action = Intent.ACTION_SEND
            shareIntent.type = "\"image/*\""
            shareIntent.putExtra(Intent.EXTRA_STREAM, uri)
            shareIntent.clipData = ClipData.newRawUri(null, uri)
            shareIntent.addFlags(
                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                        Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)

            appContext.startActivity(Intent.createChooser(shareIntent, "Share image via"))

        } catch (e: java.lang.Exception) {
            val toast = Toast.makeText(appContext, e.message, Toast.LENGTH_SHORT)
            toast.setGravity(Gravity.TOP, 0, 50)
            toast.show()
            e.printStackTrace()
        }

    }
    private fun createTmpImageAndShare(image: Image, compressionQuality: Double,
                                       appId: String, appContext: Context) {
        val fileName: String = "share_image_" + System.currentTimeMillis() + ".png"
        tmpImage = File(appContext.filesDir, fileName)
        val mImageToBeLoaded = ImageToBeLoaded()
        val toBeLoaded = image.url?.let { mImageToBeLoaded.getToBeLoaded(it) }
        GlideApp.with(appContext)
            .asBitmap()
            .load(toBeLoaded)
            .override(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL)
            .into(object : CustomTarget<Bitmap>() {
                override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                    try {
                        val out = FileOutputStream(tmpImage)
                        val compression = compressionQuality * 100
                        resource.compress(Bitmap.CompressFormat.PNG, compression.toInt(), out)
                        out.close()
                        tmpImage!!.setReadable(true, false)
                        val toast = Toast.makeText(appContext, " created: $fileName", Toast.LENGTH_SHORT)
                        toast.setGravity(Gravity.TOP, 0, 50)
                        toast.show()

                        // share Intent creation
                        shareIntentCreation(appId, appContext)
                        return
                    } catch (e: IOException) {
                        e.printStackTrace()
                        val toast = Toast.makeText(appContext, e.message, Toast.LENGTH_SHORT)
                        toast.setGravity(Gravity.TOP, 0, 50)
                        toast.show()
                        return
                    }
                }

                override fun onLoadCleared(placeholder: Drawable?) {
                }
            })

    }
    private fun deleteTmpImage() {
        if (tmpImage != null) {
            val path: String = tmpImage!!.absolutePath
            println("in onDestroy $path")
            tmpImage!!.delete()
        }

    }

}
