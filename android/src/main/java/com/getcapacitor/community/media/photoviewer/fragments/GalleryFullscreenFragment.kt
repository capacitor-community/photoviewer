package com.getcapacitor.community.media.photoviewer.fragments

import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import androidx.viewpager2.adapter.FragmentStateAdapter
import androidx.viewpager2.widget.ViewPager2
import com.getcapacitor.JSObject
import com.getcapacitor.community.media.photoviewer.Notifications.NotificationCenter
import com.getcapacitor.community.media.photoviewer.adapter.Image
import com.getcapacitor.community.media.photoviewer.databinding.FragmentGalleryFullscreenBinding
import com.getcapacitor.community.media.photoviewer.helper.DepthPageTransformer
import com.getcapacitor.community.media.photoviewer.helper.ZoomOutPageTransformer

class GalleryFullscreenFragment: DialogFragment() {
    private val TAG = "GalleryFullscrFragment"
    private var fsFragmentBinding: FragmentGalleryFullscreenBinding? = null
    private var imageList: ArrayList<Image> = ArrayList()
    private var selectedPosition: Int = 0
    private var transformer: String = "zoom"
    private var backgroundColor: String = "black"
    private var mode: String = "gallery"
    private var bShare: Boolean = true
    private var bTitle: Boolean = true
    private var maxZoomScale: Double = 3.0
    private var compressionQuality: Double = 0.8
    private lateinit var viewPager: ViewPager2
    private lateinit var curTransf: ViewPager2.PageTransformer
    private var options = JSObject()

    fun setImageList(imageList: ArrayList<Image>) {
        this.imageList = imageList
    }
    fun setMode(mode: String) {
        this.mode = mode
    }
    fun setStartFrom(position: Int) {
        this.selectedPosition = position
    }
    fun setOptions(options: JSObject) {
        this.options = options
        if(this.options.has("transformer")) transformer = this.options
            .getString("transformer").toString()
        if(this.options.has("share")) bShare = this.options.getBoolean("share")
        if(this.options.has("title")) bTitle = this.options.getBoolean("title")
        if(this.options.has("maxzoomscale")) maxZoomScale = this.options
            .getDouble("maxzoomscale")
        if(this.options.has("compressionquality")) compressionQuality = this.options
            .getDouble("compressionquality")
        if(this.options.has("backgroundcolor")) backgroundColor = this.options
            .getString("backgroundcolor").toString()
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val binding = FragmentGalleryFullscreenBinding
            .inflate(inflater, container, false)
        fsFragmentBinding = binding
        viewPager = binding.viewPager
        val pagerAdapter = ScreenSlidePagerAdapter(this)
        viewPager.adapter = pagerAdapter
        setCurrentItem(selectedPosition)
        curTransf = ZoomOutPageTransformer()
        if(transformer.equals("depth")) curTransf = DepthPageTransformer()
        viewPager.setPageTransformer(curTransf)

        val view = binding.root
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

    private fun backPressed() {
        if(mode == "slider") {
            postNotification()
        }
        activity?.supportFragmentManager?.beginTransaction()?.remove(this)?.commit()
    }

    override fun onDestroyView() {
        fsFragmentBinding = null
        super.onDestroyView()
    }
    private fun postNotification() {
        var info: MutableMap<String, Any> = mutableMapOf()
        info["result"] = true
        info["imageIndex"] = selectedPosition
        NotificationCenter.defaultCenter().postNotification("photoviewerExit", info);
    }

    private fun setCurrentItem(position: Int) {
        viewPager.setCurrentItem(position, false)
    }

    private inner class ScreenSlidePagerAdapter(fa: DialogFragment) : FragmentStateAdapter(fa) {
        override fun getItemCount(): Int = imageList.size

        override fun createFragment(position: Int): Fragment {
            val image: Image = imageList.get(position)
            return ScreenSlidePageFragment.getInstance(image, mode, position, bShare, bTitle, maxZoomScale,
                compressionQuality, backgroundColor)

        }
    }

}
