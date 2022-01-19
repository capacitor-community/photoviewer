package com.getcapacitor.community.media.photoviewer.fragments

import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.activity.OnBackPressedCallback
import androidx.core.view.isVisible
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.getcapacitor.JSObject
import com.getcapacitor.community.media.photoviewer.Notifications.NotificationCenter
import com.getcapacitor.community.media.photoviewer.R
import com.getcapacitor.community.media.photoviewer.adapter.Image
import com.getcapacitor.community.media.photoviewer.databinding.FragmentScreenSlidePageBinding
import com.getcapacitor.community.media.photoviewer.databinding.ImageFragmentBinding
import com.getcapacitor.community.media.photoviewer.databinding.MainFragmentBinding
import com.getcapacitor.community.media.photoviewer.helper.CallbackListener
import com.getcapacitor.community.media.photoviewer.helper.GlideApp
import com.getcapacitor.community.media.photoviewer.helper.ShareImage
import java.io.File


class ScreenSlidePageFragment() : Fragment(), CallbackListener {
    private val TAG = "ScreenSlidePageFragment"
    private var sliderFragmentBinding: FragmentScreenSlidePageBinding? = null
    lateinit var tvGalleryTitle: TextView
    lateinit var ivFullscreenImage: ImageView
    lateinit var rlMenu: RelativeLayout
    lateinit var  appContext: Context
    lateinit var image: Image
    lateinit var appId: String
    var mode: String = "one"
    var imageIndex: Int = 0
    var bShare: Boolean = true
    var bTitle: Boolean = true
    var maxZoomScale: Double = 3.0
    var compressionQuality: Double = 0.8
    companion object {
        const val ARG_IMAGE = "image"
        const val ARG_MODE = "mode"
        const val ARG_IMAGEINDEX = "imageIndex"
        const val ARG_SHARE = "share"
        const val ARG_TITLE = "title"
        const val ARG_MAXZOOMSCALE = "maxzoomscale"
        const val ARG_COMPRESSIONQUALITY = "compressionquality"

        fun getInstance(image: Image, mode: String, imageIndex: Int, bShare: Boolean,
                        bTitle: Boolean, maxZoomScale: Double, compressionQuality: Double)
                        : Fragment {
            val screenSlidePageFragment = ScreenSlidePageFragment()
            val bundle = Bundle()
            bundle.putParcelable(ARG_IMAGE, image)
            bundle.putString(ARG_MODE, mode)
            bundle.putInt(ARG_IMAGEINDEX, imageIndex)
            bundle.putBoolean(ARG_SHARE, bShare)
            bundle.putBoolean(ARG_TITLE, bTitle)
            bundle.putDouble(ARG_MAXZOOMSCALE, maxZoomScale)
            bundle.putDouble(ARG_COMPRESSIONQUALITY, compressionQuality)
            screenSlidePageFragment.arguments = bundle
            return screenSlidePageFragment
        }
    }


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val binding = FragmentScreenSlidePageBinding
            .inflate(inflater, container, false)
        sliderFragmentBinding = binding
        image = requireArguments().getParcelable<Image>(ARG_IMAGE)!!
        mode = requireArguments().getString(ARG_MODE).toString()
        imageIndex = requireArguments().getInt(ARG_IMAGEINDEX)
        bShare = requireArguments().getBoolean(ARG_SHARE)
        bTitle = requireArguments().getBoolean(ARG_TITLE)
        maxZoomScale = requireArguments().getDouble(ARG_MAXZOOMSCALE)
        compressionQuality = requireArguments().getDouble(ARG_COMPRESSIONQUALITY)
        appContext = this.requireContext()
        appId = appContext.getPackageName()

        rlMenu = binding.menuBtns
        tvGalleryTitle = binding.tvGalleryTitle
        if(!bTitle) tvGalleryTitle.visibility = View.INVISIBLE
        ivFullscreenImage = binding.ivFullscreenImage
        tvGalleryTitle.text = image.title

        GlideApp.with(appContext)
            .load(image.url)
            .fitCenter()
            .diskCacheStrategy(DiskCacheStrategy.ALL)
            .into(ivFullscreenImage)
//        container?.addView(binding.root)

        val share: ImageButton = binding.shareBtn
        val close: ImageButton = binding.closeBtn
        if(!bShare) share.visibility = View.INVISIBLE
        val onBackPressedCallback: OnBackPressedCallback = object : OnBackPressedCallback(true) {
          override fun handleOnBackPressed() {
            if (mode == "slider") {
              postNotification()
            }
            closeFragment()
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
                closeFragment()
              }
            }
          }
          share.setOnClickListener(clickListener)
          close.setOnClickListener(clickListener)
          ivFullscreenImage.setOnClickListener(clickListener)
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
        activity?.let { touchViewFragment.show(it.supportFragmentManager, "touchview") }
    }
    private fun toggleMenu() {
        rlMenu.isVisible = !rlMenu.isVisible
    }

    private fun closeFragment() {
      val fragment = activity?.supportFragmentManager?.findFragmentByTag("gallery")
        fragment?.parentFragmentManager?.beginTransaction()?.remove(fragment)?.commit()
    }
}


