package com.getcapacitor.community.media.photoviewer.fragments

import android.annotation.SuppressLint
import android.content.Context
import android.content.res.Configuration
import android.net.Uri
import android.os.Bundle
import android.os.Environment
import android.util.Log
import android.view.KeyEvent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.Animation
import android.view.animation.AnimationUtils
import android.widget.ImageButton
import android.widget.RelativeLayout
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.load.model.GlideUrl
import com.bumptech.glide.load.model.LazyHeaders
import com.getcapacitor.JSObject
import com.getcapacitor.community.media.photoviewer.Notifications.NotificationCenter
import com.getcapacitor.community.media.photoviewer.R
import com.getcapacitor.community.media.photoviewer.adapter.Image
import com.getcapacitor.community.media.photoviewer.databinding.ImageFragmentBinding
import com.getcapacitor.community.media.photoviewer.helper.BackgroundColor
import com.getcapacitor.community.media.photoviewer.helper.GlideApp
import com.getcapacitor.community.media.photoviewer.helper.ImageToBeLoaded
import com.getcapacitor.community.media.photoviewer.helper.ShareImage
import com.getcapacitor.community.media.photoviewer.listeners.OnSwipeTouchListener
import com.ortiz.touchview.TouchImageView
import java.io.File

class ImageFragment : Fragment() {
    private val TAG = "ImageFragment"
    private var imageFragmentBinding: ImageFragmentBinding? = null
    private var bShare: Boolean = true
    private var maxZoomScale: Double = 3.0
    private var customHeaders: JSObject = JSObject()
    private var compressionQuality: Double = 0.8
    private var backgroundColor: String = "black"
    private lateinit var appId: String
    private lateinit var ivTouchImage: TouchImageView
    private lateinit var rlMenu: RelativeLayout
    private lateinit var rlLayout: RelativeLayout
    private lateinit var mContext: Context
    private val mFragment = this
    private lateinit var image: Image
    private var startFrom: Int = 0
    private var isZoomed: Boolean = false

    private var options = JSObject()
    var mContainer: ViewGroup? = null
    lateinit var mInflater: LayoutInflater
    lateinit var  appContext: Context
    fun setImage(image: Image) {
        this.image = image
    }

    fun setStartFrom(startFrom: Int) {
        this.startFrom = startFrom
    }


    fun setOptions(options: JSObject) {
        this.options = options
        if(this.options.has("share")) bShare = this.options.getBoolean("share")
        if(this.options.has("maxzoomscale")) maxZoomScale = this.options
            .getDouble("maxzoomscale")
        if(this.options.has("compressionquality")) compressionQuality = this.options
            .getDouble("compressionquality")
        if(this.options.has("backgroundcolor")) backgroundColor = this.options
            .getString("backgroundcolor").toString()
        if (this.options.has("customHeaders")) customHeaders = this.options
            .getJSObject("customHeaders")!!
    }
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        mInflater = inflater
        if (container != null) {
            mContainer  = container
            mContext = container.context
            val view: View = initializeView()
            activity?.runOnUiThread( java.lang.Runnable {
                view.isFocusableInTouchMode = true;
                view.requestFocus();
                view.setOnKeyListener(object: View.OnKeyListener {
                    override fun onKey(v: View?, keyCode: Int, event: KeyEvent): Boolean {
                        // if the event is a key down event on the enter button
                        if (event.action == KeyEvent.ACTION_DOWN &&
                            keyCode == KeyEvent.KEYCODE_BACK
                        ) {
                            backPressed()
                            return true
                        }
                        return false
                    }
                })

            })

            return view
        }
        return null
    }
    private fun backPressed() {
        postNotification()
        activity?.supportFragmentManager?.beginTransaction()?.remove(this)?.commit();
    }
    private fun postNotification() {
        var info: MutableMap<String, Any> = mutableMapOf()
        info["result"] = true
        info["imageIndex"] = startFrom
        NotificationCenter.defaultCenter().postNotification("photoviewerExit", info);
    }
    @SuppressLint("ClickableViewAccessibility")
    private fun initializeView(): View {
        if (mContainer != null) {
            mContainer?.removeAllViewsInLayout()
        }
        appContext = this.requireContext()
        appId = appContext.getPackageName()

        // Inflate the layout for this fragment
        val binding = ImageFragmentBinding.inflate(mInflater, mContainer, false)
        imageFragmentBinding = binding
        val orientation: Int = resources.configuration.orientation
        if(orientation == Configuration.ORIENTATION_PORTRAIT) {
            Log.d(TAG, "orientation Portrait")
        } else {
            Log.d(TAG, "orientation Landscape")
        }
        rlLayout = binding.rlTouchImage

        val mBackgroundColor = BackgroundColor()
        rlLayout.setBackgroundResource(mBackgroundColor.setBackColor(backgroundColor))

        rlMenu = binding.menuBtns
        ivTouchImage = binding.ivTouchImage
        ivTouchImage.setOnTouchListener(object: OnSwipeTouchListener(mContext) {

            override fun onSwipeUp() {
                super.onSwipeUp()
                if(!ivTouchImage.isZoomed) {
                    postNotification()
                    closeFragment("up")
                }
            }
            override fun onSwipeDown() {
                super.onSwipeDown()
                if(!ivTouchImage.isZoomed) {
                    postNotification()
                    closeFragment("down")
                }
            }
        })

        val mImageToBeLoaded = ImageToBeLoaded()
        val toBeLoaded = image.url?.let { mImageToBeLoaded.getToBeLoaded(it) }

        if (toBeLoaded is String) {
            if (toBeLoaded.contains("base64")) {
                GlideApp.with(appContext)
                    .asBitmap()
                    .load(toBeLoaded)
                    .fitCenter()
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .into(ivTouchImage)
            } else {
                // load image from url
                val lazyHeaders = LazyHeaders.Builder()
                for (key in customHeaders.keys()) {
                    customHeaders.getString(key)?.let { lazyHeaders.addHeader(key, it) }
                }
                val glideUrl = GlideUrl(toBeLoaded, lazyHeaders.build())
                GlideApp.with(appContext)
                    .asBitmap()
                    .load(glideUrl)
                    .fitCenter()
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .into(ivTouchImage)
            }
        }
        if (toBeLoaded is File) {
            // load image from file
            GlideApp.with(appContext)
                .asBitmap()
                .load(toBeLoaded)
                .fitCenter()
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .into(ivTouchImage)
        }
        val share: ImageButton = binding.shareBtn
        val close: ImageButton = binding.closeBtn
        if(!bShare) share.visibility = View.INVISIBLE
        activity?.runOnUiThread( java.lang.Runnable {
            val clickListener = View.OnClickListener { viewFS ->
                when (viewFS.getId()) {
                    R.id.shareBtn -> {
                        val mShareImage: ShareImage = ShareImage()
                        mShareImage.shareImage(image, appId, appContext, compressionQuality)
                    }
                    R.id.closeBtn -> {
                        postNotification()
                        closeFragment("no")
                    }
                }
            }
            share.setOnClickListener(clickListener)
            close.setOnClickListener(clickListener)
        })
        return binding.root
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
    private fun closeFragment(swipeDirection: String) {
        if (swipeDirection == "no") {
            activity?.supportFragmentManager?.beginTransaction()?.remove(mFragment)?.commit();
        }
        val animationId = when (swipeDirection) {
            "up" -> R.anim.slide_up
            "down" -> R.anim.slide_down
            else -> return
        }

        // Load the animation
        val slideAnimation = AnimationUtils.loadAnimation(appContext, animationId)
        // Set the animation listener to perform the fragment removal after the animation
        slideAnimation.setAnimationListener(object : Animation.AnimationListener {
            override fun onAnimationStart(animation: Animation?) {}
            override fun onAnimationRepeat(animation: Animation?) {}
            override fun onAnimationEnd(animation: Animation?) {
                // Remove the fragment or perform any other necessary actions
                activity?.supportFragmentManager?.beginTransaction()?.remove(mFragment)?.commit();
            }
        })
        // Start the animation on your view
        ivTouchImage.startAnimation(slideAnimation)
    }
}
