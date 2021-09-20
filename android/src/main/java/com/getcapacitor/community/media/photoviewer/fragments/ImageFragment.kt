package com.getcapacitor.community.media.photoviewer.fragments

import android.content.ClipData
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.StrictMode
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import androidx.core.content.FileProvider
import androidx.core.view.isVisible
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.target.Target
import com.bumptech.glide.request.transition.Transition
import com.getcapacitor.JSObject
import com.getcapacitor.community.media.photoviewer.R
import com.getcapacitor.community.media.photoviewer.adapter.Image
import com.getcapacitor.community.media.photoviewer.databinding.ImageFragmentBinding
import com.getcapacitor.community.media.photoviewer.helper.CallbackListener
import com.getcapacitor.community.media.photoviewer.helper.GlideApp
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class ImageFragment : Fragment() , CallbackListener {
    private val TAG = "ImageFragment"
    private var imageFragmentBinding: ImageFragmentBinding? = null
    private var bShare: Boolean = true
    private var bTitle: Boolean = true
    private var maxZoomScale: Double = 3.0
    private var compressionQuality: Double = 0.8
    private var tmpImage: File? = null
    lateinit var appId: String
    lateinit var tvTitle: TextView
    lateinit var ivFullscreenImage: ImageView
    lateinit var rlMenu: RelativeLayout

    private lateinit var image: Image
    private var options = JSObject()
    var mContainer: ViewGroup? = null
    lateinit var mInflater: LayoutInflater
    lateinit var  appContext: Context


    fun setImage(image: Image) {
        this.image = image
    }
    fun setOptions(options: JSObject) {
        this.options = options
        if(this.options.has("share")) bShare = this.options.getBoolean("share")
        if(this.options.has("title")) bTitle = this.options.getBoolean("title")
        if(this.options.has("maxzoomscale")) maxZoomScale = this.options
            .getDouble("maxzoomscale")
        if(this.options.has("compressionquality")) compressionQuality = this.options
            .getDouble("compressionquality")
    }
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        Log.d(TAG, " in onCreateView imageFragment")
        mInflater = inflater
        if (container != null) {
            mContainer  = container
            val view: View = initializeView()
            return view
        }
        return null
    }
    private fun initializeView(): View {
        if (mContainer != null) {
            mContainer?.removeAllViewsInLayout()
        }
        appContext = this.requireContext()
        appId = appContext.applicationInfo.processName
        Log.d(TAG, ">>>option appliocation id: $appId")

        // Inflate the layout for this fragment
        val binding = ImageFragmentBinding.inflate(mInflater, mContainer, false)
        imageFragmentBinding = binding
        val orientation: Int = resources.configuration.orientation
        Log.d(TAG, "orientation: $orientation")
        if(orientation == Configuration.ORIENTATION_PORTRAIT) {
            Log.d(TAG, "orientation Portrait")
        } else {
            Log.d(TAG, "orientation Landscape")
        }
        rlMenu = binding.menuBtns
        tvTitle = binding.tvTitle
        if(!bTitle) tvTitle.visibility = View.INVISIBLE
        ivFullscreenImage = binding.ivFullscreenImage
        tvTitle.text = image.title
        GlideApp.with(appContext)
            .load(image.url)
            .fitCenter()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            .into(ivFullscreenImage)
//        mContainer?.addView(binding.root)

        val share: ImageButton = binding.shareBtn
        if(!bShare) share.visibility = View.INVISIBLE
        val clickListener = View.OnClickListener { viewFS ->
            when (viewFS.getId()) {
                R.id.shareBtn -> {
                    shareImage(image)
                }
                R.id.ivFullscreenImage -> {
                    Log.d(TAG, "click on image")
                    toggleMenu()
                    showTouchView()
                }

            }
        }
        share.setOnClickListener(clickListener)
        ivFullscreenImage.setOnClickListener(clickListener)

        return binding.root
    }

    override fun onConfigurationChanged(newConfig: Configuration) {
        Log.d(TAG, "$$ onConfigurationChanged ${newConfig.orientation}")
        val view: View = initializeView()
        mContainer?.addView(view)
        super.onConfigurationChanged(newConfig)
    }
    override fun onDestroyView() {
        imageFragmentBinding = null
        clearCache()
        super.onDestroyView()
    }
    private fun clearCache() {
        Thread(Runnable {
            Glide.get(appContext).clearDiskCache()
        }).start()
        Glide.get(appContext).clearMemory()
    }

    override fun onMenuToggle() {
        toggleMenu()
    }
    private fun showTouchView() {
        val touchViewFragment = TouchViewFragment(this)
        touchViewFragment.setStyle(DialogFragment.STYLE_NORMAL, R.style.Dialog_FullScreen)
        image.url?.let { touchViewFragment.setUrl(it) }
        activity?.let { touchViewFragment.show(it.supportFragmentManager, "touchview") }
    }
    private fun toggleMenu() {
        rlMenu.isVisible = !rlMenu.isVisible
    }
    private fun shareImage(image: Image) {
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
        createTmpImageAndShare(image)
        return
    }
    private fun shareIntentCreation() {
        // create the shareIntent
        try {
            val uri: Uri = FileProvider.getUriForFile(requireContext(),
                "$appId.provider", tmpImage!!)
            val shareIntent = Intent()
            shareIntent.action = Intent.ACTION_SEND
            shareIntent.type = "\"image/*\""
            shareIntent.putExtra(Intent.EXTRA_STREAM, uri)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                shareIntent.setClipData(ClipData.newRawUri(null, uri));
            }

            shareIntent.addFlags(
                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION or
                        Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)

            startActivity(Intent.createChooser(shareIntent, "Share image via"))

        } catch (e: java.lang.Exception) {
            val toast = Toast.makeText(requireContext(), e.message, Toast.LENGTH_SHORT)
            toast.setGravity(Gravity.TOP, 0, 50)
            toast.show()
            e.printStackTrace()
        }

    }
    private fun createTmpImageAndShare(image: Image) {
        val fileName: String = "share_image_" + System.currentTimeMillis() + ".png"
        tmpImage = File(requireContext().filesDir, fileName)
        GlideApp.with(requireContext())
            .asBitmap()
            .load(image.url)
            .override(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL)
            .into(object : CustomTarget<Bitmap>() {
                override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                    try {
                        val out: FileOutputStream = FileOutputStream(tmpImage)
                        val compression = compressionQuality * 100
                        resource.compress(Bitmap.CompressFormat.PNG, compression.toInt(), out)
                        out.close()
                        tmpImage!!.setReadable(true, false)
                        val toast = Toast.makeText(context!!, " created: $fileName", Toast.LENGTH_SHORT)
                        toast.setGravity(Gravity.TOP, 0, 50)
                        toast.show()

                        // share Intent creation
                        shareIntentCreation()
                        return
                    } catch (e: IOException) {
                        e.printStackTrace()
                        val toast = Toast.makeText(context!!, e.message, Toast.LENGTH_SHORT)
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
