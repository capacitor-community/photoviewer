package com.getcapacitor.community.media.photoviewer.fragments

import android.annotation.SuppressLint
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Build.VERSION.SDK_INT
import android.os.Bundle
import android.os.Parcelable
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.Animation
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.activity.OnBackPressedCallback
import androidx.core.view.isVisible
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.bumptech.glide.load.model.GlideUrl
import com.bumptech.glide.load.model.LazyHeaders
import com.getcapacitor.JSObject
import com.getcapacitor.community.media.photoviewer.Notifications.NotificationCenter
import com.getcapacitor.community.media.photoviewer.R
import com.getcapacitor.community.media.photoviewer.adapter.Image
import com.getcapacitor.community.media.photoviewer.databinding.FragmentScreenSlidePageBinding
import com.getcapacitor.community.media.photoviewer.helper.*
import com.getcapacitor.community.media.photoviewer.listeners.OnSwipeTouchListener
import java.io.File
import android.view.animation.AnimationUtils

class ScreenSlidePageFragment() : Fragment(), CallbackListener {
    private val TAG = "ScreenSlidePageFragment"
    private var sliderFragmentBinding: FragmentScreenSlidePageBinding? = null
    lateinit var tvGalleryTitle: TextView
    lateinit var ivFullscreenImage: ImageView
    lateinit var rlMenu: RelativeLayout
    lateinit var rlFullscreen: RelativeLayout
    lateinit var  appContext: Context
    lateinit var image: Image
    lateinit var appId: String
    var mode: String = "one"
    var imageIndex: Int = 0
    var bShare: Boolean = true
    var bTitle: Boolean = true
    var maxZoomScale: Double = 3.0
    var compressionQuality: Double = 0.8
    var backgroundColor: String = "black"
    var customHeaders: JSObject = JSObject()

    companion object {
        const val ARG_IMAGE = "image"
        const val ARG_MODE = "mode"
        const val ARG_IMAGEINDEX = "imageIndex"
        const val ARG_SHARE = "share"
        const val ARG_TITLE = "title"
        const val ARG_MAXZOOMSCALE = "maxzoomscale"
        const val ARG_COMPRESSIONQUALITY = "compressionquality"
        const val ARG_BACKGROUNDCOLOR = "backgroundcolor"
        const val ARG_CUSTOMHEADERS = "customHeaders"

        inline fun <reified T : Parcelable> Bundle.parcelable(key: String): T? = when {
            SDK_INT >= 33 -> getParcelable(key, T::class.java)
            else -> @Suppress("DEPRECATION") getParcelable(key) as? T
        }

        fun getInstance(image: Image, mode: String, imageIndex: Int, bShare: Boolean,
                        bTitle: Boolean, maxZoomScale: Double, compressionQuality: Double,
                        backgroundColor: String, customHeaders: JSObject): Fragment {
            val screenSlidePageFragment = ScreenSlidePageFragment()
            val bundle = Bundle()
            bundle.putParcelable(ARG_IMAGE, image)
            bundle.putString(ARG_MODE, mode)
            bundle.putInt(ARG_IMAGEINDEX, imageIndex)
            bundle.putBoolean(ARG_SHARE, bShare)
            bundle.putBoolean(ARG_TITLE, bTitle)
            bundle.putDouble(ARG_MAXZOOMSCALE, maxZoomScale)
            bundle.putDouble(ARG_COMPRESSIONQUALITY, compressionQuality)
            bundle.putString(ARG_BACKGROUNDCOLOR, backgroundColor)
            bundle.putString(ARG_CUSTOMHEADERS, customHeaders.toString())
            screenSlidePageFragment.arguments = bundle
            return screenSlidePageFragment
        }
    }


    @SuppressLint("ClickableViewAccessibility")
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val binding = FragmentScreenSlidePageBinding
            .inflate(inflater, container, false)
        sliderFragmentBinding = binding
        if (SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            image = requireArguments().getParcelable(ARG_IMAGE,Image::class.java)!!
        } else {
          image = requireArguments().getParcelable<Image>(ARG_IMAGE)!!
        }
        mode = requireArguments().getString(ARG_MODE).toString()
        imageIndex = requireArguments().getInt(ARG_IMAGEINDEX)
        bShare = requireArguments().getBoolean(ARG_SHARE)
        bTitle = requireArguments().getBoolean(ARG_TITLE)
        maxZoomScale = requireArguments().getDouble(ARG_MAXZOOMSCALE)
        compressionQuality = requireArguments().getDouble(ARG_COMPRESSIONQUALITY)
        backgroundColor= requireArguments().getString(ARG_BACKGROUNDCOLOR).toString()
        customHeaders = JSObject(requireArguments().getString(ARG_CUSTOMHEADERS))
        appContext = this.requireContext()
        appId = appContext.getPackageName()
        rlFullscreen = binding.rlFullscreenImage
        val mBackgroundColor = BackgroundColor()
        val backColor: Int = mBackgroundColor.setBackColor(backgroundColor)
        rlFullscreen.setBackgroundResource(backColor)

        rlMenu = binding.menuBtns
        tvGalleryTitle = binding.tvGalleryTitle
        ivFullscreenImage = binding.ivFullscreenImage
        ivFullscreenImage.setBackgroundResource(backColor)
        tvGalleryTitle.text = image.title ?: ""
        if(!bTitle || tvGalleryTitle.text.isEmpty()) tvGalleryTitle.visibility = View.INVISIBLE

        val mImageToBeLoaded = ImageToBeLoaded()
        val toBeLoaded = image.url?.let { mImageToBeLoaded.getToBeLoaded(it) }

        if (toBeLoaded is String) {
            if (toBeLoaded.contains("base64")) {
                GlideApp.with(appContext)
                    .asBitmap()
                    .load(toBeLoaded)
                    .fitCenter()
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .into(ivFullscreenImage)
            } else {
                // load image from url
                val lazyHeaders = LazyHeaders.Builder()
                for (key in customHeaders.keys()) {
                    customHeaders.getString(key)?.let { lazyHeaders.addHeader(key, it) }
                }
                val glideUrl = GlideUrl(toBeLoaded, lazyHeaders.build())
                GlideApp.with(appContext)
                    .load(glideUrl)
                    .fitCenter()
                    .diskCacheStrategy(DiskCacheStrategy.ALL)
                    .into(ivFullscreenImage)
            }
        }
        if (toBeLoaded is File) {
            // load image from file
            GlideApp.with(appContext)
                .asBitmap()
                .load(toBeLoaded)
                .fitCenter()
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .into(ivFullscreenImage)
        }

        val share: ImageButton = binding.shareBtn
        val close: ImageButton = binding.closeBtn
        if(!bShare) share.visibility = View.INVISIBLE
        val onBackPressedCallback: OnBackPressedCallback = object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                if (mode == "slider") {
                    postNotification()
                }
                closeFragment("no")
            }
        }
        activity?.onBackPressedDispatcher?.addCallback(viewLifecycleOwner, onBackPressedCallback)

        activity?.runOnUiThread( Runnable {
            binding.root.isFocusableInTouchMode = true;
            binding.root.requestFocus();

            val clickListener = View.OnClickListener { viewFS ->
                when (viewFS.getId()) {
                    R.id.shareBtn -> {
                        val mShareImage: ShareImage = ShareImage()
                        mShareImage.shareImage(image, appId, appContext, compressionQuality)
                    }
                    R.id.ivFullscreenImage -> {
                        toggleMenu()
                        showTouchView()
                    }
                    R.id.closeBtn -> {
                        if( mode =="slider") {
                            postNotification()
                        }
                        closeFragment("no")
                    }
                }
            }

            share.setOnClickListener(clickListener)
            close.setOnClickListener(clickListener)
            ivFullscreenImage.setOnClickListener(clickListener)
            ivFullscreenImage.setOnTouchListener(object: OnSwipeTouchListener(appContext) {
                override fun onSwipeUp() {
                    super.onSwipeUp()
                    if( mode =="slider") {
                        postNotification()
                    }
                    closeFragment("up")
                }
                override fun onSwipeDown() {
                    super.onSwipeDown()
                    if( mode =="slider") {
                        postNotification()
                    }
                    closeFragment("down")
                }
            })

        })

        return binding.root
    }

    override fun onMenuToggle() {
        toggleMenu()
    }
    override fun onDestroyView() {
        sliderFragmentBinding = null
        super.onDestroyView()
    }
    private fun postNotification() {
        var info: MutableMap<String, Any> = mutableMapOf()
        info["result"] = true
        info["imageIndex"] = imageIndex
        NotificationCenter.defaultCenter().postNotification("photoviewerExit", info);
    }

    private fun showTouchView() {
        val touchViewFragment = TouchViewFragment(this)
        touchViewFragment.setStyle(DialogFragment.STYLE_NORMAL, R.style.Dialog_FullScreen)
        image.url?.let { touchViewFragment.setUrl(it) }
        backgroundColor.let {touchViewFragment.setBackgroundColor(it) }
        activity?.let { touchViewFragment.show(it.supportFragmentManager, "touchview") }
    }
    private fun toggleMenu() {
        rlMenu.isVisible = !rlMenu.isVisible
    }

    private fun closeFragment(swipeDirection: String) {
        if (swipeDirection == "no") {
            val fragment = activity?.supportFragmentManager?.findFragmentByTag("gallery")
            fragment?.parentFragmentManager?.beginTransaction()?.remove(fragment)?.commit()
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
                val fragment = activity?.supportFragmentManager?.findFragmentByTag("gallery")
                fragment?.parentFragmentManager?.beginTransaction()?.remove(fragment)?.commit()
            }
        })
        // Start the animation on your view
        ivFullscreenImage.startAnimation(slideAnimation)
    }
}


