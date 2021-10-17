package com.getcapacitor.community.media.photoviewer.fragments

import android.content.Context
import android.content.res.Configuration
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.RelativeLayout
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.getcapacitor.JSObject
import com.getcapacitor.community.media.photoviewer.R
import com.getcapacitor.community.media.photoviewer.adapter.Image
import com.getcapacitor.community.media.photoviewer.databinding.ImageFragmentBinding
import com.getcapacitor.community.media.photoviewer.helper.GlideApp
import com.getcapacitor.community.media.photoviewer.helper.ShareImage
import com.ortiz.touchview.TouchImageView

class ImageFragment : Fragment() {
    private val TAG = "ImageFragment"
    private var imageFragmentBinding: ImageFragmentBinding? = null
    private var bShare: Boolean = true
    private var maxZoomScale: Double = 3.0
    private var compressionQuality: Double = 0.8
    private lateinit var appId: String
    private lateinit var ivTouchImage: TouchImageView
    private lateinit var rlMenu: RelativeLayout

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
        ivTouchImage = binding.ivTouchImage
        GlideApp.with(appContext)
            .load(image.url)
            .fitCenter()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            .into(ivTouchImage)

        val share: ImageButton = binding.shareBtn
        val close: ImageButton = binding.closeBtn
        if(!bShare) share.visibility = View.INVISIBLE
        val clickListener = View.OnClickListener { viewFS ->
            when (viewFS.getId()) {
                R.id.shareBtn -> {
                    val mShareImage: ShareImage = ShareImage()
                    mShareImage.shareImage(image, appId, appContext, compressionQuality)
                }
                R.id.closeBtn -> {
                    Log.d(TAG, "click on close")
                    activity?.supportFragmentManager?.beginTransaction()?.remove(this)?.commit();
                }
            }
        }
        share.setOnClickListener(clickListener)
        close.setOnClickListener(clickListener)

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



}
